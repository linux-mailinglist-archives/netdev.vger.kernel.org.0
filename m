Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A051523A4A
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344729AbiEKQ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiEKQ0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:26:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71A564BE1
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6235561C83
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D739C340EE;
        Wed, 11 May 2022 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652286410;
        bh=5aG4pAACtormp3T5m4bnBrzMzGiKk8nixceXAwUbxik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c042Ztou3zS5lpPpvGeDyjxfqOOQta1tz68s8tUualXSOOiOJu23TH3xvkOrpCBx6
         6b8ilEi1Y3RJdRbZwMerUszm3echSTsl1OSUf/7HvWonp/rdiZ+cbr8Tb3CpZlBNoi
         JAKNqCp7SGyMRCrGE/JKRH5JKzQ6BVI7NaZpfER/fVBy2NncpdsDRiah6/D+X8QDsu
         j4hc9bQ2p4VpFHeFk9EMtexnFb2CjxKH9PXsIkz+GTl9ajccvR5pZSFVgEInUZZc7c
         tN5XqUqXl1j7xFSDJt91itFXF5S+zjoQmIQ1pVXVcjonBoWyr1+jzkL5fdo370QzdN
         sInD+ch20mZgQ==
Date:   Wed, 11 May 2022 09:26:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v5 net-next 13/13] mlx5: support BIG TCP packets
Message-ID: <20220511092648.145be621@kernel.org>
In-Reply-To: <202205101953.3C76196@keescook>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
        <20220509222149.1763877-14-eric.dumazet@gmail.com>
        <20220509183853.23bd409d@kernel.org>
        <202205101953.3C76196@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 19:55:16 -0700 Kees Cook wrote:
> On Mon, May 09, 2022 at 06:38:53PM -0700, Jakub Kicinski wrote:
> > So we're leaving the warning for Kees to deal with?
> > 
> > Kees is there some form of "I know what I'm doing" cast 
> > that you could sneak us under the table?  
> 
> Okay, I've sent this[1] now. If that looks okay to you, I figure you'll
> land it via netdev for the coming merge window?

I was about to say "great!" but perhaps given we're adding an unsafe_
flavor of something a "it is what it is" would be a more appropriate
reaction.

Thank you!
