Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D54C56C668
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiGIDdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGIDdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:33:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D38A820C0;
        Fri,  8 Jul 2022 20:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD9FAB82A1D;
        Sat,  9 Jul 2022 03:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D514C341C0;
        Sat,  9 Jul 2022 03:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657337587;
        bh=ugFiovc7m44b0FenhKNQS4eDQkaEmy5xYxTtkxV3VwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nw13PnU9WR7nVwr7el2uN1RZQMij8FRaksYLlNZjlas3xs/v3QMXvhC/W8r+AjvMr
         Su18Ya3ikZDd1O+GYyzwqcn/kdbguZ6TyNNOkjqnfoqR7vcTxGIWWlCQOmTDVQC2Oy
         L18p8I24prY8mZMbvewHuVc/4Q9T5HzKNL7emS+Q/V2+BTBkTX/3YVEmu0mF+GucLi
         Zi3sW7VnL59wky7ZLF+fm4i0bUeAh9QYuSRgGezvJ/5bFGgpT9f3aTbDlTt8jvL0Bc
         uGpkvoHTfORaNYN8HsnGJY6/66X1xKUcW7CT09gzzNSSuGBcz24H4SApDqgXMAlmM7
         GthpTEC8gObvw==
Date:   Fri, 8 Jul 2022 20:33:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bo Liu <liubo03@inspur.com>
Cc:     <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: wwan: call ida_free when device_register fails
Message-ID: <20220708203306.599d1cda@kernel.org>
In-Reply-To: <20220708020223.4234-1-liubo03@inspur.com>
References: <20220708020223.4234-1-liubo03@inspur.com>
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

On Thu, 7 Jul 2022 22:02:23 -0400 Bo Liu wrote:
> Subject: [PATCH] net: wwan: call ida_free when device_register fails
> Date: Thu, 7 Jul 2022 22:02:23 -0400
> X-Mailer: git-send-email 2.18.2
> 
> when device_register() fails, we should call ida_free().

We'll need a Fixes tag pointing to the commit where the problem was
introduced. Please add it above your sign-off tag and repost.
