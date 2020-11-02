Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364002A2B47
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgKBNMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:12:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58486 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgKBNMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 08:12:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZZdR-004olM-R2; Mon, 02 Nov 2020 14:12:33 +0100
Date:   Mon, 2 Nov 2020 14:12:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     marek.behun@nic.cz, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v7 0/4] Add support for mv88e6393x family of Marvell
Message-ID: <20201102131233.GF1109407@lunn.ch>
References: <20201029073123.77ba965b@nic.cz>
 <cover.1604298276.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1604298276.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 04:40:02PM +1000, Pavana Sharma wrote:
> Thanks for the review.
> Here's updated patchset.

Please include a short description of what you have changed since the
last version. It helps us as maintainers see if you have attempted to
make the changes we have requested, or not.

     Andrew
