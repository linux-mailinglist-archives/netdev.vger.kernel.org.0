Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92B965D1C0
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 12:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239091AbjADLsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 06:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjADLsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 06:48:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7BB1EAFD;
        Wed,  4 Jan 2023 03:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94024613EA;
        Wed,  4 Jan 2023 11:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7DAC433D2;
        Wed,  4 Jan 2023 11:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672832880;
        bh=tVKRtnWaZZzqrPq8yrMjFtLHPJFEtdjwVzN5HPz6PNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZtdG5nNtzC4Qg4uKG4pKE1cjLnujfr11dKH4dcnGqbvdi4a63JcgSsCpcIolbLqvp
         nuE/yaN6zxt8gd27w1S0kdPYXv5sPHMMPawNOCuuIac4nGCNYSOfExWstXfTSfON2y
         z69JsG2uLaKs2Pz/gbf0p0dzPeFbrO90QW/7BwXgomngxCkpqb8sr77kriK0NYuhrz
         Bmcpe0tIa5KphOKZV3S/EC/TpQ7joEw0wte8zpgcRZ31HJGk3Tyfk++daz3FuPNHdI
         DlXszGvUQ/aoOxmjdxUe5qAcqVZqYLdze4wmMs8+P9bn7HcGT+c78ubPaOj+qAistf
         ksln38PZ5v5nQ==
Date:   Wed, 4 Jan 2023 13:47:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        luciano.coelho@intel.com, johannes.berg@intel.com,
        shaul.triebitz@intel.com, linux-wireless@vger.kernel.or,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: Add missing check for alloc_ordered_workqueue
Message-ID: <Y7Vna3q8DxXSgpBp@unreal>
References: <20230104100059.24987-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104100059.24987-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 06:00:59PM +0800, Jiasheng Jiang wrote:
> Add check for the return value of alloc_ordered_workqueue since it may
> return NULL pointer.
> 
> Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
