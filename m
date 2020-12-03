Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFCD2CD8DC
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389222AbgLCOT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:19:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgLCOT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 09:19:28 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkpRO-00A2yM-Ah; Thu, 03 Dec 2020 15:18:38 +0100
Date:   Thu, 3 Dec 2020 15:18:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] net: ti: am65-cpsw-nuss: Add devlink support
Message-ID: <20201203141838.GE2333853@lunn.ch>
References: <20201130082046.16292-1-vigneshr@ti.com>
 <20201130082046.16292-2-vigneshr@ti.com>
 <20201130155044.GE2073444@lunn.ch>
 <cc7fe740-1002-f1b9-8136-e1ba60cf2541@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7fe740-1002-f1b9-8136-e1ba60cf2541@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We don't want to enable HW based switch support unless explicitly
> asked by user.

This is the key point. Why? Does individual ports when passed through
the switch not work properly? Does it add extra latency/jitter?

Please justify this.

       Andrew
