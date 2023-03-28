Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A4E6CCE4C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjC1X4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjC1X4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:56:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302183A9C
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:55:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03680B81F69
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 23:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785BAC433D2;
        Tue, 28 Mar 2023 23:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680047723;
        bh=sqHk8xYlL+NR3dWzCO9jVPgttnSY417VBzHwOfWodCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=URim8Hz/98oQRoH1xXkc1yFgd+okrCQ34yMi7us4WF5Fy7OFQKXp4m/JbuizwbsKt
         h3u0tmd0unKMonb63+NNmnQH8NxSde9KUzEpuCI0J+oX5/uX1R6uv7E8KUxzRSsVaO
         fwfLcMZ5mfQj5zWqlRDbrSOAmPHk4C0pu8+ONe4rfojx8Tq7kvsKkvhMLcQq2ECqMG
         4kHSUv1jPBKlBEpwn7blXL2S84cDjL+9L0C2G7dAKBddAMpNOsP21X0j4tYGp0aK+b
         ibsK80rdMWsSZZCvA8kSb3fO7fPA38xJLHSz9BU0K2pYJDTgPcgigq/VlcpoesBjLO
         c8ANcBvhHsONw==
Date:   Tue, 28 Mar 2023 16:55:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Voegtle <tv@lio96.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Warning: "Use slab_build_skb() instead" wrt bnx2x
Message-ID: <20230328165522.3ab52007@kernel.org>
In-Reply-To: <b8f295e4-ba57-8bfb-7d9c-9d62a498a727@lio96.de>
References: <b8f295e4-ba57-8bfb-7d9c-9d62a498a727@lio96.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 17:01:24 +0200 (CEST) Thomas Voegtle wrote:
> this warning comes up when this BCM57840 NetXtreme II 10 Gigabit Ethernet 
> card is put in to a bond with another card during booting with Linux 
> 6.3.0-rc4.
> This also can be seen with Linux 6.2.8.

Fix coming up...
