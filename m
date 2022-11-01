Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FF5614E3E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiKAPWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiKAPV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:21:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10D4FD25
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 08:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7AD8B81E6C
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 15:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97F8C433B5;
        Tue,  1 Nov 2022 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667316113;
        bh=vDZlBt6ook0m64Va+ICJQbyXgfJn3QXHlLcVUx2Nukc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ubg7dR99qfJGbWJyhIHTYEkJvkHRIu+Vht26FgZpLnKd40kwkXCvrGKyJUfDuYv71
         0vhp/IhFsKaYXldkkJkVqISii3lX/74ZHf2tCATeMLBs7GxpkrlP0/61JnJ7UBOxxd
         BX6+ORq71LUqBM7feBGv5MOcc19VC0IYyrRFTeXzsBBQ1A5xrfodyarPFMQMrcRdFB
         aqdTmXQkuw+S8iWg4eLcz3KV6t0gy4wYqJLH/vcQxIvqVPPSGt2C0BM1Eou7BpGKQR
         SN+MSHxY4Kg3PoVLniG+gHUUxQ7e7VJix9V3Vd9KlUR46FUNXkaz7pINRkKPR5wPLf
         /8lfbDJHcl4Rw==
Date:   Tue, 1 Nov 2022 08:21:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 1/5] sfc: check recirc_id match caps before MAE
 offload
Message-ID: <20221101082152.25b19c17@kernel.org>
In-Reply-To: <958764a5-8b2d-fe99-c59d-fbdddd53e0bc@gmail.com>
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
        <d3da32136ba31c553fa267381eb6a01903525814.1666603600.git.ecree.xilinx@gmail.com>
        <20221025194035.7eb96c0a@kernel.org>
        <958764a5-8b2d-fe99-c59d-fbdddd53e0bc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Nov 2022 13:30:10 +0000 Edward Cree wrote:
> > This commit made it to net, needs to go separately there.  
> 
> Hmm I might just drop the fixes tag; the cited commit isn't really
>  broken, just suboptimal.

Can you describe the current behavior is? Isn't the driver accepting
rules it can't correctly offload?
