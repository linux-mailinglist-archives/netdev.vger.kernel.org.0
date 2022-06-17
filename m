Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD35F54FB09
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383249AbiFQQ2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 12:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383265AbiFQQ23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 12:28:29 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EDA13FAE
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:28:27 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id c189so5058068iof.3
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7HjaAAACCFxI3gNeFZT3nSQ7cuEF7BokQiOUoNuWggM=;
        b=VZYMnqN+jSNlDuRpl9BvxOEGH51tDXVE+cJmIDkTZFetXD6lq9LoklzZaBy6Hiqlat
         T7HfrOwtfULVrshTDCu3esv2spdO7oUCzqcIDaqH9gGLRUfU6Bk1tedDKjzTsi1NF6+C
         sXNetIXjpFtrao6rX9YY08aWXLx56NJLT2Ju8IzSV9bk9hpIsBvHG+88Jg0Ukvz0WzX1
         xGVK9MvCIwh92v0dGtuJtjbT4YJ2ISRJIUjLnG+1Cs4EAwyLlCE3kc9GggIUb6SBt8pE
         BWUnRjYzC/oF/Nb0o3AWUjwopl536OuaoStApc8GMSxBD0HCesFJV8Xrf96s+Y29Eite
         bllA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7HjaAAACCFxI3gNeFZT3nSQ7cuEF7BokQiOUoNuWggM=;
        b=MK9n8nYP5WvZJgSg27Sx2GbcuRJu5aRG5p1C9wSXU+ZfLrKba3jhce8chpEofB+yL8
         W8qFRklagGUZwgmoXYlqMznD1j5cIKRjx4qAg7R/j9gKr6YF51TJ8TvPVOangaGD6yHz
         0+ynURaaCLmp8jnguDR6n5nLs4WxyiWhGjTnIiwtdCxXirUvRi+hqk8oGvLVYMcjoMGv
         yBCPqSi4Uvyz1KCZB00achdbDZmjqDy/kyiM+OFRfrc/t8O46v0H8EfO2FcdplRN0c0f
         3J7+fFXvsrci2tyzxVv7h0cMGYVhTnah/LXmQXJ2VjOCVmUE7QbU3qf0Hlv52dwgtaJE
         R/ew==
X-Gm-Message-State: AJIora/NrTuD5X3PpmRN31q2lHHo1arowqPIm/OFdbLZC26IVAxc5rBb
        3BKLpNzCb4urF9kflpexGXw=
X-Google-Smtp-Source: AGRyM1s/tsAwW4d0tbzFwBnQWnIr/tn+GmLDv69Rz1SznfPeQ3LJlum4IyVFkKwBpjJ3+cPaXWCrxw==
X-Received: by 2002:a05:6638:3002:b0:32d:acc7:4a7a with SMTP id r2-20020a056638300200b0032dacc74a7amr6064699jak.14.1655483307002;
        Fri, 17 Jun 2022 09:28:27 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:6c50:af42:34c6:3055? ([2601:282:800:dc80:6c50:af42:34c6:3055])
        by smtp.googlemail.com with ESMTPSA id 67-20020a6b0146000000b006696e2a339asm2733976iob.16.2022.06.17.09.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 09:28:26 -0700 (PDT)
Message-ID: <b0246015-7fe6-7f30-c5ae-5531c126366f@gmail.com>
Date:   Fri, 17 Jun 2022 10:28:24 -0600
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


FWIW, net/ipv4/nexthop.c sets cb->seq at the end of the loop and the
nl_dump_check_consistent follows that.
