Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8411631E9F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiKUKnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKUKnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:43:18 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42518C64
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:43:18 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 267E268AA6; Mon, 21 Nov 2022 11:43:14 +0100 (CET)
Date:   Mon, 21 Nov 2022 11:43:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Christoph Hellwig <hch@lst.de>, Greg Ungerer <gerg@linux-m68k.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-m68k@lists.linux-m68k.org, uclinux-dev@uclinux.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: fec: use dma_alloc_noncoherent for m532x
Message-ID: <20221121104313.GA4644@lst.de>
References: <20221121095631.216209-1-hch@lst.de> <20221121095631.216209-2-hch@lst.de> <CAMuHMdVWjDYEAXqWuYYEOb=C-phYjS7wYNPSyZYweR0WhzSZ+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVWjDYEAXqWuYYEOb=C-phYjS7wYNPSyZYweR0WhzSZ+A@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 11:24:29AM +0100, Geert Uytterhoeven wrote:
> > +#ifdef CONFIG_M532x
> 
> Shouldn't this be the !CONFIG_M532x path?

Yes.
