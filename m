Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103BB21F617
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGNPXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgGNPXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:23:40 -0400
X-Greylist: delayed 3683 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Jul 2020 08:23:39 PDT
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B07C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 08:23:39 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 9672B13F659;
        Tue, 14 Jul 2020 17:23:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1594740217; bh=qTD+dVPIfGAmj3CD8LV6NxvpZsnMTv9FkkqWIHiRKCY=;
        h=Date:From:To;
        b=YAuIglvlfbQcaOR75Q6sfiIOXXSeuEAvcRC/9d/dZz03jLKcmtKWNfVHWWy+iMlvk
         SdC7l0l80P886FHZSrK68Tlj/duYqgIDU8Rqgl5sG7/UvFAPMDnyG50Z4fTlH1xBw3
         3TSDaanSd7AQ7CT0RDiTicvdRLYpgH0TqJwePj2s=
Date:   Tue, 14 Jul 2020 17:23:37 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v1 1/2] net: mdiobus: add support to access PHY
 registers via debugfs
Message-ID: <20200714172337.4dc139a3@dellmb.labs.office.nic.cz>
In-Reply-To: <20200714142213.21365-1-marek.behun@nic.cz>
References: <20200714142213.21365-1-marek.behun@nic.cz>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OMG, this won't even compile, I lost the newly added files
mdio_debugfs.c/h when rebasing!!! AAAAAARRGH

Please ignore these patches
