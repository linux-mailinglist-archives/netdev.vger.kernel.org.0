Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB5E64C1CA
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbiLNBX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbiLNBXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:23:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F83526AC5;
        Tue, 13 Dec 2022 17:23:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E225B81627;
        Wed, 14 Dec 2022 01:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066FEC433EF;
        Wed, 14 Dec 2022 01:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670981032;
        bh=GB28ZuduRB/j6DYpcgA6kM/a4VeK/gxCj9bnVU2Yzy4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t5T5j5UGpincN7BrsJGtTng/IGxd0mu02oJyH7Nt7aqqxUL654YwdgW/xrtdMA948
         LeItriH9mldmuE/uOvy6DNcU1Mc9hibS4wDuLQAz8pi2IxxVGwfRQ4t0h06ilIqfUD
         m/oO0GVHAPNlU9o/FpoVAJOwYjlknD34f1Zlci7pYAmk8f0Gc+xep5jnIvKS29SvNk
         nsNIxCdaP09W0Z1NO0flk6ZeJFCaNmDMDnvIaRqMc3kZ8iVUwLUg+5oM2gl9Eu+rKo
         Wr0qWpdzBKs6kT5kpzAfY5nZOp53WVat6+7n6yf1ZVUWmDpZNHuoHEWZc7p8updW3s
         /xH/naipuYHIg==
Date:   Tue, 13 Dec 2022 17:23:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [PATCH] Documentation: devlink: add missing toc entry for
 etas_es58x devlink doc
Message-ID: <20221213172351.4d251315@kernel.org>
In-Reply-To: <20221213133954.f2msxale6a37bvvo@pengutronix.de>
References: <20221213153708.4f38a7cf@canb.auug.org.au>
        <20221213051136.721887-1-mailhol.vincent@wanadoo.fr>
        <20221213133954.f2msxale6a37bvvo@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Dec 2022 14:39:54 +0100 Marc Kleine-Budde wrote:
> On 13.12.2022 14:11:36, Vincent Mailhol wrote:
> > toc entry is missing for etas_es58x devlink doc and triggers this warning:
> > 
> >   Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree
> > 
> > Add the missing toc entry.
> > 
> > Fixes: 9f63f96aac92 ("Documentation: devlink: add devlink documentation for the etas_es58x driver")
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>  
> 
> Added to linux-can-next + added Reported-bys.

To -next or not to -next, that is the question..

FWIW the code is now in Linus's tree, but IDK how you forward your
trees. We could also take this directly given the file being changed,
but up to you.
