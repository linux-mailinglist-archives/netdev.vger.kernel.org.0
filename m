Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A787354FAF1
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 18:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383217AbiFQQRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 12:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383034AbiFQQRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 12:17:08 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487F825C46
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:17:07 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y79so5023588iof.2
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mxwcVRdF+hT5FbM92tTONRGMey7BXY3OeJY6JbGIULA=;
        b=aqK9Vv/4BtyXPY52iRCoRQYKXx1kXeCPdDmDc9ULJ3Rif/Ut8KTReb8klF8at4yc2L
         9Hqpv3Tw/kc/9dErbYCLrgnf+uSgwEJxUkAKiLOl/H2Xjl88hXbdfXzhwxCh6b7bIcTs
         Y38tHIMQuzL0y+8Aniv7EJfdpHa4IvgmA2jDXM9K65VHUuXSRhTpZ07If8HWvnl/mj05
         lUdI4tomnMsFl3q5CnZo2x1IaC3lKBh4oA71fP07owq4/HBA7d6zsphK0ge0JLM3EeMT
         nRWLzh5O2jYrwkgGbk04F/w2hQjy9o0QwICNF6zohEYtMJdVFiAB0mUXBZIFIEsK/STj
         /8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mxwcVRdF+hT5FbM92tTONRGMey7BXY3OeJY6JbGIULA=;
        b=cHK/Ngir0k4gM1Zqn2qFTs5juK9aMubSJfskcx3sJD4oFYFTdL+alDkhhBhU7Utyew
         wxxTHGcaF0M5sWYhLF7alxHpMtv9gVMSWD1nHaz42Bo/0GttyF53DuzG5Yg9wkvSutJR
         dFKAz96rBmbSGYh6/cziJRZsJLxxBfL7Ad5FzDdm8TerKQanRY3e+EfdhSaJ2HY8GkSA
         DjOuVr9WZxeJKAIWAoee6jlike+2ph/+gW77AgfXvIC6HcAK78ZbiJ0vXLzjYSRKk7Tq
         hKumiB2iagMZCYioRut0rCjEpa7oMwiwQz/AddVpQONtGA0J+GbqOuzk01GT55behE8S
         mubQ==
X-Gm-Message-State: AJIora+pIe/yur5JknAEzV9gIbI0O3i+HSpb6d1nHcIgIa8jKEE7p3Vt
        9FAMSveAiXGcvpGA+TdSoEE=
X-Google-Smtp-Source: AGRyM1tZXkQqJ3kZCVmW1U94pWtYh6noAlX0YtRnpTgcDvMcTPLw6UzVAHeAMZyvDS0cXIpGk3Bmfw==
X-Received: by 2002:a05:6602:c3:b0:64f:d28f:a62c with SMTP id z3-20020a05660200c300b0064fd28fa62cmr5249691ioe.212.1655482626723;
        Fri, 17 Jun 2022 09:17:06 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:6c50:af42:34c6:3055? ([2601:282:800:dc80:6c50:af42:34c6:3055])
        by smtp.googlemail.com with ESMTPSA id l10-20020a056e02066a00b002d3ad9791dcsm2491778ilt.27.2022.06.17.09.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 09:17:06 -0700 (PDT)
Message-ID: <38ebe747-f65f-3b03-d089-86f454c78584@gmail.com>
Date:   Fri, 17 Jun 2022 10:17:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ismael Luceno <iluceno@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220615171113.7d93af3e@pirotess>
 <20220615090044.54229e73@kernel.org> <20220616171016.56d4ec9c@pirotess>
 <20220616171612.66638e54@kernel.org> <20220617150110.6366d5bf@pirotess>
 <9598e112-55b5-a8c0-8a52-0c0f3918e0cd@gmail.com>
 <20220617082225.333c5223@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220617082225.333c5223@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/22 9:22 AM, Jakub Kicinski wrote:
> On Fri, 17 Jun 2022 08:55:53 -0600 David Ahern wrote:
>>> No, I'm concerned that while in the dumping loop, the table might
>>> change between iterations, and if this results in the loop not finding
>>> more entries, because in most these functions there's no
>>> consistency check after the loop, this will go undetected.  
>>
>> Specific example? e.g., fib dump and address dumps have a generation id
>> that gets recorded before the start of the dump and checked at the end
>> of the dump.
> 
> FWIW what I think is strange is that we record the gen id before the
> dump and then check if the recorded version was old. Like.. what's the
> point of that? Nothing updates cb->seq while dumping AFAICS, so the

while dumping, no, because the rtnl is locked.

The genid is used across syscalls when dumping a table that does not fit
within a 64kB message.


> code is functionally equivalent to this right?
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 92b778e423df..0cd7482dc1f0 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -2259,6 +2259,7 @@ static int inet_netconf_dump_devconf(struct sk_buff *skb,
>  		rcu_read_lock();
>  		cb->seq = atomic_read(&net->ipv4.dev_addr_genid) ^
>  			  net->dev_base_seq;
> +		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
>  		hlist_for_each_entry_rcu(dev, head, index_hlist) {
>  			if (idx < s_idx)
>  				goto cont;
> @@ -2276,7 +2277,6 @@ static int inet_netconf_dump_devconf(struct sk_buff *skb,
>  				rcu_read_unlock();
>  				goto done;
>  			}
> -			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
>  cont:
>  			idx++;
>  		}
> 
> 

