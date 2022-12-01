Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FE263E98A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiLAF7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiLAF7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:59:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712EB5CD36
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 21:59:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F3761D55
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 05:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0078C433D6;
        Thu,  1 Dec 2022 05:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669874393;
        bh=TNRnzv1Eq9b7TErjAb93e3Js4au6Ksv41h/FlLJ0Ji4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PylR/4Bt8lSCQ7JAhPJakQAk3gNoDGKiBpur4Pw3OxaKLw0Eem2wO2Ng2QQ8D1M4A
         o4lo8drKsjROVJRLBE+vpssduvs2KOmE4P4kCC3F9AbUck5AVGVvZPoY5LwpKtJ7FN
         sEFcgF/vQQ/zP4VeTLewnUa0mTu59/ch8u17R3Rh7YvWo9ZqDKE7VXMpPhUGc72SIh
         xM29mIVQJJ7pn+20u8VtPg2rSbq9Itc1bNNla4VaxOKPHhHBdRQjaVM7/dqyI7BmSq
         QQpDkEhvXNZPgYRLCMTBgE4vTp4vx1AWTyntzAshlVVNx92GmOHul3X29xQatrLfUQ
         QHhIr+cE8tZnw==
Date:   Wed, 30 Nov 2022 21:59:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next v3] net: devlink: convert port_list into xarray
Message-ID: <20221130215952.73e64be3@kernel.org>
In-Reply-To: <20221130085250.2141430-1-jiri@resnulli.us>
References: <20221130085250.2141430-1-jiri@resnulli.us>
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

On Wed, 30 Nov 2022 09:52:50 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Some devlink instances may contain thousands of ports. Storing them in
> linked list and looking them up is not scalable. Convert the linked list
> into xarray.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
