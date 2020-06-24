Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8894E206A7B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgFXDVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXDVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:21:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5508C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 20:21:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79181129835F7;
        Tue, 23 Jun 2020 20:21:34 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:21:33 -0700 (PDT)
Message-Id: <20200623.202133.1062288550417132463.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, cphealy@gmail.com
Subject: Re: [PATCH net] net: ethtool: Handle missing cable test TDR
 parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624012545.465287-1-andrew@lunn.ch>
References: <20200624012545.465287-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:21:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 24 Jun 2020 03:25:45 +0200

> A last minute change put the TDR cable test parameters into a nest.
> The validation is not sufficient, resulting in an oops if the nest is
> missing. Set default values first, then update them if the nest is
> provided.
> 
> Fixes: f2bc8ad31a7f ("net: ethtool: Allow PHY cable test TDR data to configured")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.
