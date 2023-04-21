Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB04C6EACDD
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjDUO26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjDUO25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:28:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F9830E9;
        Fri, 21 Apr 2023 07:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9645665101;
        Fri, 21 Apr 2023 14:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F192C4339C;
        Fri, 21 Apr 2023 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682087336;
        bh=SqeL1ZjkoRfB8AReeHRqh0HINangrhAFQKlYy4oXftg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Th0K9geNEH69pqjscKcQfL3qpAFMkpWCc+gR6hBFLwEQ6p3/CtvF5IXgdbe6uhh++
         rdVFOI00HZ8WgQcDIATtz9KYRKtMsDH6GwroH5aU+EkMsj0ylwzcXMNy15p4T3IHml
         U4jX2ZlkkGgQy63R46X35rYMZpxQLIz9ablkeEH92233CKEcZmAQ4QC3TqelBQxm57
         K1u3fVZSLGJ9akkB4ZO2nqoKgbDkBHzCVbV4V4i7cSrpyJ2zxiVx5oabBaSZJNv5g5
         R5plKo1KeZjncc8dBfeKRe1+j3LM9CR4DJK7IaeR02NIjkplgHCUk/Cg//c2Rzs5X5
         A9/7AeWW8fgoA==
Date:   Fri, 21 Apr 2023 07:28:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Jikai <wangjikai@hust.edu.cn>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        hust-os-kernel-patches@googlegroups.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2] wifi: mt7601u: delete dead code checking debugfs
 returns
Message-ID: <20230421072854.6521ecef@kernel.org>
In-Reply-To: <20230421092200.24456-1-wangjikai@hust.edu.cn>
References: <20230421092200.24456-1-wangjikai@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 09:22:00 +0000 Wang Jikai wrote:
> Smatch reports that:
> drivers/net/wireless/mediatek/mt7601u/debugfs.c:130
> mt7601u_init_debugfs() warn: 'dir' is an error pointer or valid".
> 
> Debugfs code is not supposed to need error checking so instead of
> changing this to if (IS_ERR()) the correct thing is to just delete
> the dead code.
> 
> Signed-off-by: Wang Jikai <wangjikai@hust.edu.cn>

Acked-by: Jakub Kicinski <kuba@kernel.org>
