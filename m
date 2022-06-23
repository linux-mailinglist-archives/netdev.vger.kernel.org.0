Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4D35571A2
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiFWEkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245495AbiFWEBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:01:43 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E102D1F4
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:01:41 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z191so2282815iof.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pIuuJCIOPINbZ7MSWv+gYAnGoerpTn0hH0+cLJdnlGE=;
        b=k0vamO9pEpEZwjR2RihStzSnP7iUHyR7dTlA0PrDNvsYPJcthptOpwumWoSNyUfI1a
         OFbQUzmFn9Gdu3toHUD1i0HQvfWDPAD7hYGXFaB5K5p6buaadN+qpolAWM+sIWq+ByNq
         Eend53sgNN/Sxz7T908sJPKDdGOChh7PWOenllY+0o33jQ93Bv4MNMDqJBtFN9q1h81p
         Z8YE64WZ6M7rsAa28GZID/WKOb59NKV9wpkU19J80MC9n8HWCZe4FG6pz7Jz4kJ/GdmD
         D4bkCBppZSTDlvTmHbyHIXt0LROR7VqZWY3CEiDi08H7Udfqzh7WZQ+CBxKeYaoAOpb0
         ATmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pIuuJCIOPINbZ7MSWv+gYAnGoerpTn0hH0+cLJdnlGE=;
        b=KSVkg40nObBmVz7w7MSqs7vqvooSdjJSSWcuiV0aA+8oq+Vk6i6HvZssRV++qYguV7
         b74DXOLd3KTsGP36QPJxOyOFSHNpoHAyFRYV24TgJ/NE73XhoqxnBCIp8p2BL2iUevin
         8gayYtQeP8VTZTKcr8Kd7x3fnf7X8YziHMHHawltvLhm6386smfukZf1xh8KOhtyV65G
         v4drzwTxyKXSN7v/iUDMNen/xxkcdXupcyo6ZeUom5qGChusXEixtIerJ8s72ozaCqhu
         fkYc+rEOoF1WQL3zeNfyP1JEbBdvNdqWq82+5Pbk6Hww6NRIdymRCe0/3xi18r8FW1Bu
         5eZw==
X-Gm-Message-State: AJIora8XEOSblfFqbbU3/Do0gHYm8dnMYtCKHoXNLx1bY3I8j1rXrMOk
        nUZ1dTHcLu9ZJF/Jpj3/pdo=
X-Google-Smtp-Source: AGRyM1sj6BV5qY9phOviqq+ZUt1T/NiyZUBtQMlDY0H/+y3IdBWQa24CCDHUuRyf5p722KM86fXjIA==
X-Received: by 2002:a5d:9345:0:b0:66c:d57a:d06 with SMTP id i5-20020a5d9345000000b0066cd57a0d06mr3585198ioo.56.1655956900251;
        Wed, 22 Jun 2022 21:01:40 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:a54b:f51d:f163:ba49? ([2601:282:800:dc80:a54b:f51d:f163:ba49])
        by smtp.googlemail.com with ESMTPSA id n11-20020a6b410b000000b00672f405e911sm628565ioa.38.2022.06.22.21.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 21:01:39 -0700 (PDT)
Message-ID: <fef8b8d5-e07d-6d8f-841a-ead4ebee8d29@gmail.com>
Date:   Wed, 22 Jun 2022 22:01:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Ismael Luceno <iluceno@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220615171113.7d93af3e@pirotess>
 <20220615090044.54229e73@kernel.org> <20220616171016.56d4ec9c@pirotess>
 <20220616171612.66638e54@kernel.org> <20220617150110.6366d5bf@pirotess>
 <20220622131218.1ed6f531@pirotess> <20220622165547.71846773@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220622165547.71846773@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/22 5:55 PM, Jakub Kicinski wrote:
> On Wed, 22 Jun 2022 13:12:18 +0200 Ismael Luceno wrote:
>> So, just for clarification:
>>
>> Scenario 1:
>> - 64 KB packet is filled.
>> - protocol table shrinks
>> - Next iteration finds it's done
>> - next protocol clears the seq, so nothing is flaged
>> - ...
>> - NLMSG_DONE (not flagged)
>>
>> Scenario 2:
>> - 64 KB packet is filled.
>> - protocol table shrinks
>> - Next iteration finds it's done
>> - NLMSG_DONE (flagged with NLM_F_DUMP_INTR)
>>
>> So, in order to break as little as possible, I was thinking about
>> introducing a new packet iff it happens we have to signal INTR between
>> protocols.
>>
>> Does that sound good?
> 
> Right, the question is what message can we introduce here which would
> not break old user space?

I would hope a "normal" message with just the flags set is processed by
userspace. iproute2 does - lib/libnetlink.c, rtnl_dump_filter_l(). It
checks the nlmsg_flags first.

> 
> The alternative of not wiping the _DUMP_INTR flag as we move thru
> protocols seems more and more appealing, even tho I was initially
> dismissive.
> 
> We should make sure we do one last consistency check before we return 0
> from the handlers. Or even at the end of the loop in rtnl_dump_all().

Seems like netlink_dump_done should handle that for the last dump?

That said, in rtnl_dump_all how about a flags check after dumpit() and
send the message if INTR is set? would need to adjust the return code of
rtnl_dump_all so netlink_dump knows the dump is not done yet.


