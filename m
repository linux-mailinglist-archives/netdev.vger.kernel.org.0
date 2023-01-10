Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAA3663ECE
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjAJLBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238367AbjAJK7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:59:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0841105
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:56:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4A70B80FEF
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 10:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74214C433D2;
        Tue, 10 Jan 2023 10:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673348206;
        bh=y7IkjovMikYy6QnCCUcTXYeaVgnPCl7i3o0rQJWIdkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dg3Sygdoqv0jnowzomfmr7eiKFvMmQejFVrhbpp+oVB7zsZIsR4zXWGO16OsckTXL
         cSG685T2awn2E6/R9X87HwfZ+D6KMcICMum95YBWNo7tyjSkFBUf1VJ/5u3s76y30n
         Pd05vvMVmXd6zuUHca3TidihQZwvUGN/6cqQV8YZL2/2S8G7UC+MtxxF2FcPBVQasL
         9p+ZRyf8uC8YAGXcfpo63xvKVk7yyy/+MhTOxDtP27Yq5Nx5LLTEThD6hbGMlp4cuI
         29v5WNND1lCTRibHSrB3Z2M0RuP3vY1bFOAgghsMrO9s+C+5bZjeD4ohGgr1cIwxcW
         rm01BKbdUeLkw==
Date:   Tue, 10 Jan 2023 12:56:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/2] ice: Add check for kzalloc
Message-ID: <Y71EaQkwvw2OMVHC@unreal>
References: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
 <20230109225358.3478060-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109225358.3478060-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 02:53:58PM -0800, Tony Nguyen wrote:
> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> Add the check for the return value of kzalloc in order to avoid
> NULL pointer dereference.
> Moreover, use the goto-label to share the clean code.
> 
> Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_gnss.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
