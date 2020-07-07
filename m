Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9104F2175B1
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgGGRzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:55:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbgGGRzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 13:55:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsroj-0043Xl-FQ; Tue, 07 Jul 2020 19:55:41 +0200
Date:   Tue, 7 Jul 2020 19:55:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: add module param for auto negotiation
Message-ID: <20200707175541.GB938746@lunn.ch>
References: <20200707173254.1564625-1-Shyam-sundar.S-k@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707173254.1564625-1-Shyam-sundar.S-k@amd.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 05:32:54PM +0000, Shyam Sundar S K wrote:
> In embedded environments, ethtool may not be available to toggle between
> auto negotiation on/off.
> 
> Add a module parameter to control auto negotiation for these situations.

Where does this end? You can set the link speed via module parameters?
Pause? Duplex?

       Andrew
