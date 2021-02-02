Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D781730B484
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhBBBQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhBBBQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 20:16:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53F6964DD4;
        Tue,  2 Feb 2021 01:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612228563;
        bh=UxGB7lo+5k3HKb1WzXYlltzIMtjAVlrWtyZUH24czOQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pwqVp9Te5mz03MCLNLM3Ot6LEtCEAj/U1Dwgg3s/QzBaJuWlwGl6EcCoTuTQEaBFY
         zGw+YhFwJ5w6oQgzsAZRsidTTl+njpqp7V4W5a0h+e0O5JvCOhsxcx16Loclo3/lzt
         xMlP3nVJNwhSLclqQgHCFc/u7iM/R9+yD6x42UbRXjZO2Y1Ba7n4aTFzkfzoJIgTch
         LxKtgFLveIp8uzYOFNVy/8c5RZAxwrr1bGI1H6CUpcBNl000VbbFoXQUi+oCaojUX4
         XzD/d9vnyNyyBOdCWIcvBDkEMLr20t5AKqOcJDD4IP+fxyo/i4fRBpxroYTnjEAfHJ
         JtfIEGhA2rmgg==
Date:   Mon, 1 Feb 2021 17:16:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>, <atenart@kernel.org>
Subject: Re: [PATCH v7 net-next 00/15] net: mvpp2: Add TX Flow Control
 support
Message-ID: <20210201171602.5a7583ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
References: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jan 2021 16:33:43 +0200 stefanc@marvell.com wrote:
> v6 --> v7
> - Reduce patch set from 18 to 15 patches
>  - Documentation change combined into a single patch
>  - RXQ and BM size change combined into a single patch
>  - Ring size change check moved into "add RXQ flow control configurations" commit

It still did not get into patchwork :S

