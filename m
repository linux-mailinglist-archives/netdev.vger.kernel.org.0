Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EF11FA719
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgFPDi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgFPDi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:38:57 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED179C061A0E;
        Mon, 15 Jun 2020 20:38:56 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jl2Qz-009k1k-EG; Tue, 16 Jun 2020 03:38:49 +0000
Date:   Tue, 16 Jun 2020 04:38:49 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200616033849.GL23230@ZenIV.linux.org.uk>
References: <20200616103330.2df51a58@canb.auug.org.au>
 <20200616103440.35a80b4b@canb.auug.org.au>
 <20200616010502.GA28834@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616010502.GA28834@gondor.apana.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:05:02AM +1000, Herbert Xu wrote:
> On Tue, Jun 16, 2020 at 10:34:40AM +1000, Stephen Rothwell wrote:
> > [Just adding Herbert to cc]
> > 
> > On Tue, 16 Jun 2020 10:33:30 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Hi all,
> > > 
> > > After merging the vfs tree, today's linux-next build (x86_64 allmodconfig)
> > > failed like this:
> 
> Thanks Stephen, here is an incremental patch to fix these up.

Folded and pushed
