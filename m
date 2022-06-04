Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8246453D7F5
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 18:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbiFDQzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 12:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiFDQzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 12:55:15 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94084193FC
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 09:55:14 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id e11-20020a9d6e0b000000b0060afcbafa80so7689697otr.3
        for <netdev@vger.kernel.org>; Sat, 04 Jun 2022 09:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZumGXwmkKCZw7zAdFkot1A/Xnxwq0a7hOWfoxoDKoQ8=;
        b=QQs2MgcRI6yP5EnNAHZzZ9lmKYEXyravNG82OpADwUeN49SRjTsJD7jkysatQWJRTC
         j2ZakeqAzvQ+HR4NXCAw3EqRLoDOIhxK7HyNuCaSLNLF3kO+rzn1pI7u+KpdVH79oIKj
         jOgJ4rmoqGpMrV2rhfP04uoYiwQxvsXTHlM6vc9XRmjd55ebEf/hdZy3/EawKuFoaCDN
         9nlXIuGQ1q7n3Rw459DMYT4FMK273EPHZ1LQvWwhxNm4ehdYaq2FkQ2i7dgVRqojqqIK
         hSKnoTHn6bzQK3CJ+vrA9eJUwUlnj97GD5Btf+e1vLb4XJO728B3zwN65Gaf611Q7tfe
         hCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZumGXwmkKCZw7zAdFkot1A/Xnxwq0a7hOWfoxoDKoQ8=;
        b=HSRNS1uM01CJpzwT3SL7SBwbtWA/nm5Hgl4J72w3aO+M+YKnKyvC1biG0s/ij0JqwQ
         RKWnlS1PkwtLtgYt/g56RnmguL+Un/MrM6kpj3rcpM7eInpte4E50vq0dbizXt2KeGTW
         enrN6nxcy23c6YSYPYM/L92Q19Adz9Qq2h8Mx10OcGYBePgjT/D3mVJh2lB5XUuwBWyI
         vaLAscVEUgMrD07M41wVstnvG7l5Lf9QXqEXu1bCb9zwmrEl8mGzE1wyLaz6pD1I8zVp
         QN26EryqHBgT1rCAzYCYuWiFpYnyA6FxWyaUuk8uvpnD1fGTtbFbH+0aE+0iCpuUej0Z
         2A4w==
X-Gm-Message-State: AOAM532MZ1V9uSJqqqnen9hggdIEtcSMacHDxpCu18GtiJ+0q3b3L02q
        EmDNAoDeZx+rXPJWVXcMSW4=
X-Google-Smtp-Source: ABdhPJw41iuEgVIWDqlfOwlAoi7teuzZjmtkpVfHRHE3ovkWmjzuF1Wsv/8jdEimiyc67CtfMqHK8w==
X-Received: by 2002:a9d:76d0:0:b0:60b:53e5:6640 with SMTP id p16-20020a9d76d0000000b0060b53e56640mr6570158otl.241.1654361713977;
        Sat, 04 Jun 2022 09:55:13 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id k84-20020aca3d57000000b0032e2599df3dsm5165944oia.10.2022.06.04.09.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jun 2022 09:55:13 -0700 (PDT)
Message-ID: <d33dbbe6-57b0-85a1-83f8-435dd0a7c8c9@gmail.com>
Date:   Sat, 4 Jun 2022 10:55:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC] Backporting "add second dif to raw, inet{6,}, udp,
 multicast sockets" to LTS 4.9
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Petr Vorel <pvorel@suse.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <YppqNtTmqjeR5cZV@pevik> <YpsvAludRUxuK22U@kroah.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YpsvAludRUxuK22U@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/22 4:08 AM, Greg Kroah-Hartman wrote:
> On Fri, Jun 03, 2022 at 10:08:22PM +0200, Petr Vorel wrote:
>> Hi all,
>>
>> David (both), would it be possible to backport your commits from merge
>> 9bcb5a572fd6 ("Merge branch 'net-l3mdev-Support-for-sockets-bound-to-enslaved-device'")
>> from v4.14-rc1 to LTS 4.9?
>>
>> These commits added second dif to raw, inet{6,}, udp, multicast sockets.
>> The change is not a fix but a feature - significant change, therefore I
>> understand if you're aginast backporting it.
>>
>> My motivation is to get backported to LTS 4.9 these fixes from v5.17 (which
>> has been backported to all newer stable/LTS trees):
>> 2afc3b5a31f9 ("ping: fix the sk_bound_dev_if match in ping_lookup")
>> 35a79e64de29 ("ping: fix the dif and sdif check in ping_lookup")
>> cd33bdcbead8 ("ping: remove pr_err from ping_lookup")
>>
>> which fix small issue with IPv6 in ICMP datagram socket ("ping" socket).
>>
>> These 3 commits depend on 9bcb5a572fd6, particularly on:
>> 3fa6f616a7a4d ("net: ipv4: add second dif to inet socket lookups")
>> 4297a0ef08572 ("net: ipv6: add second dif to inet6 socket lookups")
> 
> Can't the fixes be backported without the larger api changes needed?
> 
> If not, how many commits are you trying to backport here?  And there's
> no need for David to do this work if you need/want these fixes merged.
> 

I think you will find it is a non-trivial amount of work to backport the
listed patches and their dependencies to 4.9. That said, the test cases
exist in selftests to give someone confidence that it works properly
(you will have to remove tests that are not relevant for the
capabilities in 4.9).
