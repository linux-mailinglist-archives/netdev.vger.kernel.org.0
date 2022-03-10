Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA9C4D4DAE
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiCJPyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiCJPx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:53:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C91C248D;
        Thu, 10 Mar 2022 07:52:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 964DAB8254A;
        Thu, 10 Mar 2022 15:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4896FC340E8;
        Thu, 10 Mar 2022 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646927570;
        bh=5BSwm39TVBk+/sZEf4qJ0qeckWgsRWt03o2mAj/NKBo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=iztUl96yqpYaN8ldIISRZ4beF2U7oSDfAk4g8B9u/CydhoPrjL4CtyqNp4A6DF9v4
         TLyHxDJID1gninumbb5OeoQXzsrtSHXrLCPKprwKYaIoVpC1goP0pZERFo9CgxkGl8
         l5+gAp++knf9OsUKoSBfvWaFbUgCF1m1fpfmiig8C0rufZTfRgmzjyoNcHzbKm60x5
         4rdZ6lbHlTqRBx5F6LDK9XzYSYnmMOAsl7aaxH4Mg90p/bJiEaWG/EnDhehg6melWp
         kjjxiKxqO8Eyowgc/fK3c994z+QIlZKAsM1wrPgSLuXIypBEjd42NGvh7Ps77n/Qcx
         1/SazEO7ufhwg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix error handling in ath10k_setup_msa_resources
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220308070238.19295-1-linmq006@gmail.com>
References: <20220308070238.19295-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linmq006@gmail.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164692756657.18489.311627042082408244.kvalo@kernel.org>
Date:   Thu, 10 Mar 2022 15:52:48 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miaoqian Lin <linmq006@gmail.com> wrote:

> The device_node pointer is returned by of_parse_phandle() with refcount
> incremented. We should use of_node_put() on it when done.
> 
> This function only calls of_node_put() in the regular path.
> And it will cause refcount leak in error path.
> 
> Fixes: 727fec790ead ("ath10k: Setup the msa resources before qmi init")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9747a78d5f75 ath10k: Fix error handling in ath10k_setup_msa_resources

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220308070238.19295-1-linmq006@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

