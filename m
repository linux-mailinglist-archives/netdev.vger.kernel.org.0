Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F39576CB9
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 11:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiGPJMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 05:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiGPJMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 05:12:53 -0400
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFC61EC54;
        Sat, 16 Jul 2022 02:12:47 -0700 (PDT)
Received: from madeliefje.horms.nl (86-88-72-229.fixed.kpn.net [86.88.72.229])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id E9B4C20088;
        Sat, 16 Jul 2022 09:12:44 +0000 (UTC)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 6A21E28BD; Sat, 16 Jul 2022 10:12:44 +0100 (BST)
Date:   Sat, 16 Jul 2022 11:12:44 +0200
From:   Simon Horman <horms@kernel.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: ipvs: Use the bitmap API to allocate bitmaps
Message-ID: <YtKBDApu3y4noIGC@vergenet.net>
References: <420d8b70560e8711726ff639f0a55364e212ff26.1656962678.git.christophe.jaillet@wanadoo.fr>
 <b69d7ba1-22f8-80c3-c870-debd7aaf4cea@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b69d7ba1-22f8-80c3-c870-debd7aaf4cea@ssi.bg>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.6 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 01:05:54PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Mon, 4 Jul 2022, Christophe JAILLET wrote:
> 
> > Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> > 
> > It is less verbose and it improves the semantic.
> > 
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> 	Looks good to me for -next! Thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Acked-by: Simon Horman <horms@verge.net.au>

