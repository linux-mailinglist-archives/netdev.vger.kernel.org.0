Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A377B1CE83F
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgEKWkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 18:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgEKWkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 18:40:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B2192070B;
        Mon, 11 May 2020 22:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589236821;
        bh=hN5LjcxrvCAnf1LbdVpCn1Rq/Dv4wvt84eCLNqR+xsU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IUjTw7hKjCq0XIdPxa47DMDJCNAq4V42ehK5xA32wIiZHqcfdnJeP++OfOj9RCIz7
         Fv3oMiOG4LuEHEtjD+b7WFpZG6SZWY0APo5kSXpPnLOgLi+BZ/wi3qxZ4QdT+ow3uZ
         GeLh+2EfZNGcmWCkccnG747UXB3ASlo+20ArdHAQ=
Date:   Mon, 11 May 2020 15:40:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: dsa: tag_ocelot: use a short prefix
 on both ingress and egress
Message-ID: <20200511154019.216d8aa6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200511202046.20515-4-olteanv@gmail.com>
References: <20200511202046.20515-1-olteanv@gmail.com>
        <20200511202046.20515-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 May 2020 23:20:45 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There are 2 goals that we follow:
> 
> - Reduce the header size
> - Make the header size equal between RX and TX

Getting this from sparse:

../net/dsa/tag_ocelot.c:185:17: warning: incorrect type in assignment (different base types)
../net/dsa/tag_ocelot.c:185:17:    expected unsigned int [usertype]
../net/dsa/tag_ocelot.c:185:17:    got restricted __be32 [usertype]
