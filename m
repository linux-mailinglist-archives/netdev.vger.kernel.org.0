Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A1367EFFB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 21:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjA0Uw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 15:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjA0Uw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 15:52:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5A21CAFF;
        Fri, 27 Jan 2023 12:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0FE61CB2;
        Fri, 27 Jan 2023 20:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0AFC433D2;
        Fri, 27 Jan 2023 20:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674852774;
        bh=EI2Cd7DddQ4cHwZUEfRyPJFASLDITgFJfNb4SBvJYLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R5OFcqos3HQAWVVDc/HnM15Sr+c+WZRBXzeCBu/YpesDbR+NFyB63Ki/LLNuDBZ2f
         hS07f2aywYK3zr3NoQh8p+ko9QG+Q9imfg82EVJHMXw1fLXczGfnCKUiEsrdNG86js
         60MpZ4Ka+SfAAhLTam2Bm0hf/FhlTGzPly4haWIM=
Date:   Fri, 27 Jan 2023 12:52:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH] scripts/spelling.txt: add "exsits" pattern and fix typo
 instances
Message-Id: <20230127125253.0cee02d6e286b5f7ac63dab6@linux-foundation.org>
In-Reply-To: <20230127092708.43247f7e@booty>
References: <20230126152205.959277-1-luca.ceresoli@bootlin.com>
        <20230126155526.3247785a@kernel.org>
        <20230127092708.43247f7e@booty>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Jan 2023 09:27:08 +0100 Luca Ceresoli <luca.ceresoli@bootlin.com> wrote:

> > On Thu, 26 Jan 2023 16:22:05 +0100 Luca Ceresoli wrote:
> > > Fix typos and add the following to the scripts/spelling.txt:
> > > 
> > >   exsits||exists
> > > 
> > > Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>  
> > 
> > You need to split this up per subsystem, I reckon :(
> 
> Ironically, it was the case initially but I have squashed my commits
> based on several prior commits that do it together. Now I rechecked
> and it seems like this happened only until July 2019, so apparently the
> policy has changed. Will split.

It's not worth the effort.  I'll send the patch upstream as-is.
