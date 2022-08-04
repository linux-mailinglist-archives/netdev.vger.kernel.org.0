Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F030589625
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbiHDCet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 22:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237493AbiHDCet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:34:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E1A5FAF1;
        Wed,  3 Aug 2022 19:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E76A61790;
        Thu,  4 Aug 2022 02:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94410C433C1;
        Thu,  4 Aug 2022 02:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659580486;
        bh=2bSjUCVSOdvDJPYhExc2ULwhAVVJRZVuYhXgnRtbhtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGxq9CUI6c2GC2yFu+9dNXBexIDrJz9dghg7U+Iz94Z2ejreR/71TZZk+8KTXM0vo
         bPueIpbyRJSyecSV80DOUiYcEluGdX5wUED9AYjK8duLOv0wlX1QANChDup85SvUVg
         PHGjJfAAnaoaJ4/VwTPj230uFTzmPoZIWJR6DAMhu+IuCqGazHh8YhRioPc1vogHR9
         EYb8BDkMqwbDp9qlEsglQVr/gZiqQuIuRzqNjtZweUt7/Dn2uJKWO1Vyz0GSJvirwj
         f9JgqQ29yraHCwSr+1ZhpUxXBeADbqE2KeiOZoZhbxx7VYjJl6utAkesCkNR/Oxazf
         Fs78coRqfXo5A==
Date:   Wed, 3 Aug 2022 19:34:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>,
        <harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: Re: [PATCH 0/2] Macb PTP enhancements
Message-ID: <20220803193444.3b43730d@kernel.org>
In-Reply-To: <20220802104346.29335-1-harini.katakam@xilinx.com>
References: <20220802104346.29335-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 16:13:44 +0530 Harini Katakam wrote:
> From: Harini Katakam <harini.katakam@amd.com>
> 
> This series is a follow up for patches 2 and 3 from a previous series:
> https://lore.kernel.org/all/ca4c97c9-1117-a465-5202-e1bf276fe75b@microchip.com/
> https://lore.kernel.org/all/20220517135525.GC3344@hoboy.vegasvil.org/
> Sorry for the delay.
> 
> ACK is added only to patch 3 (now patch 2).
> Patch 1 is updated with check for gem_has_ptp as per Claudiu's comments.

These were separated from the earlier series as non-fixes, right?
But we are in the period of merge window right now, when all the
new features flow to Linus's tree and we only take fixes to avoid
conflicts and give maintainers time to settle the existing ones.
So these need to wait until -rc1 is cut. (Or is patch 1 a bug fix? 
I can't tell.)
