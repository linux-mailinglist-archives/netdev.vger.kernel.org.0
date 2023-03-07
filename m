Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3076AEA25
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjCGRbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCGRas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:30:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B99A6751;
        Tue,  7 Mar 2023 09:26:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52336611A1;
        Tue,  7 Mar 2023 17:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730DDC433D2;
        Tue,  7 Mar 2023 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678209965;
        bh=m9jc81Pj1PKOfL+JKl/PmdayHEWkLYIw+XAAuz4V37E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fxbBWOPGJDUFXUNTXoikMRzwUcIicWL3tqu/LKPHLq2XzynpmrRFmnW/AIYx5JbsT
         z/8akKaoPQW/6CSZFd74pOrh0LeamoneqLi22xWKmk9PEZ3me3mq5lH/VfJT2KMpSX
         fzESIhq4bIKxklJK9dwzIasw+Nm9tADh0mnEMJL+woBrptsmn5x7vZbEFd4Wvsei5A
         J96v6c/BDwb1skaHzkWYcd62oacmHxH2mw+CSudFX4cdcWo2AzXLREWACP7Uyo8XOk
         hHFkhR2JwFBlDqtneRYw2mJwI+QEiKumfB7RBTCcQB6BzFXmZcY1SAFujNn2CHBD64
         JFKHY6H3kUw4g==
Date:   Tue, 7 Mar 2023 09:26:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <20230307092604.52a3ce34@kernel.org>
In-Reply-To: <66e565ba357feb2b4411828c65624986eaefb393.camel@redhat.com>
References: <20230307100424.2037-1-pablo@netfilter.org>
        <66e565ba357feb2b4411828c65624986eaefb393.camel@redhat.com>
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

On Tue, 07 Mar 2023 13:57:07 +0100 Paolo Abeni wrote:
> On Tue, 2023-03-07 at 11:04 +0100, Pablo Neira Ayuso wrote:
> > The following changes since commit 528125268588a18a2f257002af051b62b14bb282:
> > 
> >   Merge branch 'nfp-ipsec-csum' (2023-03-03 08:28:44 +0000)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD  
> 
> It's not clear to me the root cause, but pulling from the above ref.
> yields nothing. I have to replace 'HEAD' with main to get the expected
> patches.

Possibly netfilter folks did not update HEAD to point to main?

ssh git@gitolite.kernel.org symbolic-ref \
    pub/scm/linux/kernel/git/netfilter/nf \
    HEAD refs/heads/main
