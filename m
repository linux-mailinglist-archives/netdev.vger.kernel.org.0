Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD952A1B2F
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 00:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgJaXOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 19:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgJaXOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 19:14:38 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1CBE2087E;
        Sat, 31 Oct 2020 23:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604186078;
        bh=waRqnfINHtck29eUZjZWFMZj7x9R5EWOmoljJnRJt/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P3NfKVoANira2GM29LAuKNdFVdDh2q00BXpkEYFkl1LesYc2ZnaTNJ85idqb91RyN
         4z/hbzyU0odUlXaMvVHWkYkLpAsyy1KvMAafokYzBpCis6e2HsHVdyvCxbn2WJVZI1
         hdF8Jjyd//kOtJ8mAtpQULM4A/y/K5qg0kZA53AI=
Date:   Sat, 31 Oct 2020 16:14:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mparab@cadence.com>
Subject: Re: [RESEND PATCH v5] net: macb: add support for high speed
 interface
Message-ID: <20201031161437.6072b0cd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1603975627-18338-1-git-send-email-pthombar@cadence.com>
References: <1603975627-18338-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 13:47:07 +0100 Parshuram Thombare wrote:
> This patch adds support for 10GBASE-R interface to the linux driver for
> Cadence's ethernet controller.
> This controller has separate MAC's and PCS'es for low and high speed paths.
> High speed PCS supports 100M, 1G, 2.5G, 5G and 10G through rate adaptation
> implementation. However, since it doesn't support auto negotiation, linux
> driver is modified to support 10GBASE-R instead of USXGMII. 
> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>

Applied, thanks!
