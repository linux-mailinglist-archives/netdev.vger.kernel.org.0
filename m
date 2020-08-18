Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08578248F86
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHRUPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:15:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgHRUPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 16:15:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k880b-009ydn-Lg; Tue, 18 Aug 2020 22:15:01 +0200
Date:   Tue, 18 Aug 2020 22:15:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next 04/18] gve: Add support for dma_mask register
Message-ID: <20200818201501.GL2330298@lunn.ch>
References: <20200818194417.2003932-1-awogbemila@google.com>
 <20200818194417.2003932-5-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818194417.2003932-5-awogbemila@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 12:44:03PM -0700, David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Add the dma_mask register and read it to set the dma_masks.
> gve_alloc_page will alloc_page with:
>  GFP_DMA if priv->dma_mask is 24,
>  GFP_DMA32 if priv->dma_mask is 32.

This needs reviewing by somebody who knows this stuff. My limited
understanding is the core should take care of most of this, so long as
you tell it of any device restrictions.

    Andrew
