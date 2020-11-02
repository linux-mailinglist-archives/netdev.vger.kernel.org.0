Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE93C2A2B3C
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgKBNJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:09:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728359AbgKBNJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 08:09:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZZa5-004ojJ-T5; Mon, 02 Nov 2020 14:09:05 +0100
Date:   Mon, 2 Nov 2020 14:09:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     marek.behun@nic.cz, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v7 2/4] net: phy: Add 5GBASER interface mode
Message-ID: <20201102130905.GE1109407@lunn.ch>
References: <cover.1604298276.git.pavana.sharma@digi.com>
 <ee2ecb0560b9e7a2a567b69b5de40f39344c8ffe.1604298276.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2ecb0560b9e7a2a567b69b5de40f39344c8ffe.1604298276.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 04:42:06PM +1000, Pavana Sharma wrote:
> Add 5GBASE-R phy interface mode
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

How many times have i asked for you to add kerneldoc for this new
value? How many times have you not done so?

NACK.

If you don't understand a comment, please ask.

   Andrew
