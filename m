Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E8D10A044
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 15:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfKZOaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 09:30:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56604 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfKZOaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 09:30:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9LohR98h7eSnbtOjih5buv5szdpX2GUI8naC1HscHjw=; b=rw+WNrhIljSW4nQOJHevd6Xn92
        AHiqQUiOji33SYte/aZOoBfrw0XK+xwXdtuTm9dEjQLL3tAzzEeNRNH3adS8x4/u/Qf/YhMgCfo8Z
        T6Af7wJxGxwAyauS5SJ0T0SW+Fb9thcbSrNyYDPfIOMnCGjeJSboCJYhTfts5/WMp0kc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iZbqz-0003UL-Ak; Tue, 26 Nov 2019 15:30:09 +0100
Date:   Tue, 26 Nov 2019 15:30:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Milind Parab <mparab@cadence.com>
Cc:     antoine.tenart@bootlin.com, nicolas.ferre@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org,
        dkangude@cadence.com, pthombar@cadence.com
Subject: Re: [PATCH 1/3] net: macb: fix for fixed-link mode
Message-ID: <20191126143009.GO6602@lunn.ch>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759380-102986-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574759380-102986-1-git-send-email-mparab@cadence.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 09:09:40AM +0000, Milind Parab wrote:
> This patch fix the issue with fixed link mode in macb.

Hi Milind.

What issue is it fixing? Please give a good description here, so we
can understand what/why the patch exists.

    Andrew
