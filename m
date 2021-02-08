Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6916631415F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhBHVMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233796AbhBHVLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:11:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DEA64E56;
        Mon,  8 Feb 2021 21:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612818668;
        bh=AQeDOuOiSlG5YjGgNUfNNC+SoXDPPpkQz+C0THAK1+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O1KpRd7O4dAUT0NB5uIFSCYVyRDr35BisQXMaCmQIxK2gD1HIYBQWVllSmvMqXRIs
         RDqZ0V1IIw7+GsmyizjiqYrLXa7rQ0iEsU7fCCAsm4RAb42t8AwjaQNheRv1p/TEPD
         S43zkpV9gR+LxbrUfATueEWsSxxkvax9HejrWtmgc4p42bDkZpHTWgQJN4RwCpWQ/k
         17KIe5Rg+h4tmjo0kOnqmC+cdqB9D3EDbYDRJultg4EvxEI3VakG2cM+pc53IKZncd
         UuXj3LVGpHaPWyUU3RyEOFo+RfUzPXvcV6LAhwTw7vYTeaO3nDVFq29bsNP0zHO9SG
         uiKs7DZTFUXLA==
Date:   Mon, 8 Feb 2021 13:11:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] i2c: mv64xxx: Fix check for missing clock
Message-ID: <20210208131106.1dba2609@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4f696b13-2475-49f2-5d75-f2120e159142@sholland.org>
References: <20210208062859.11429-1-samuel@sholland.org>
        <20210208062859.11429-2-samuel@sholland.org>
        <4f696b13-2475-49f2-5d75-f2120e159142@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 00:31:34 -0600 Samuel Holland wrote:
> On 2/8/21 12:28 AM, Samuel Holland wrote:
> > In commit e5c02cf54154 ("i2c: mv64xxx: Add runtime PM support"), error
> > pointers to optional clocks were replaced by NULL to simplify the resume
> > callback implementation. However, that commit missed that the IS_ERR
> > check in mv64xxx_of_config should be replaced with a NULL check. As a
> > result, the check always passes, even for an invalid device tree.  
> 
> Sorry, please ignore this unrelated patch. I accidentally copied it to
> the wrong directory before sending this series.

Unfortunately patchwork decided to take this patch in instead of the
real 1/5 patch. Please make a clean repost even if there are no review
comments to address.
