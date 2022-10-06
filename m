Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF95C5F5FAE
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJFDfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJFDfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:35:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA90C80EAB;
        Wed,  5 Oct 2022 20:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DE16B81ED1;
        Thu,  6 Oct 2022 03:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85D2C433C1;
        Thu,  6 Oct 2022 03:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665027347;
        bh=Zoj1phCw8SqpHdAEAds2K04M6IW+XwWuF/6z2PPTlTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jLBr2szy3EmTYv/jEsqG/slAmROzry8yE5EiBp78WkyRrL4Zv7Oe88/G+yIZeM5HT
         ZgKSffcmwvK/1ll7/NOl+Nsn64EOPp/oZCnrr+RQ8bzBvz88B9cYtwIA+H5YUJEPgd
         LnDvxvu6nPZfmFfYR1m18O8KC2g+D7+5FgGxRBxMwJVW7M2saUCZyv+gEJfLz9pfdP
         neRwZr1Rc2nFRQAf/wmoKCNGKdEJwaNXNIZtHQEN+EDW6G+U9pfD0oNHNWWcrUor96
         4znXshnygRoqLNK0UN3/qF7SsyyW0+UyVUT9N6j5kxVIV2t5WvV/NKR4XJLFalRV1y
         OplUnZv86J73Q==
Date:   Wed, 5 Oct 2022 20:35:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, edumazet@google.com, khalasa@piap.pl,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net: ethernet: xscale: fix space style issues
Message-ID: <20221005203545.48531d8e@kernel.org>
In-Reply-To: <20221005120501.3527435-1-clabbe@baylibre.com>
References: <20221005120501.3527435-1-clabbe@baylibre.com>
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

On Wed,  5 Oct 2022 12:04:58 +0000 Corentin Labbe wrote:
> Fix all checkpatch issue about space/newlines.

We don't take checkpatch "cleanups", especially for fossils.
