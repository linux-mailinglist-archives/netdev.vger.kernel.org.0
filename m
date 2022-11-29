Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02DD63BB4B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiK2IMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiK2IMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:12:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794712612B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41047615E0
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFF0C433B5;
        Tue, 29 Nov 2022 08:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669709568;
        bh=hQ9zxYTar/4dYGJmpEeQQqpg6N4eD6H2a1DzYeHIzVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A4yd/AG4trRIRCHJj2RYL+3IR9kagfxZVUXChKYMkgnSzuJzCVH1Qtd6FR5wIiitn
         Y+3u8fYKK2J9HfS1HbY0Lv6oWEETdwbYX3Nl0SpsvmWVKNCLFgTNGSlXjIH6frHAcu
         uDDXFysonBgxuYI0jk2oVmd23tbOkTI3DJ3hcQQCRUPLQtfdPU3S3hVHbaYAxHgDLf
         P0/ABENkuGWJoFXSUyV18A0j1aYqCzvc6VehZb+nJ5nqKsl8lJVS3223KFYa709aMC
         GPpMBJdQfBc2FNpOLilgXC07I2eVO7pKcChI52rPWki0Cbwj7ymXe5/G0MIWH7P9tK
         aSsh0JHbW13tQ==
Date:   Tue, 29 Nov 2022 00:12:47 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [net 13/15] net/mlx5e: MACsec, remove replay window size
 limitation in offload path
Message-ID: <Y4W+/6MIAP2ZSqiz@fedora>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-14-saeed@kernel.org>
 <4bc41493-f837-6536-5f10-7359cf082756@intel.com>
 <20221128193553.0e694508@kernel.org>
 <Y4WcWaVbNptkQiEL@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y4WcWaVbNptkQiEL@fedora>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Nov 21:44, Saeed Mahameed wrote:
>On 28 Nov 19:35, Jakub Kicinski wrote:
>>Damn it, this is a clang warning, I need to rescind the PR :/
>
>Make sense, Jacob found two real issues and this one is critical,
>but I don't know how that works for PRs, let me know when you do it so I
>will add his reviewed-by tags and address the two issues when is send v2.
>

hmm, I thought you were planing to revert my PR :).. anyways, i am will
send the two fixes soon, so you could release your pr to linus,
sorry about the mess.

