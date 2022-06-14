Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5445954A92E
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbiFNGC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiFNGCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:02:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D902EBC2
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 23:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7162861693
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 06:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6554FC3411B;
        Tue, 14 Jun 2022 06:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655186540;
        bh=ezWWigFOPYFwsVjTJfTv1TwbPe2hJ8fCl/ootGkbP+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KiijDde+WiEp0KOCXUfj36OQRmlG6qpDFifk+iMT+hXCzottEvFySMqc5LA3oRbnm
         ZO4Xfo0nnin5guDaqQlKXEjfE8LGgKRWd5NO1fv/SX2Z2zVpgSikDw8TkX4vP2gWou
         KXf5tbKuh+YH5+/zbCB7CRmuyHxsw+9ig4nkARZdEDqu8eWV2GNQx3NWKziQMMlLVU
         HvWY7/3MRjVf2JvjUNrl52TKoHZqm52JsSpZhA32ZLXjD+JPD3ewRTRecsN5HSy0nP
         uSIpuuPT4qnZjVYJagUISgmeYhXGtCHZWZ+1CgqyZtR9FsIcZW71aTZgto12kIm6R3
         K/Stqtqaq9KGA==
Date:   Mon, 13 Jun 2022 23:02:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuwei Wang <wangyuweihx@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] net, neigh: introduce
 interval_probe_time for periodic probe
Message-ID: <20220613230219.40372863@kernel.org>
In-Reply-To: <20220609105725.2367426-3-wangyuweihx@gmail.com>
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
        <20220609105725.2367426-3-wangyuweihx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jun 2022 10:57:25 +0000 Yuwei Wang wrote:
> commit ed6cd6a17896 ("net, neigh: Set lower cap for neigh_managed_work rearming")
> fixed a case when DELAY_PROBE_TIME is configured to 0, the processing of the
> system work queue hog CPU to 100%, and further more we should introduce
> a new option used by periodic probe
> 
> Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>

The new sysctl needs to be documented in
Documentation/networking/ip-sysctl
