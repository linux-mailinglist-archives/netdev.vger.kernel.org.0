Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD2635275
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFDWDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:03:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfFDWDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 18:03:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cf1VuOOYWdEE8SSvU8i2GbZmf78/LqeaFqvt2uWMbHg=; b=gbPXlBBZ3jCX/MEer4M/VsUGjv
        ET38TCwIaqa1kOJK48dxEX8inQ3dZIaH0WIQvVBDlyj33ZLavppjoo/Ut5+3ZMxOCWS+vpCNQmftC
        N3sbFesXUH63w4EPvdkeQNPGNqUJobGrfTu/k9DvT0mr9iFf7Zxtc5tsiUHKMPCtvAUo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYHWM-0000Qd-UZ; Wed, 05 Jun 2019 00:03:06 +0200
Date:   Wed, 5 Jun 2019 00:03:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next v3 16/19] net: axienet: Fix MDIO bus parent node
 detection
Message-ID: <20190604220306.GZ19627@lunn.ch>
References: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
 <1559684626-24775-17-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559684626-24775-17-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This could potentially break existing device trees if they don't use
> "mdio" as the name for the MDIO bus, but I did not find any with various
> searches and Xilinx's examples all use mdio as the name so it seems like
> this should be relatively safe.

Hi Robert

Please add this mdio node to the binding documentation as an optional
property.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
