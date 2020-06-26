Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EA120B428
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgFZPG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:06:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgFZPG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 11:06:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jopvq-002NeK-9b; Fri, 26 Jun 2020 17:06:22 +0200
Date:   Fri, 26 Jun 2020 17:06:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, popadrian1996@gmail.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/2] mlxsw: Add support for QSFP-DD transceiver
 type
Message-ID: <20200626150622.GD535869@lunn.ch>
References: <20200626144724.224372-1-idosch@idosch.org>
 <20200626145342.GA224557@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626145342.GA224557@shredder>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 05:53:42PM +0300, Ido Schimmel wrote:
> On Fri, Jun 26, 2020 at 05:47:22PM +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > This patch set from Vadim adds support for Quad Small Form Factor
> > Pluggable Double Density (QSFP-DD) modules in mlxsw.
> 
> Adrian,
> 
> In November you sent a patch that adds QSFP-DD support in ethtool user
> space utility:
> https://patchwork.ozlabs.org/project/netdev/patch/20191109124205.11273-1-popadrian1996@gmail.com/
> 
> Back then Andrew rightfully noted that no driver in the upstream kernel
> supports QSFP-DD and the patch was deferred.

Hi Ido

It is a while ago, but i thought there was something odd about the
order of the pages, or the number of the pages? And there was no clear
indication from the kernel about QSPF page format vs QSPF-DD page
format?

So Adrian's patch is probably a good starting point, but i think it
needs further work.

      Andrew
