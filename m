Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAAC63B8D1
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbiK2Djf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbiK2Djd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:39:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6234A9CC;
        Mon, 28 Nov 2022 19:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15965B81101;
        Tue, 29 Nov 2022 03:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75821C433C1;
        Tue, 29 Nov 2022 03:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669693170;
        bh=gVftl/wf7tKDihNNDBagJzN6s//HVR4uBeOHlmwfiFg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXzUUd4hGXA6RawNJ+f6GOWRt8JrpPDI+K+uVdfZomw7MJ/Na6CHRThZvN2/liV/G
         1XOgLQfioCVJKIOgZ4lllUcHslyhiQn8tkSuJyc8ge0ljjZzGDmi1Kvs1waGYexKtd
         qrYx/7lNCzqbo/Ta5AlNxnKQZivo6KpjkgUdE/kknDi8XqOoEa7VQdjUOg0E6E3sfR
         /Qxg7t29N8Vu2kJDEfJdWGI0l0Vfx3ERGeo3Vq1BLbbY2zjWr2yHCs+4KwAnY0jfVf
         OcMaMfhvi4qI246JDOn6o3mtGXeykOl2QlYCGz+WwLOOuT6OVUQrIu7y9S/0BwBPZX
         ND2GU43k2pFIQ==
Date:   Mon, 28 Nov 2022 19:39:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PULL] Networking for v6.1-rc8 (part 1)
Message-ID: <20221128193929.3e7384d2@kernel.org>
In-Reply-To: <20221129025219.2374322-1-kuba@kernel.org>
References: <20221129025219.2374322-1-kuba@kernel.org>
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

On Mon, 28 Nov 2022 18:52:19 -0800 Jakub Kicinski wrote:
> Hi Linus!
> 
> I disappeared for Thanksgiving without communicating properly
> which resulted in some confusion on our side and things not
> getting merged up correctly, so flushing the queue again.
> Probably for the best given some of the patches here.

There is a clang warning in one of the mlx5 fixes here, which got
flagged by our CI/build system but it wasn't noticed. So you may 
want to toss this PR and we'll retry again. Apologies.
