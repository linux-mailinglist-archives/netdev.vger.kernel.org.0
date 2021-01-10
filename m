Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836842F08CF
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbhAJRik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:38:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbhAJRik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 12:38:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyef6-00HLWf-LF; Sun, 10 Jan 2021 18:37:56 +0100
Date:   Sun, 10 Jan 2021 18:37:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org
Subject: Re: [PATCH RFC net-next  18/19] net: mvpp2: add ring size validation
 before enabling FC
Message-ID: <X/s7dFGDvoZzvKEN@lunn.ch>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-19-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-19-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:30:22PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> This patch add ring size validation before enabling FC.
> 1. Flow control cannot be enabled if ring size is below start
> threshold.
> 2. Flow control disabled if ring size set below start
> threshold.

You should also tell phylink if pause is not supported, so it can
change what is auto-negotiated, letting the link partner know.

       Andrew
