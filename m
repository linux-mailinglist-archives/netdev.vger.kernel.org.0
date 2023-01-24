Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDEB679024
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjAXFpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbjAXFpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:45:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD9D3A5B5
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:44:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84EAC611B5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A98EC433D2;
        Tue, 24 Jan 2023 05:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674539082;
        bh=DVvU+AMG8FnLPnXiv5r86FMhbmfceKftwrgLoYZRhyQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m6qDq9xuwh7okndzqjFv0WHCt9a9piGD8q4dJfdjh0AImDcEFi84iXKXShIPtlo57
         SzNHCxKR+uBHPluUpKUPiQjTSFGZoGXt4BALGMoYjVIvJWQI4G7A5BFW/SKrJEYwxf
         fPu6pqpNZrkg2X/XQYyIatGiKh43jWqzg8+ngrMyAk7c1rWTb7Hz0SFIRistOIGCi5
         Ca5j0VeEWa6hz95mg0IVcf4obcAPOwPbTekbeG0VQpAx6mDuc8c5UXfgMFK0lzkAUD
         +zPEZHD42uAXRAN1Ffe6rp3n9GU/MK7YhmWh5hW2L1nrIYYWHqMmp6reC3Cm6KwLWT
         bHUIbqtU3CKQg==
Date:   Mon, 23 Jan 2023 21:44:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net] MAINTAINERS: Update MPTCP maintainer list and
 CREDITS
Message-ID: <20230123214440.42de75e5@kernel.org>
In-Reply-To: <20230120231121.36121-1-mathew.j.martineau@linux.intel.com>
References: <20230120231121.36121-1-mathew.j.martineau@linux.intel.com>
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

On Fri, 20 Jan 2023 15:11:21 -0800 Mat Martineau wrote:
> My responsibilities at Intel have changed, so I'm handing off exclusive
> MPTCP subsystem maintainer duties to Matthieu. It has been a privilege
> to see MPTCP through its initial upstreaming and first few years in the
> upstream kernel!

Thank you for all the work!
