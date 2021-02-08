Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDD131332D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhBHNYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:24:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231216AbhBHNV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 08:21:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l96T5-004pOI-DF; Mon, 08 Feb 2021 14:20:43 +0100
Date:   Mon, 8 Feb 2021 14:20:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] i2c: mv64xxx: Fix check for missing clock
Message-ID: <YCE6qwwJngcZMjmn@lunn.ch>
References: <20210208062859.11429-1-samuel@sholland.org>
 <20210208062859.11429-2-samuel@sholland.org>
 <4f696b13-2475-49f2-5d75-f2120e159142@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f696b13-2475-49f2-5d75-f2120e159142@sholland.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 12:31:34AM -0600, Samuel Holland wrote:
> On 2/8/21 12:28 AM, Samuel Holland wrote:
> > In commit e5c02cf54154 ("i2c: mv64xxx: Add runtime PM support"), error
> > pointers to optional clocks were replaced by NULL to simplify the resume
> > callback implementation. However, that commit missed that the IS_ERR
> > check in mv64xxx_of_config should be replaced with a NULL check. As a
> > result, the check always passes, even for an invalid device tree.
> 
> Sorry, please ignore this unrelated patch. I accidentally copied it to
> the wrong directory before sending this series.

Hi Samuel

This patch looks correct. But i don't see it in i2c/for-next, where as
e5c02cf54154 is. I just want to make sure it does not get lost...

	     Andrew
