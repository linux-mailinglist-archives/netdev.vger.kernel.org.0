Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD946877BB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjBBInN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbjBBInM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:43:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A874B8A8
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:43:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED4FB8253D
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2225EC433D2;
        Thu,  2 Feb 2023 08:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675327387;
        bh=rLujI8e1kpEVxqpuUk2M8CeGmoObBngMc2hbbEaF4NI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gwiz59Pi3dOTa1hpU0RC6IJoy8DBwUgw/vuzP7LBmM3unSH4LomRmLIICAQWtgHuO
         urJObCgzn/W2tFL2QeNlKiT/E8qXcu8W8+oHU6L/ghTXA3IprMXevGQ7hCGGAPXlMS
         P6UauqyhMKh6+265B9wl8rI1hOD2fQdpphZqHF4Wp7fPIyZNIezgdkAqe+BLQ0rS7i
         KC2jf7Kq4XDABWiQ28vUt8P/lBhtZpu9EkxBvFR1beDfq2gVEoZUY6MJIDeGhc+K8Y
         oQ4FMfA35cjHAyAuZI42xOlPF+1nuT3fzul2tDK0QLjdLnuwoGCt4ZGeQXiF2pFu8M
         +X5gRGDItmGTw==
Date:   Thu, 2 Feb 2023 10:43:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net 1/6] ionic: remove unnecessary indirection
Message-ID: <Y9t3l3Q6aoEAabY+@unreal>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
 <20230202013002.34358-2-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202013002.34358-2-shannon.nelson@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 05:29:57PM -0800, Shannon Nelson wrote:
> We have the pointer already, don't need to go through the
> lif struct for it.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

It is not net material.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
