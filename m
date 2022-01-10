Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D5A48908E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 08:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbiAJHMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 02:12:05 -0500
Received: from verein.lst.de ([213.95.11.211]:37052 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230433AbiAJHMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 02:12:02 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id EE2E768AFE; Mon, 10 Jan 2022 08:11:59 +0100 (CET)
Date:   Mon, 10 Jan 2022 08:11:59 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ixgbe: Remove useless DMA-32 fallback configuration
Message-ID: <20220110071159.GC625@lst.de>
References: <aafc0597758dd8ba58c15e4bf2e669872246c839.1641748850.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aafc0597758dd8ba58c15e4bf2e669872246c839.1641748850.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
