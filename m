Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8ED351F15
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237810AbhDASwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:52:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59006 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238317AbhDASts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:49:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lS2Nz-00ENfJ-Gv; Thu, 01 Apr 2021 20:49:43 +0200
Date:   Thu, 1 Apr 2021 20:49:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 2/3] dpaa2-eth: add rx copybreak support
Message-ID: <YGYVx+OxaSey3qNJ@lunn.ch>
References: <20210401163956.766628-1-ciorneiioana@gmail.com>
 <20210401163956.766628-3-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401163956.766628-3-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana

> +#define DPAA2_ETH_DEFAULT_COPYBREAK	512

This is quite big. A quick grep suggest other driver use 256.

Do you have some performance figures for this? 

   Andrew
