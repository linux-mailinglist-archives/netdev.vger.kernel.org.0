Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E87A3424C4
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhCSSfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:35:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37648 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230223AbhCSSfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 14:35:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lNJyG-00BvSO-0r; Fri, 19 Mar 2021 19:35:40 +0100
Date:   Fri, 19 Mar 2021 19:35:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: cosmetic fix
Message-ID: <YFTu/NCDv75z7n0T@lunn.ch>
References: <20210319143149.823-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210319143149.823-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 03:31:49PM +0100, Marek Behún wrote:
> We know that the `lane == MV88E6393X_PORT0_LANE`, so we can pass `lane`
> to mv88e6390_serdes_read() instead of MV88E6393X_PORT0_LANE.
> 
> All other occurances in this function are using the `lane` variable.
> 
> It seems I forgot to change it at this one place after refactoring.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: de776d0d316f7 ("net: dsa: mv88e6xxx: add support for ...")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
