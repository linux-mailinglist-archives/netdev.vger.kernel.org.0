Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CFE223D1A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 15:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGQNkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 09:40:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40986 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgGQNkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 09:40:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwQau-005bxl-El; Fri, 17 Jul 2020 15:40:08 +0200
Date:   Fri, 17 Jul 2020 15:40:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mark Einon <mark.einon@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: et131x: Remove redundant register read
Message-ID: <20200717134008.GB1336433@lunn.ch>
References: <20200717132135.361267-1-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717132135.361267-1-mark.einon@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 02:21:35PM +0100, Mark Einon wrote:
> Following the removal of an unused variable assignment (remove
> unused variable 'pm_csr') the associated register read can also go,
> as the read also occurs in the subsequent et1310_in_phy_coma()
> call.

Hi Mark

Do you have any hardware documentation which indicates these read are
not required? Have you looked back through the git history to see if
there are any comments about these read?

Hardware reads which appear pointless are sometimes very important to
actually make the hardware work.

	 Andrew
