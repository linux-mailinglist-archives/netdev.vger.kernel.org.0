Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B794434FA3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfFDSNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:13:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFDSNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 14:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eWrgMmOxgXTI6jWm/P5+Lng97Rr+7xChpDt6Y+04S+I=; b=MprFc9AF8OChiMH1OdjBurcPOs
        X+QDtsfJumvrxp81oxevOcMluj5owqWO9PHlZifWvczzA82xsknYnlPcY1MsZt4X/WmJu106RYmtV
        FHlM9jeB/ZvZnjJgkMwURuV897wj+ncPGHpJ+u5/GI1ThWLPdFbWOFOqRTcWP4NfMuAA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYDve-00072o-Kg; Tue, 04 Jun 2019 20:12:58 +0200
Date:   Tue, 4 Jun 2019 20:12:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] net: phy: xilinx: add Xilinx PHY driver
Message-ID: <20190604181258.GF16951@lunn.ch>
References: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
 <d8c22bc3-0a20-2c24-88bb-b1f5f8cc907a@gmail.com>
 <7684776f-2bec-e9e2-1a79-dbc3e9844f7e@sedsystems.ca>
 <20190604165452.GU19627@lunn.ch>
 <2a547fef-880e-fe59-ecff-4e616212a0f7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a547fef-880e-fe59-ecff-4e616212a0f7@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If I remember the Marvell specs correctly, there was some bit to switch the
> complete register set to fibre mode.

Hi Heiner

The Marvell PHY has a second page for Fibre. It mostly mirrors the
normal registers, and you need to look at both pages to determine if
copper or fibre has link, etc. Fibre has no auto-neg, so there is
nothing to configure for that.

For the Xilinx PHY the auto-neg ability should not be set, so i doubt
phylib will offer the option.

       Andrew
