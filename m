Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B086E263108
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgIIPy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730507AbgIIPyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 11:54:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BFF32064B;
        Wed,  9 Sep 2020 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599666856;
        bh=8/qjTkbsePLFveWh4ZdVuN3aIka+Zd9OJ+zr6jTXabs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=haaiMLmZfEQzkzzUZYvIwg1MnXjLP9Ueez4pckSlCPmJIYeD4onSujxIul6ZEMvNa
         qf/rXrrABEryvfsBr/SW8rFrkuYmgzAJwpGbW60d+3KHP/76bsL2QseIw9Z/dluBRC
         /H19V4ZrcP36U0OpFJPgK/ndUAbD/ZNp3UFISGu0=
Date:   Wed, 9 Sep 2020 08:54:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next] net: dsa: b53: Report VLAN table occupancy via
 devlink
Message-ID: <20200909085414.6bf9dbd7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909043235.4080900-1-f.fainelli@gmail.com>
References: <20200909043235.4080900-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 21:32:34 -0700 Florian Fainelli wrote:
> We already maintain an array of VLANs used by the switch so we can
> simply iterate over it to report the occupancy via devlink.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
