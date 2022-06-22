Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25F4556E5D
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 00:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348945AbiFVW0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 18:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236938AbiFVW0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 18:26:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFF731506;
        Wed, 22 Jun 2022 15:26:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAC04B82113;
        Wed, 22 Jun 2022 22:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D94C34114;
        Wed, 22 Jun 2022 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655936778;
        bh=3kKgnxet67qUn0V5uViTTEdK/1y5bYRFZPNdCjiJZyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ce9c879g2Dg501B5vFCfH3bveqQ4PwKTLeMUjZusxRbbB2MtTy1UeovkFrJUGhAMm
         mlwp+BCVLoPLRqeHnjv1xzl0H3d4L128I0Cz81Bg24VZfss97LFwlMHUgAG5ZbhK5q
         PshqzhVZYvr89g9juYhW+9jVh5+GLP/2ODYMGpPJNabeKbF944QdSulvHQPhSX6c7C
         mdZ0mzyxhnvfKkf0ck5SfyMJnQT3U4AG5xMjfGxsPgTdfCLAoFJDxKM8BFBttOdC3Z
         c49lLLFTT5p4TpU14Yq05XDvLPe/wgyLPm29FhOVVXk2QH1rzpmBqpf1xxReDYfYE1
         GpSgSUOIifHZA==
Date:   Wed, 22 Jun 2022 15:26:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, john.fastabend@gmail.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        borisp@nvidia.com, cong.wang@bytedance.com, bpf@vger.kernel.org
Subject: Re: [PATCH net 2/2] sock: redo the psock vs ULP protection check
Message-ID: <20220622152616.042bddfd@kernel.org>
In-Reply-To: <87fsjw4nlc.fsf@cloudflare.com>
References: <20220620191353.1184629-1-kuba@kernel.org>
        <20220620191353.1184629-2-kuba@kernel.org>
        <87fsjw4nlc.fsf@cloudflare.com>
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

On Wed, 22 Jun 2022 19:24:16 +0200 Jakub Sitnicki wrote:
> I followed up with a regression test, if you would like to pick it up
> through net tree.

Sweet, thanks!

> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
