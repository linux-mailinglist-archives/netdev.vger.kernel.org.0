Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D1F66A38E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjAMTmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjAMTm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:42:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FEE8B519;
        Fri, 13 Jan 2023 11:41:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F630B82184;
        Fri, 13 Jan 2023 19:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CEEC433D2;
        Fri, 13 Jan 2023 19:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673638893;
        bh=VfTRPvZx2my6jXZXQp2OMVlaC/74yQK+EI0MWp6z4zQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C29Pn8ONzIBGpYuOOOg0o1dGqTYsPhFTlcqaD/OqdLlCv5vrivRzD/8hC2xz1rLPM
         A3Vod/TEpGWEyoK1hqdwHlrejY+iunbwsE0u7TakntYuXqS+hMrr0o8JVsBjce1TKC
         MjeBb+zOwi7UueTwSzedsEqPvWX7IKyfqHl+EMsFvkYkpfPEWp8BuACNoA/leAe+05
         wLTfKXE1DgWCZVZixetbZPdJwjWVDGymo5a5hfVJ/SRSgl8rjbjyLJ7ChMNDN5k+4V
         +nXhSzISu6j3OVfEAgMjPxvpJr3faRyqE43o/s2RbsRQQvuWvCVlhFOF3lzTpsZw/F
         PO5URFe0C5DVQ==
Date:   Fri, 13 Jan 2023 11:41:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: Re: [Patch net-next v8 00/13] net: dsa: microchip: add PTP support
 for KSZ9563/KSZ8563 and LAN937x
Message-ID: <20230113114132.49fd8167@kernel.org>
In-Reply-To: <20230110084930.16049-1-arun.ramadoss@microchip.com>
References: <20230110084930.16049-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 14:19:17 +0530 Arun Ramadoss wrote:
> KSZ9563/KSZ8563 and  LAN937x switch are capable for supporting IEEE 1588 PTP
> protocol.  LAN937x has the same PTP register set similar to KSZ9563, hence the
> implementation has been made common for the KSZ switches.  KSZ9563 does not
> support two step timestamping but LAN937x supports both.  Tested the 1step &
> 2step p2p timestamping in LAN937x and p2p1step timestamping in KSZ9563.
> 
> This patch series is based on the Christian Eggers PTP support for KSZ9563.
> Applied the Christian patch and updated as per the latest refactoring of KSZ
> series code. The features added on top are PTP packet Interrupt
> implementation based on nested handler, LAN937x two step timestamping and
> programmable per_out pins.

Applied, thanks!
