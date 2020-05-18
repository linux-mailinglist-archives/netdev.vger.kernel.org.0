Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC71D7FE7
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgERRSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbgERRSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 13:18:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F2F207FB;
        Mon, 18 May 2020 17:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589822284;
        bh=IyYcbei8Co7GNLziygCgwBnXeXn61wr7+vH1FJrXu0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VBH3F+W1CAbLSdka4/B3jgesFQxfqtBV1ukO+pMsmtt921rpYRManmtbfx3qyjTyR
         UAtCyiR5M8vYLGNI+KWL1x1HOCDHmxus786zIFof0bwOPYiJd/ZYOdU+OYfKtxRYDc
         LIXembMFwleCaOTlFwL4iyMdeYfU64WNLN5wotj8=
Date:   Mon, 18 May 2020 10:18:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] sit: refactor ipip6_tunnel_ioctl
Message-ID: <20200518101802.3f81b4da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200518164725.GA17302@lst.de>
References: <20200518114655.987760-1-hch@lst.de>
        <20200518114655.987760-6-hch@lst.de>
        <20200518094356.039e934c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200518164725.GA17302@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 18:47:25 +0200 Christoph Hellwig wrote:
> On Mon, May 18, 2020 at 09:43:56AM -0700, Jakub Kicinski wrote:
> > On Mon, 18 May 2020 13:46:51 +0200 Christoph Hellwig wrote:  
> > > Split the ioctl handler into one function per command instead of having
> > > a all the logic sit in one giant switch statement.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>  
> > 
> > net/ipv6/sit.c: In function ipip6_tunnel_prl_ctl:
> > net/ipv6/sit.c:460:6: warning: variable err set but not used [-Wunused-but-set-variable]
> >   460 |  int err;  
> 
> The warning looks correct, although my compiler doesn't report it :(

W=1, sorry, should've mentioned that!
