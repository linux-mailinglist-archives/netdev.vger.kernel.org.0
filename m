Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015D86C4281
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCVF7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCVF64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:58:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46D626580
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 22:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E28F661F54
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB51C4339C;
        Wed, 22 Mar 2023 05:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679464711;
        bh=cNeA9Lj9B047J1w1iT5QnLwhEsZYzi3+vHQ+sfiPo/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tCHdrEKDLrknFBIBxHWiwlfm7Q+WUdwnP9E8KTiL+LucUbrh6tJC7qvFmJYfn9t8U
         1NtKU7iGI0o0bGtuHmDFo+pTBuOe3jHRLo0REz3PHIxZqH4e3iZRFwgPFnsvlETS7O
         HblePu4dE3CkL6b7UkGRVcUTlZvAJn96RgNMCrv0Cq1ACv5Gv6tw166yhYlX8EzuXr
         YBOAhsOHKd5N4wFJ6UKSl4A9Pnra8AmowIXwvb/1E5dailJzZVh/XEzyZ0LEhP9IEa
         CeCuh5T4YiCo2vKSsiuTT4ZXyoPZCnLoIerUa7dHOJEffGldLvqKbHJ1L/kXMaNPpp
         4AH0csaKruVJA==
Date:   Wed, 22 Mar 2023 07:58:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paul Blakey <paulb@nvidia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [GIT PULL] Extend packet offload to fully support libreswan
Message-ID: <20230322055826.GW36557@unreal>
References: <20230320094722.1009304-1-leon@kernel.org>
 <20230321071830.GN36557@unreal>
 <20230321123715.3aaca214@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321123715.3aaca214@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 12:37:15PM -0700, Jakub Kicinski wrote:
> On Tue, 21 Mar 2023 09:18:30 +0200 Leon Romanovsky wrote:
> > So who should extra ack on this series?
> 
> Me or I, hard to tell because of the missing verb.

I was under impression that "ack" can be used as verb in mailing list
dialect of English language.

Thanks
