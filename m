Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2537851A259
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351372AbiEDOks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiEDOkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:40:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994771FA62;
        Wed,  4 May 2022 07:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 531A3B825A5;
        Wed,  4 May 2022 14:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57C2C385A4;
        Wed,  4 May 2022 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651675029;
        bh=MSt2zlmGXVoqI6N9XTs/+AqjMOyxIZe/p2Hq/hvMrd4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F7eEElwlh37OuvPZ3dRT/g0xVUbLe7yzBTe/yP3K47P96Qu5nRGqmS34Xzq0Zpy2L
         UHUU6a3YNYj9+/2HnhiCj6vntOnIVdbrk6UUCFAlZTXIPfElNQ2ycBYA1F9N8GXiEP
         sW3Eu2CX2INXIr7Rj5zvMf+H8nBMmzmklhPF6m03wkFKA4UMOFIPgyNL8yg2IfCv2q
         TXHaFnzVUm8MqOMGttsHibvxnwbvKx4Upv20z2JNf2/3mEybI0ETC3zH/3vg8jYZ1n
         rI4Av6LTEb/ELKI1bcNivcaMvEcCmQCaRc8s8yYxZApESLjFvvZCm1AAY5F/SF7Inu
         pU3TlAcUOZ8gA==
Date:   Wed, 4 May 2022 07:37:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Akira Yokosawa <akiyks@gmail.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Dave Jones <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH net-next] net/core: Remove comment quote for
 __dev_queue_xmit()
Message-ID: <20220504073707.5bd851b0@kernel.org>
In-Reply-To: <c578c9e6-b2a5-3294-d291-2abfda7d1aed@gmail.com>
References: <9d8b436a-5d8d-2a53-a2a1-5fbab987e41b@gmail.com>
        <c578c9e6-b2a5-3294-d291-2abfda7d1aed@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 May 2022 22:43:12 +0900 Akira Yokosawa wrote:
> > I can't think of preserving delineation between actual documentation
> > and the quote without messing up kernel-doc.  

That's not what I'm complaining about, I'm saying that you rewrote 
the documentation. There were 3 paragraphs now there are 2.

> Actually, it is possible.
> 
> See "Block Quotes" in ReST documentation at:
> https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#block-quotes
> 
> kernel-doc is basically ReST within comment blocks with several kernel-doc
> specific implicit/explicit markers.

With all due respect I don't even know who (what?) "BLG" is.

Let's just get rid of the delineation and the signature and make 
the text of the quote normal documentation.

> > Actually the "--BLG" signature is the culprit.  

