Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920226E1EE3
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjDNJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjDNJAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFD81984;
        Fri, 14 Apr 2023 02:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B14A564588;
        Fri, 14 Apr 2023 09:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF98C433D2;
        Fri, 14 Apr 2023 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681462816;
        bh=aoxWGHrcGXzl95z4ShKtPhiVP7+3dPvIbweWbVxK13s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mEon8G/JNG5Ngizj3r9+e0Let/FkPDq4NtYXeDZe4AeX4ds+5oBMBRCOx6kvRgvWC
         OFy9z7UjI64Gk2miiUbA0r/a06WfoUPJXtEIM0mY5Cjo992A7kSHMUL766w6EATw8O
         zajJ8fRHWDGD8AfUi4sHaAWympn+kuvQzm9MKYCjGUWDTWXULgYGYmawQv8Wow48gJ
         N9WnpIEIjghn6ryhdzEly1oakSy6zbqzh5xt+UQmDcPUDP70YwoQK+FVkS8X6Q/k5A
         IxkVtRZ1K46FOLGFCHKEqF6FyApHyZxG85alimj3v8yqkUAVDYv7JKvqr6LaT5mlbT
         DkMuXelNmviZQ==
Date:   Fri, 14 Apr 2023 12:00:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yixin Shen <bobankhshen@gmail.com>
Cc:     akpm@linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        ncardwell@google.com, netdev@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH net-next] lib/win_minmax: export symbol of
 minmax_running_min
Message-ID: <20230414090011.GA17993@unreal>
References: <20230413171918.GX17993@unreal>
 <20230414022736.63374-1-bobankhshen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414022736.63374-1-bobankhshen@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 02:27:36AM +0000, Yixin Shen wrote:
> > Please provide in-tree kernel user for that EXPORT_SYMBOL.
> 
> It is hard to provide such an in-tree kernel user. 

So once you overcome it, feel free to send this EXPORT_SYMBOL patch
together with in-tree kernel user, but for now it is against kernel
policy.

Thanks
