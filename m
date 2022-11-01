Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760DF614D23
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 15:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiKAOyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 10:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiKAOy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 10:54:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC848E5E;
        Tue,  1 Nov 2022 07:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=45UfOVePY+OHDZoHoj/7WNu01YKoYtNkYfuiJy1E/Sc=; b=qhYVkaTztKrRSFlfSM9lEqpvC+
        0k8pvYDUhyhLKu9xPESEcK3dqVNPW/6f4mwSTxq8AWaUrOA5+deBcwG/aXVnebSmPYFCAzKuOkb8H
        y4qQ6qlTx6Kl7a89zeGwV1u10aa0rsKbcKjyG3Sb6Cm6ObhtuxupTopImOckHrAaivaS89JuS3b+M
        hej4wFWNBfdpwIOP7boSFjyR2boeWb3qI0jeOaBM2rQNYhg1RgW6wjj8HB1V/EIMqyIeAyHnmbAhA
        ggSposh/E6ksw/6BHxC4Ie1F+rP12MpNzP+pQ61IEjaWvOzDfVEhdvchgT5LrW84nrNpLbxbtsKar
        DVnhjWBw==;
Received: from c-67-160-137-253.hsd1.or.comcast.net ([67.160.137.253] helo=[10.0.0.152])
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1opseg-005eKf-UY; Tue, 01 Nov 2022 14:54:19 +0000
Message-ID: <503a3b36-2256-a9ce-cffe-5c0ed51f6f62@infradead.org>
Date:   Tue, 1 Nov 2022 07:54:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] ath11k (gcc13): synchronize
 ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>, Jiri Slaby <jirislaby@kernel.org>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20221031114341.10377-1-jirislaby@kernel.org>
 <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
 <833c7f2f-c140-5a0b-1efc-b858348206ec@kernel.org> <87bkprgj0b.fsf@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <87bkprgj0b.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/22 01:45, Kalle Valo wrote:
> Jiri Slaby <jirislaby@kernel.org> writes:
> 
>> On 31. 10. 22, 22:16, Jeff Johnson wrote:
>>
>>> On 10/31/2022 4:43 AM, Jiri Slaby (SUSE) wrote:

>>> Suggest the subject should be
>>> wifi: ath11k: synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
>>
>> FWIW I copied from:
>> $ git log --format=%s  drivers/net/wireless/ath/ath11k/mac.h
>> ath11k: Handle keepalive during WoWLAN suspend and resume
>> ath11k: reduce the wait time of 11d scan and hw scan while add interface
>> ath11k: Add basic WoW functionalities
>> ath11k: add support for hardware rfkill for QCA6390
>> ath11k: report tx bitrate for iw wlan station dump
>> ath11k: add 11d scan offload support
>> ath11k: fix read fail for htt_stats and htt_peer_stats for single pdev
>> ath11k: add support for BSS color change
>> ath11k: add support for 80P80 and 160 MHz bandwidth
>> ath11k: Add support for STA to handle beacon miss
>> ath11k: add support to configure spatial reuse parameter set
>> ath11k: remove "ath11k_mac_get_ar_vdev_stop_status" references
>> ath11k: Perform per-msdu rx processing
>> ath11k: fix incorrect peer stats counters update
>> ath11k: Move mac80211 hw allocation before wmi_init command
>> ath11k: fix missed bw conversion in tx completion
>> ath11k: driver for Qualcomm IEEE 802.11ax devices
> 
> Yeah, using "wifi:" is a new prefix we started using with wireless
> patches this year.
> 

It would be nice if that was documented somewhere...

-- 
~Randy
