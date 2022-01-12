Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BA448BBBC
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 01:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiALAQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 19:16:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347102AbiALAOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 19:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=40C41H5/D4nIW5pxQqlG5KvbxLje3Y6E4nxt2LwlBp8=; b=ZroN7pJw9qDqitvvcnGCL4pYCt
        UPrKoNO6MN2skX9k8HLer02wGeknK+C/+FHCnakmltNRI/hZg+x7Zqco5aToaFMEVl3bIItuFPN2f
        9U3fOpyYAUjRbpi0/GGMpLJgcKLRp0wOdrbhO9oH+bYPmrOd8qynlhuVTaZ9aW2VCFzk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7RHa-0019Dt-P0; Wed, 12 Jan 2022 01:14:30 +0100
Date:   Wed, 12 Jan 2022 01:14:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: phy: at803x: Support downstream SFP
 cage
Message-ID: <Yd4dZiQVinhUSwkO@lunn.ch>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
 <20220111215504.2714643-4-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111215504.2714643-4-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 03:55:04PM -0600, Robert Hancock wrote:
> Add support for downstream SFP cages for AR8031 and AR8033. This is
> primarily intended for fiber modules or direct-attach cables, however
> copper modules which work in 1000Base-X mode may also function. Such
> modules are allowed with a warning.

The previous patch added:

AT803X_MODE_CFG_BASET_SGMII

So it seems it has some support for SGMII? Cannot it be used?

   Andrew
