Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A56C3ACC
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCUTjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCUTiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:38:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C39CC08
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50606B818CC
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 19:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9855AC4339C;
        Tue, 21 Mar 2023 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679427437;
        bh=qOQ//ah51ATfM5M30XQXaDUgv/BJjWGeWgYN1E8z+ys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EnRyywbn31sMEDIov0f2249hW8QCwh8IkEci0VlZUk6pNKmN5lLPXE/74lcOOB63O
         fPEBd+TQcyqGPsr4LdjuSu5N80IcVhZgFHVolZ7F3rMxCvezD2atFl2sbl3rt/V9fk
         2mHCG5KR9W36WPdr8/G9MAyLypoFZIZr7AB3kdav3d/XHZcX+JrebWbWCnB63jYKjP
         FIIag3E5dTeLF0Kun6j3Yf0pJwDxFXDH/mooApVEc30bJJ31qTqltdnEku/+PZ8izB
         8SZF978OpYTSKgop6TneupXRH3QdaN7R4dbtCgRDTLbISs0R1g1f/tqE/aRfqLXhqp
         84SytX1OCTMsA==
Date:   Tue, 21 Mar 2023 12:37:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paul Blakey <paulb@nvidia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [GIT PULL] Extend packet offload to fully support libreswan
Message-ID: <20230321123715.3aaca214@kernel.org>
In-Reply-To: <20230321071830.GN36557@unreal>
References: <20230320094722.1009304-1-leon@kernel.org>
        <20230321071830.GN36557@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 09:18:30 +0200 Leon Romanovsky wrote:
> So who should extra ack on this series?

Me or I, hard to tell because of the missing verb.
