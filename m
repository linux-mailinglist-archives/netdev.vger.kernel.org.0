Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C66A58092E
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 03:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiGZBsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 21:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiGZBsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 21:48:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFF328730
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 18:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7653DB8117A
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 01:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC621C341C6;
        Tue, 26 Jul 2022 01:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658800083;
        bh=/TcyTK/6IYwhEubXLPwQwfFa5ROrOTDSpePcD4JQh5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SEU8JXTHIvnx9wzsyAozawf3X/251++quKfxtFGrusrJfoOF5QTxhoXuh8421DVaj
         r8hl7hxlZJ5ScjFJ8gg6VfVUGsfprCkxwH1z4TDjRXTxRqZADxeH6AzgNnZCUGOezf
         /bBew20kPIgz+S2/FISLjv9wkifaCAaMoqHIMvdPB1uQE9Sw7Wt9C0uIBqdfRm82f4
         PGjwM74ktSwH6atUCSYae4WpvEwIt+cTvVy9ozskKBZlT0CDuXVQd8CI5mi5xx4xrF
         r2M/FwcmBlM6wZUgIaIzD5YJ5cm9MqJajUuTMIE45qUlXDHnVRlEWcYcX9pIzOu89R
         bE3bIoMuazUyQ==
Date:   Mon, 25 Jul 2022 18:48:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v4 02/12] net: devlink: move net check into
 devlinks_xa_for_each_registered_get()
Message-ID: <20220725184801.2afb9cd8@kernel.org>
In-Reply-To: <20220725082925.366455-3-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
        <20220725082925.366455-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 10:29:15 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Benefit from having devlinks iterator helper
> devlinks_xa_for_each_registered_get() and move the net pointer
> check inside.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
