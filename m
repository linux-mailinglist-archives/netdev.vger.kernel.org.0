Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C636EB741
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 06:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDVEEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 00:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDVEEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 00:04:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF301FC3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 21:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B37136069A
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 04:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D63C433D2;
        Sat, 22 Apr 2023 04:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682136258;
        bh=SWTf6Y1MWhxOK+F7ei2/PZ9S9+GhwgmkHx78iX6+mhM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lgao70mMsApbqJd0InbmxuTNSF0QvwonMqxRjAGsTngoeB1JrPWQ8Tc0pkI2KVC9t
         7FXaLa8pyEjLCxHPozC24oLl/9p829SNxj091l5voCqcP6fwsoXMJbRtqbjCP11wpU
         v9HpaDNZoOgh/mqT3GYOcnGdOHQRKWrOZujdfVWTMm+o7icuaXSqxSx4/zxEIXvAaR
         wMiNM+YR2MDDlQiaQQQ4zKaBQb2dyOzQFv/9FIgrWk08t8olvrMlxLsBoOMeKVJnvf
         A+kmFlg1U3FKTQusa1ICTX/pjtUI9NHijuMeovklJxJRUy9qMHSwsm07Xtx5XGa0fM
         NrSD3L/we9h3A==
Date:   Fri, 21 Apr 2023 21:04:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH net-next 2/4] sfc: populate enc_ip_tos matches in MAE
 outer rules
Message-ID: <20230421210416.5a80e25f@kernel.org>
In-Reply-To: <d1fd9a055378a5e0f969d0ecb69ca2a4cd8257bb.1682086533.git.ecree.xilinx@gmail.com>
References: <cover.1682086533.git.ecree.xilinx@gmail.com>
        <d1fd9a055378a5e0f969d0ecb69ca2a4cd8257bb.1682086533.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 15:19:52 +0100 edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Currently tc.c will block them before they get here, but following
>  patch will change that.
> Use the extack message from efx_mae_check_encap_match_caps() instead
>  of writing a new one, since there's now more being fed in than just
>  an IP version.

Transient build breakage here

-- 
pw-bot: cr
