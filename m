Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AD81AE198
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 17:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgDQPyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 11:54:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgDQPyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 11:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aJKZoYvwoG33lF6JFzsES25UIh0HHl97uKcGcnKeX2E=; b=Q3PI+cLcv1tS9CAiAsJhP+6n/j
        hyeMruE2NPlbjajHuGsIsQZhkyCDSIMw+5FzvDGRoQhJ1PRhboxMwO39mj1La9+gZjZ1Ics4ZFs+w
        cEQtTAmxl2YBKrdz9ZR/sApFgRZV73gr0zgq9LOz66ZTVm3G7AZdrePDqOMdt0YVb5yQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPTK2-003JKM-Fg; Fri, 17 Apr 2020 17:54:30 +0200
Date:   Fri, 17 Apr 2020 17:54:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Bauer <mail@david-bauer.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: at803x: add support for AR8032 PHY
Message-ID: <20200417155430.GC785713@lunn.ch>
References: <20200417134159.427556-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417134159.427556-1-mail@david-bauer.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 03:41:59PM +0200, David Bauer wrote:
> This adds support for the Qualcomm Atheros AR8032 Fast Ethernet PHY.
> 
> It shares many similarities with the already supported AR8030 PHY but
> additionally supports MII connection to the MAC.

Hi David

This looks good. However, next time please put in the patch subject
which tree this is for

[PATCH net-next 1/1]

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
