Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D539422812A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgGUNlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:41:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgGUNlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 09:41:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxsWf-006B6w-Dz; Tue, 21 Jul 2020 15:41:45 +0200
Date:   Tue, 21 Jul 2020 15:41:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com
Subject: Re: [PATCH net-next 0/4] cxgb4: add ethtool self_test support
Message-ID: <20200721134145.GB1472201@lunn.ch>
References: <20200717134759.8268-1-vishal@chelsio.com>
 <20200717180251.GC1339445@lunn.ch>
 <20200720062837.GA22415@chelsio.com>
 <20200720133554.GQ1383417@lunn.ch>
 <20200721133754.GB20312@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721133754.GB20312@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> Our requirement is to get overall adapter health from single tool and command.
> Using devlink and ip will require multiple tools and commands.

That is not a good reason to abuse the Kernel norms and do odd things.

     Andrew
