Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A146C32C454
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392247AbhCDANE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:04 -0500
Received: from mail.pr-group.ru ([178.18.215.3]:54675 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235044AbhCCPaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:30:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=+UClZIkLV7XyxuudMMZtiCPYHdclWfmOee/whdskQT0=;
        b=c2jILVAVH1+3oyCWt9AZiz9QKdGJz6zykMJoxNb0wI1ZKlvAlKyahIqPHMJGNRF/fK5MhdQty9O+S
         g58j7WnszdmXBNRZ3/Mxk5cqN9MGavIbwWm+zeAv1QRvMuW97/i2GVLwVUNwhiNKRjzvcdMjj28PvY
         nn2WCVjL0QhuHm6luJ1ULhwBu2Kt2xupX9F4YbI57QYBkvBrZGszy1jnVwCbpss0uJ1dbX7jN+xIkp
         80mTgsLaYDnpYIFrpGXtW+gXt2o/jAJX2a2m2Dh62MsADDreg7fQUAcXCvfxcwhpQRYVZg4D5jIdHF
         3M3L7crXNPyzqno7qeAtYbGxo9F/8dg==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Wed, 3 Mar 2021 18:27:10 +0300
Date:   Wed, 3 Mar 2021 18:27:00 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <20210303152700.g4osy5l2fip7md23@dhcp-179.ddg>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
 <20210303105756.sdeiwg7hn3p4rtq4@dhcp-179.ddg>
 <20210303113655.GA1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303113655.GA1463@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 03, 2021 at 11:36:55AM +0000, Russell King - ARM Linux admin wrote:
> 
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, supported);
> 
> Does the PHY support backplane links?
> 

It looks like it does, but our hardware only have SFP cages, so I'll
drop backplane link modes.

