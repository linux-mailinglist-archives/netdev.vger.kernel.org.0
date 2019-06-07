Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF0C38A93
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 14:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbfFGMry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 08:47:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35742 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfFGMrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 08:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3WqdjwoH1vMPIgIY8C0Lu2n3Sh1hJP0XHMp1bNmmPWg=; b=3+19V22GOKgwLunxSlZudOhhwY
        4pVubx0UxBp5F6WrMmYPLuGNZ4QoTbfyxgQsZHKundmDTfmIH1xphPE1QBRWkOdssQBBQcF5jbU3G
        WLre9ogrEF+zkTKTAEYUdr17RavhjcVwHrsx/Wx4nzzF3f4Lf8hehbvxh8odbxhJ8mfw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZEHe-0006mB-Lz; Fri, 07 Jun 2019 14:47:50 +0200
Date:   Fri, 7 Jun 2019 14:47:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190607124750.GJ20899@lunn.ch>
References: <20190605133102.GF19627@lunn.ch>
 <20907497-526d-67b2-c100-37047fa1f0d8@eks-engel.de>
 <20190605184724.GB19590@lunn.ch>
 <c27f2b9b-90d7-db63-f01c-2dfaef7a014b@eks-engel.de>
 <20190606122437.GA20899@lunn.ch>
 <86c1e7b1-ef38-7383-5617-94f9e677370b@eks-engel.de>
 <20190606133501.GC19590@lunn.ch>
 <e01b05e4-5190-1da6-970d-801e9fba6d49@eks-engel.de>
 <20190606135903.GE19590@lunn.ch>
 <8903b07b-4ac5-019a-14a1-d2fc6a57c0bb@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8903b07b-4ac5-019a-14a1-d2fc6a57c0bb@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So all ports are now in forwarding mode (Switch port register 0x4 of all ports 
> are 0x7f), but I don't reach it over ping.

Hi

The most common error for people new to DSA is forgetting to bring
the master interface up.

The second thing to understand is that by default, all interfaces are
separated. So the switch won't bridge frames between ports, until you
add the ports to a Linux bridge. But you can give each interface its
own IP address.

    Andrew
