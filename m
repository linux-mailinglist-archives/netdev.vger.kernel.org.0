Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486374EDEDE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240025AbiCaQgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbiCaQgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:36:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219BC1BBE32
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B56C96158A
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 16:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2796C340ED;
        Thu, 31 Mar 2022 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648744496;
        bh=eNST1WhWkZaS2B5y2S3JrFVNAJslLANmcwaS+vY4GUo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fO6LDYb17v/i3O8p/q6KR/IVfzNC1t6anRI5viBuT/8I8FU+OfRTEDUzA/XfnOiwr
         FB8yk85Dw+SQIp1BzXprrD/05kLuWfRx03/zob6M6WFiwUeN89Ds0RooEFzuUVyDWE
         eabkp0advx7lMrl6qhFhV+xgmdu4ivX2X2yXBr7kbWaBPtkhLPf5nwoMrTEC+p0s/R
         nIY+sqUe3BB7myB8B5UmgctlT6aLgXD/dRU0L1L3EpYJgptB4rBqY1wyNycEXab3wz
         X9T9KMoRHBEq22icIwbuoPU2vvqs1GdxKc1vO5Yrm/h9WrEDzs9uAsRp5LSgg6txPU
         ARxS1GiLpBonw==
Date:   Thu, 31 Mar 2022 09:34:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: Could you update the
 http://vger.kernel.org/~davem/net-next.html url?
Message-ID: <20220331093454.2b85b1b9@kernel.org>
In-Reply-To: <3260216.1648743937@warthog.procyon.org.uk>
References: <20220331083446.1d833d78@kernel.org>
        <3097539.1648715523@warthog.procyon.org.uk>
        <3260216.1648743937@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 17:25:37 +0100 David Howells wrote:
> > >       http://vger.kernel.org/~davem/net-next.html
> > > 
> > > but the URL no longer points anywhere useful.  Could you update that?  
> > 
> > It should display an image of a door sign saying "open" or "closed".
> > What do you see?  
> 
> A door sign saying "Sorry we're closed".  That would seem to indicate that the
> URL is essentially defunct.

It signifies that net-next is closed and we're only taking fixes.

If we were more artistic we could fashion a clearer sign,
it's a stock photo.

I guess we could add some clarifying text to the site itself. 
It's only spelled out in the title of the page.
Let's put that on the todo list for the next merge window :)
