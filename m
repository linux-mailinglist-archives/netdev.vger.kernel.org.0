Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB3856AF8D
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiGHBEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbiGHBE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:04:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FA971BF8;
        Thu,  7 Jul 2022 18:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65F0761661;
        Fri,  8 Jul 2022 01:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90964C3411E;
        Fri,  8 Jul 2022 01:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242267;
        bh=Xz0fspp/n1Yb/BIrP4uL8mg0S3xyiahIxnNEzxWD+2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ih49Ic1C9Xy79YrgJudDqudd02X1wzzVt8hQr2zRMtYmteAmRHrS+XqszcDhcDAN+
         Pa1xPbJ42pZguwfHGGbamowVcRUy3v/l1jfQzvaIWRe0OvUjaCCfF9ztAR99OCoj1k
         yiomTTjygNXSFA9nlrFU6n5LKoNVDESmxn+6wkGntRBwneie9qqnfAn+ZqkOq70LbL
         EpF7CyCOFelpRdVLXHtZnXM7mf7aITEX7iq4+ptFeAoK4qY3u46ZIEhtFXIny7fZ3O
         KxOaSe8MmCxe22D7xLbKmP0S06fA2irCzUHf4USBeANUT0i6GKM+bhRNbscQQPdOs+
         0ZiGV6tV34FCg==
Date:   Thu, 7 Jul 2022 18:04:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] neighbor: tracing: Have neigh_create event use
 __string()
Message-ID: <20220707180418.67e60f98@kernel.org>
In-Reply-To: <20220707205622.78f4fe2e@gandalf.local.home>
References: <20220705183741.35387e3f@rorschach.local.home>
        <20220707172101.25ae51c8@kernel.org>
        <20220707205622.78f4fe2e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 20:56:22 -0400 Steven Rostedt wrote:
> > > [ This is simpler logic than the fib* events, so I figured just
> > >   convert to __string() instead of a static __array() ]    
> > 
> > This one is also going via your tree?  
> 
> Yep, I can pull it in too.

Acked-by: Jakub Kicinski <kuba@kernel.org>
