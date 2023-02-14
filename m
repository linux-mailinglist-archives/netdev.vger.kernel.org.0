Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46577695602
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 02:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjBNBju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 20:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjBNBjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 20:39:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A684393F3;
        Mon, 13 Feb 2023 17:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F37B819C8;
        Tue, 14 Feb 2023 01:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2FAC433EF;
        Tue, 14 Feb 2023 01:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676338785;
        bh=n2dCccgVW7WTs9nqgRd36PyepOB/ImZe8OFrZeSf8/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V2ZFzNRcvPdTCQrBMF+CgmtmKI4WsbEES8Z2/YBgmLYQKnddu5APgvgcW86ixi/kz
         SfPSzbhIXpHhWmRFyPjmlJmu8vBzR1U6IxKe7pygf8g6A+fOnE+iLjeo40kA3yxez1
         begGrLYrkp2OVJnzOPl39Z8Wd5prU5CTE+NvadpEnnOA3nGhVbX2kgiOd3PKTjivLL
         3OJzYIhkKKA5uS0qF6YBP4E9n1TvNek13IWbriKKZgZIO7RfGLZVcKM0JNqLS16qOB
         P3RQfLt28DbbQ2riEWKe2M+v0jWXjX7eSducgu1sJ2cSyMSkuVSnkcwvu69RwsJc68
         ZaTiS2MXdW/9A==
Date:   Mon, 13 Feb 2023 17:39:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, anthony.l.nguyen@intel.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH bpf-next] ice: update xdp_features with xdp multi-buff
Message-ID: <20230213173944.19906fbc@kernel.org>
In-Reply-To: <20230213172358.7df0f07c@kernel.org>
References: <b564473cdefc82bda9a3cecd3c15538a418e8ad2.1675941199.git.lorenzo@kernel.org>
        <20230213172358.7df0f07c@kernel.org>
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

On Mon, 13 Feb 2023 17:23:58 -0800 Jakub Kicinski wrote:
> On Thu,  9 Feb 2023 12:17:25 +0100 Lorenzo Bianconi wrote:
> > Now ice driver supports xdp multi-buffer so add it to xdp_features.
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>  
> 
> Let me take this one in directly the same as the other xdp_feature
> follow ups.

Ah, this one is where we had a conflict in the bpf-next PR.
You'll need to rebase.
