Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FDA57EA82
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 01:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiGVXzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 19:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGVXzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 19:55:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F914A475;
        Fri, 22 Jul 2022 16:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C05DCCE21DA;
        Fri, 22 Jul 2022 23:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F20C341C6;
        Fri, 22 Jul 2022 23:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658534111;
        bh=mNFDIqHDk4o+Mw4ZoVnXPp78r8vRFfYD8093BDJkP+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AG+KgisumQH8tC2IgDsuZBmmJOdMQ17BJ+ubXAh1CQyX9bDXbJFYY+4+cHBnt6i4/
         ZeL8cg350cCn/YGUvO/oHltdNYNKiTHMze4goRrncipNAbGc2WZ4EPBr5Zj1KML/qg
         +YwhQARhLRjebxC4BUzPZZC+yTLCyeHy+elZgDeuHqsT96WzgNo7erMnbyY6eNRwLp
         qmuZzrY6O4ff0e2FufBEPjwCR0WnQRCYZ3uwCO6Jmdb7vX4oDTeGcxzmmXqJBOHySX
         7IAPrsLnGNbZTeJLE8jlLpXian87KlCRYi9PRVVLLMWSjwEUNkA5sWBiMHJY95tJAO
         DRGBeizf1jzWw==
Date:   Fri, 22 Jul 2022 16:55:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2022-07-22
Message-ID: <20220722165510.191fad93@kernel.org>
In-Reply-To: <20220722205400.847019-1-luiz.dentz@gmail.com>
References: <20220722205400.847019-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 13:54:00 -0700 Luiz Augusto von Dentz wrote:
> The following changes since commit 6e0e846ee2ab01bc44254e6a0a6a6a0db1cba16d:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-07-21 13:03:39 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-07-22
> 
> for you to fetch changes up to 768677808478ee7ffabf9c9128f345b7ec62b5f3:
> 
>   Bluetooth: btusb: Detect if an ACL packet is in fact an ISO packet (2022-07-22 13:24:55 -0700)
> 
> ----------------------------------------------------------------
> bluetooth-next pull request for net-next:
> 
>  - Add support for IM Networks PID 0x3568
>  - Add support for BCM4349B1
>  - Add support for CYW55572
>  - Add support for MT7922 VID/PID 0489/e0e2
>  - Add support for Realtek RTL8852C
>  - Initial support for Isochronous Channels/ISO sockets
>  - Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING quirk

I see two new sparse warnings (for a follow up):

net/bluetooth/hci_event.c:3789:26: warning: cast to restricted __le16
net/bluetooth/hci_event.c:3791:26: warning: cast to restricted __le16

Two bad Fixes tags:

Commit: 68253f3cd715 ("Bluetooth: hci_sync: Fix resuming scan after suspend resume")
	Fixes tag: Fixes: 3b42055388c30 (Bluetooth: hci_sync: Fix attempting to suspend with
	Has these problem(s):
		- Subject has leading but no trailing parentheses
Commit: 9111786492f1 ("Bluetooth: fix an error code in hci_register_dev()")
	Fixes tag: Fixes: d6bb2a91f95b ("Bluetooth: Unregister suspend with userchannel")
	Has these problem(s):
		- Target SHA1 does not exist

And a whole bunch of patches committed by you but signed off by Marcel.
Last time we tried to fix that it ended up making things worse.
So I guess it is what it is :) Pulling...
