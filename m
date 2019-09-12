Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17508B0B39
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 11:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfILJVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 05:21:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42054 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730175AbfILJVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 05:21:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vzY8NH1vk1O2cjHNNYaUeT3K0khzzQXjJAlnFtuoXAg=; b=pIqmPt5xS35JIhbeNCkE2vqCBb
        n4NCde7uJBe9SrrIKsb1+VUt9JhsshWJPcAZSvlJxPpEjSs/SnJp6IlZj7lYvT5jiTn7TiD6VMlmC
        L18TjoVx3BTJvxFfFklWjNHVUHGG1GG52QxQRCtosMjTblIyEVhRk+Rymx6RsAl2PLJ0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i8LHn-0004qb-Mx; Thu, 12 Sep 2019 11:21:07 +0200
Date:   Thu, 12 Sep 2019 11:21:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Message-ID: <20190912092107.GD17773@lunn.ch>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
 <20190911112134.GA20574@splinter>
 <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
 <20190912090339.GA16311@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912090339.GA16311@splinter>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 2. Scheduling: How to schedule between the different transmission queues
> 
> Where the port from which the packets should egress is the CPU port,
> before they cross the PCI towards the imx6.

Hi Ido

This is DSA, so the switch is connected via Ethernet to the IMX6, not
PCI. Minor detail, but that really is the core of what makes DSA DSA.

     Andrew
