Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18F861506F
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 18:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiKARTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 13:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiKARTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 13:19:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACF31ADB1;
        Tue,  1 Nov 2022 10:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99D99B81E94;
        Tue,  1 Nov 2022 17:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2301C433C1;
        Tue,  1 Nov 2022 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667323154;
        bh=lfPoEEftUZlMenC9khV7toov5g+JQfpa6hsi3HYXnUg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ME2eDAtxCFdnCDNfuEQb9c1pt6pxplc9tNMzA+vmQsRiwmso4dmmOvfXqpUfzxoQk
         o4+FZPj8GExOPlPooJj3rNSLcQxaxSaHUydjkJkAZNiEwrewPmfSwTWGH0iff8QMKZ
         2w2S9XRZ/5Wac9g6GOpVUK07l6DNX/RE9dpm2f/tTEFigSsh8EQasTACRL8JXzKQ/m
         WixTo3iyIX7x3aSLLKAX4IPMdQ526yuAbC3RDKfIScrFSub2Pf2JXrxsXuH+zUoEZP
         xQy31M9YU5/zbrOMcMl1BJorfPef/2p+hJQoN5h6bLSCEAXs5skEt0W8ItwCj+S8nG
         Bhj2P8ytFhtGQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ath11k (gcc13): synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
References: <20221031114341.10377-1-jirislaby@kernel.org>
        <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
        <833c7f2f-c140-5a0b-1efc-b858348206ec@kernel.org>
        <87bkprgj0b.fsf@kernel.org>
        <503a3b36-2256-a9ce-cffe-5c0ed51f6f62@infradead.org>
Date:   Tue, 01 Nov 2022 19:19:08 +0200
In-Reply-To: <503a3b36-2256-a9ce-cffe-5c0ed51f6f62@infradead.org> (Randy
        Dunlap's message of "Tue, 1 Nov 2022 07:54:16 -0700")
Message-ID: <87tu3ifv8z.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> On 11/1/22 01:45, Kalle Valo wrote:
>> Jiri Slaby <jirislaby@kernel.org> writes:
>> 
>>> On 31. 10. 22, 22:16, Jeff Johnson wrote:
>>>
>>>> On 10/31/2022 4:43 AM, Jiri Slaby (SUSE) wrote:
>
>>>> Suggest the subject should be
>>>> wifi: ath11k: synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
>>>
>>> FWIW I copied from:
>>> $ git log --format=%s  drivers/net/wireless/ath/ath11k/mac.h
>>> ath11k: Handle keepalive during WoWLAN suspend and resume
>>> ath11k: reduce the wait time of 11d scan and hw scan while add interface
>>> ath11k: Add basic WoW functionalities
>>> ath11k: add support for hardware rfkill for QCA6390
>>> ath11k: report tx bitrate for iw wlan station dump
>>> ath11k: add 11d scan offload support
>>> ath11k: fix read fail for htt_stats and htt_peer_stats for single pdev
>>> ath11k: add support for BSS color change
>>> ath11k: add support for 80P80 and 160 MHz bandwidth
>>> ath11k: Add support for STA to handle beacon miss
>>> ath11k: add support to configure spatial reuse parameter set
>>> ath11k: remove "ath11k_mac_get_ar_vdev_stop_status" references
>>> ath11k: Perform per-msdu rx processing
>>> ath11k: fix incorrect peer stats counters update
>>> ath11k: Move mac80211 hw allocation before wmi_init command
>>> ath11k: fix missed bw conversion in tx completion
>>> ath11k: driver for Qualcomm IEEE 802.11ax devices
>> 
>> Yeah, using "wifi:" is a new prefix we started using with wireless
>> patches this year.
>> 
>
> It would be nice if that was documented somewhere...

It is mentioned on our wiki but I doubt anyone reads it :)

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject

Do let me know if there are other places which should have this info.

I did assume it will take at least a year or two before people get used
to the new prefix, but my patchwork script has a check for this and it's
trivial to fix the subject before I commit the patch. So hopefully the
switch goes smoothly.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
