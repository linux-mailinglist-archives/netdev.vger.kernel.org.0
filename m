Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F71725F004
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgIFTEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgIFTEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 15:04:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE732080A;
        Sun,  6 Sep 2020 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599419091;
        bh=71s+qTNIy0+SO4zmvuLbRsznOf8Yc7KstwtffWt6R6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eBmZhdJMp+1qfEkL7KoIoMZxy3dhbYz7GaAAc6Q3O2TTLdn6VkvE49nlda+l1yTup
         CIGo8SfzEKeWIaF50OwJX/ag6SRoJ8TGZ2X1FdQi9tUbH0l+iV2AWQaWJTYg5UuYH1
         Geg4FMM4Mh8SwsDqBGpStTyGAMshYe1k1hMgiI+M=
Date:   Sun, 6 Sep 2020 12:04:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <claudiu.beznea@microchip.com>, <antoine.tenart@bootlin.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <f.fainelli@gmail.com>, <linux-kernel@vger.kernel.org>,
        <mparab@cadence.com>
Subject: Re: [PATCH net] net: macb: fix for pause frame receive enable bit
Message-ID: <20200906120449.1af17a4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599294093-30758-1-git-send-email-pthombar@cadence.com>
References: <1599294093-30758-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 10:21:33 +0200 Parshuram Thombare wrote:
> PAE bit of NCFGR register, when set, pauses transmission
> if a non-zero 802.3 classic pause frame is received.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>

Applied, thank you!
