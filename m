Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6222C57EC1D
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 06:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiGWEmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 00:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGWEmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 00:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B196885F80;
        Fri, 22 Jul 2022 21:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FE7960ABE;
        Sat, 23 Jul 2022 04:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344D7C341C0;
        Sat, 23 Jul 2022 04:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658551326;
        bh=rTIYV+dl7+/MDOcVDJkYp5QHCw1B6KZG2M1GwTmtAD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sh6z5+0n+jDyz6EK2pANxNaysYX6KCyEvv8bpuEVxDtuu9FkMjKCHBhIKJXFHhT4P
         7UN2hOs4+R9O2QAm/EbsqmJW3OfKO49sbhJ3AKju7D5zZKSsRagmz2bS+J8d/n79Z/
         hP2K49o1uMhgRZJulxZYUz0CgoQ6wGQB24Vf/bew+2+vsiKvZ9j4WdCljmuHCCoVYD
         4kCXssPmcQInmuwNoyBS+WMRC9tSjbezuNUMoKojvsBLs4pxjY1Ek9HE22AOUaLvi/
         +TBnm14ab5Ow6VgjG2E16VJ5NZZkRyXs0VALv7bfGE/4SU8mu2D2c8olTtJmozhioT
         vsqyRp/NFicNg==
Date:   Fri, 22 Jul 2022 21:42:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hristo Venev <hristo@venev.name>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] be2net: Fix Smatch error
Message-ID: <20220722214205.5e384dbb@kernel.org>
In-Reply-To: <20220722152050.3752-1-hristo@venev.name>
References: <YtlIZgG/wQtxpKMh@kili>
        <20220722152050.3752-1-hristo@venev.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 18:20:52 +0300 Hristo Venev wrote:
> Subject: [PATCH] be2net: Fix Smatch error

Please describe the problem not the tool that found it, and name the
target tree in the tag ([PATCH net] in this case).
