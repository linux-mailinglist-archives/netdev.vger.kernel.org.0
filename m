Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC6E6DE538
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDKUCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjDKUCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:02:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B274228;
        Tue, 11 Apr 2023 13:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BF4C62A1E;
        Tue, 11 Apr 2023 20:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3CFC433EF;
        Tue, 11 Apr 2023 20:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681243331;
        bh=EFSFkseU6M+oWZuysyCompodl/pKU5/7L2UKYTuOE9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PbDI07Cox28319WnW3+si6cn21ykp3htEhGCnRLKgowUdvMAPlPYGy5U3/nKupnGc
         SF66aYKAd/wHRzuUYgOHHGrxbEesjoIqhCbYhJBPej0veG0z2vv3LOWuhChCw/d4Tc
         bYgOdliPa9eONudLNeZTbNAJH7C5bPuARwrfl5zXybNBYHe9VCEX/0ynp6c09gcuri
         NRNLX9Tc3zGzumiRWEtrSru1bXWZuASucPgXn8fmNj8srSE6LNBIzTws3uQzPG6tsu
         Gsixp5ZMKVyff4/CVa1jo3JenAh2tyo8fymu489G2SzC2hKF5aDBEkFe121XTvaiLn
         o1LWdxY7xcwsQ==
Date:   Tue, 11 Apr 2023 13:02:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH wpan-next 1/2] MAINTAINERS: Update wpan tree
Message-ID: <20230411130209.6ffe1d21@kernel.org>
In-Reply-To: <20230411090122.419761-1-miquel.raynal@bootlin.com>
References: <20230411090122.419761-1-miquel.raynal@bootlin.com>
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

On Tue, 11 Apr 2023 11:01:21 +0200 Miquel Raynal wrote:
> The wpan maintainers group is switching from Stefan's tree to a group
> tree called 'wpan'. We will now maintain:
> * wpan/wpan.git master:
>   Fixes targetting the 'net' tree
> * wpan/wpan-next.git master:
>   Features targetting the 'net-next' tree
> * wpan/wpan-next.git staging:
>   Same as the wpan-next master branch, but we will push there first,
>   expecting robots to parse the tree and report mistakes we would have
>   not catch. This branch can be rebased and force pushed, unlike the
>   others.

Very nice, feel free to ship these two with fixes.
We often fast track MAINTAINERS updates.
