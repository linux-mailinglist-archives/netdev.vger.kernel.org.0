Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30C61F696F
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 15:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgFKNyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 09:54:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgFKNyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 09:54:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jjNf3-000BIH-4f; Thu, 11 Jun 2020 15:54:29 +0200
Date:   Thu, 11 Jun 2020 15:54:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Meir Lichtinger <meirl@mellanox.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] ethtool: Add support for 100Gbps per lane
 link modes
Message-ID: <20200611135429.GF19869@lunn.ch>
References: <20200430234106.52732-1-saeedm@mellanox.com>
 <20200430234106.52732-2-saeedm@mellanox.com>
 <20200502150857.GC142589@lunn.ch>
 <e3b31d58-fc00-4387-56a0-d787e33e77ae@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b31d58-fc00-4387-56a0-d787e33e77ae@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > How do you know you have connected a 400000baseLR4 to a
> > 400000baseER4 with a 40Km and it is not expected to work, when looking
> > at ethtool? I assume the EEPROM contents tell you if the module is
> > LR4, ER4, or FR4?
> > 
> >       Andrew
> Correct.

Hi Meir

Do you also have patches to Ethtool to decode these bits in the SFP EEPROM?

> In addition, this is the terminology exposed in 50 Gbps and we
> followed it.

Yes, i missed the patch which added those. I would probably of
objected. But we have them now, so lets keep going. But we might want
a clear definition of when modes can be combined like this.

  Andrew
