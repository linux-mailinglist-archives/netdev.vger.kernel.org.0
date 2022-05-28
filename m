Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC912536A1E
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 04:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352103AbiE1CJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 22:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiE1CJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 22:09:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B24662BD4;
        Fri, 27 May 2022 19:09:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2F1661D05;
        Sat, 28 May 2022 02:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05063C385A9;
        Sat, 28 May 2022 02:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653703781;
        bh=QFhKffhE6zS5J/TspsJzWYbTcRtl1hy3XISW5o2FiVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YqEVxIhyg+6+nJ4AWM8iYyXRrEHDWkkdt8Mul5bsR6uJMVt0WQrC1FlyWtfKphO8X
         7GRq1DtnCdl3ePZOsYlQHNS4xbWBs5hKyZ8DCZm/aY6sT2TTvZURpvA+Sz/3f0xkgs
         ilKTbv/48dchq0D7rMzGi9Bifu7jsgi64pVvnXpEmg1G0bkdnKRS0f3eysvBe0OdzL
         eyer0j9DMFhuVU2ABLE5pfi5tJTY4/tEZ5a7nH0wiiJK5dcy9QC3bGYVBiOES0qojH
         hfybmw7C+89yFjRZS/3DHJeYt0Dtri9uEHzCX7aUJ4nG1IXnFT8avKmyEjl8XGwahP
         n54wkLl/rmJ5g==
Date:   Fri, 27 May 2022 19:09:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/8] vmxnet3: upgrade to version 7
Message-ID: <20220527190939.1b85a131@kernel.org>
In-Reply-To: <20220528011758.7024-1-doshir@vmware.com>
References: <20220528011758.7024-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 May 2022 18:17:50 -0700 Ronak Doshi wrote:
> vmxnet3 emulation has recently added several new features including
> support for uniform passthrough(UPT). To make UPT work vmxnet3 has
> to be enhanced as per the new specification. This patch series
> extends the vmxnet3 driver to leverage these new features.

# Form letter - net-next is closed

We have already sent the networking pull request for 5.19
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.19-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
