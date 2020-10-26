Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEF8298E35
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780315AbgJZNia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:38:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44654 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775673AbgJZNi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 09:38:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kX2hZ-003bsF-W9; Mon, 26 Oct 2020 14:38:21 +0100
Date:   Mon, 26 Oct 2020 14:38:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v4 2/3] Add phy interface for 5GBASER mode
Message-ID: <20201026133821.GK752111@lunn.ch>
References: <cover.1603690201.git.pavana.sharma@digi.com>
 <156717e3151d58bd51aef7b0e491ae5c63c07938.1603690202.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156717e3151d58bd51aef7b0e491ae5c63c07938.1603690202.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 03:58:11PM +1000, Pavana Sharma wrote:
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

Please swap the order of the patches so the build does not break.

       Andrew
