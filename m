Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600EC37550
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfFFNfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:35:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfFFNfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 09:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aWlkRhoxBAtlT5RRndilKMHeqpgkz29WvuwCJz7T6eQ=; b=498ZRvkgLblJfM1m47TYFHwSKV
        2DMdwfdMse/EtBArKQvPpX1e2JCDbdHTtx5d3K3cEC/uAtrCPIoKmuq7fbwGJYBhp7bOINDlcHC2z
        Wd+AQKe/4UfLVpPDdAeRE6htgqpjJmtIlMe8TQPDXeotPUV9JL5x76Zmms39wfZe9VcE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYsXl-00068D-9r; Thu, 06 Jun 2019 15:35:01 +0200
Date:   Thu, 6 Jun 2019 15:35:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190606133501.GC19590@lunn.ch>
References: <20190604135000.GD16951@lunn.ch>
 <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
 <20190605122404.GH16951@lunn.ch>
 <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
 <20190605133102.GF19627@lunn.ch>
 <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
 <20190605184724.GB19590@lunn.ch>
 <c27f2b9b-90d7-db63-f01c-2dfaef7a014b@eks-engel.de>
 <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >From our hardware developer I know now that we are using a "mini" SFF 
> which has no i2c eeprom. 

O.K. Does this mini SFF have LOS, TX-Disable, etc? Are these connected
to GPIOs? I assume the SFF is fibre? And it needs the SERDES to speak
1000BaseX, not SGMII?

> Switch				|	external
> Port 0 - internal serdes 0x0c --|-------Mini SFF 1x8 Transceiver
> 				|
> Port 0 - internal serdes 0x0d --|-------Mini SFF 1x8 Transceiver
> 				|
> Port 2 ----------RGMII----------|-------KSZ9031 PHY 0x02(strap)--Transceiver
> 				|
> Port 3 - internal PHY 0x03 -----|-------Transceiver
> 				|
> Port 3 - internal PHY 0x04 -----|-------Transceiver
> 				|			
> Port 5 - CPU-Port RMII ---------|-------CPU
> 				|
> Port 6 ----------RGMII----------|-------KSZ9031 PHY 0x06(strap)--Transceiver

So the current state is that just the SFF ports are not working? All
the copper PHYs are O.K.

    Andrew

