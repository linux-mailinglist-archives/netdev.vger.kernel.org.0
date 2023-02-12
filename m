Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D09369395B
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 19:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjBLSaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 13:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBLSaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 13:30:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64701EB78
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 10:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 128FAB80D3A
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 18:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06509C433D2;
        Sun, 12 Feb 2023 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676226613;
        bh=t2C+x3IuoxyaCcqhC5T4rzhRxx/Wwpocfx34uxvmDSs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fOj9eDeL1i/wXaVarVHNN6TSpr5TrSzp9vB+mZWbZEdZVE13S9vofOCPReDGVIegY
         pWhf9ytOG+cSVnJP+GsaeK0A8ZNimo6g4HINtPhNACveCWPRgXIw8A9XBOSBio/LbT
         OeO3C4voXpv2zoK0pGzh4QBJ8pFHXGVowfSsMp4Ja6QYG2F3UOIawfCj2t3/6notxE
         sPoza5irLuBaX49gS/l2ZxcuHesJzc9TTIQXeYnsCUkVRGUMK3fU+kru9nd/QXoVOn
         lEaxjwAqCkZOI0vqhMwThz7WBJuNLM3pgp3oQRi/5a2ThabSeMDWakmc5TWk8rF2Ig
         3CM2SQYQ7Te2A==
Date:   Sun, 12 Feb 2023 20:30:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>
Subject: Re: [PATCH net-next] nfp: ethtool: supplement nfp link modes
 supported
Message-ID: <Y+kwMecYgmFdtmMb@unreal>
References: <20230210095319.603867-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210095319.603867-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 10:53:19AM +0100, Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Add support for the following modes to the nfp driver:
> 
> 	NFP_MEDIA_10GBASE_LR
> 	NFP_MEDIA_25GBASE_LR
> 	NFP_MEDIA_25GBASE_ER
> 
> These modes are supported by the hardware and,
> support for them was recently added to firmware.

Is it backward compatible? Will it work if I run old FW?

Thanks
