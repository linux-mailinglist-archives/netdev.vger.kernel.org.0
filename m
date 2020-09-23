Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7572757AE
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 14:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIWMHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 08:07:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51112 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgIWMHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 08:07:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kL3YC-00FsR9-OA; Wed, 23 Sep 2020 14:07:08 +0200
Date:   Wed, 23 Sep 2020 14:07:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     yue longguang <yuelongguang@gmail.com>
Cc:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipvs: adjust the debug order of src and dst
Message-ID: <20200923120708.GD3770354@lunn.ch>
References: <CAPaK2r921GtJVhwGKnZyCcQ1qkcWA=8TBWwNkW03R_=7TKzo6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPaK2r921GtJVhwGKnZyCcQ1qkcWA=8TBWwNkW03R_=7TKzo6g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:06:25PM +0800, yue longguang wrote:
> From: ylg <bigclouds@163.com>
> 
> adjust the debug order of src and dst when tcp state changes

Hi Yue

You need to explain why you are doing something, not what you are
doing, in the commit message.

	Andrew
