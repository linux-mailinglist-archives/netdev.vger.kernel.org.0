Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDBA4FE29F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353485AbiDLNY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356084AbiDLNWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:22:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F70E64;
        Tue, 12 Apr 2022 06:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B897619AF;
        Tue, 12 Apr 2022 13:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22688C385A5;
        Tue, 12 Apr 2022 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769197;
        bh=DTegz9gyhgjc2JJ5pN4gPvlldPShZLOKKU3Jkl7X8DE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KDCeaD5cjOXtHGc+8cgkGUcV0+tPV2l2i3N5hS+SAd9tIXewUSj0SUZ6DUyipQzEs
         nvQpH3bkHPcbtJfMB1XQLI9MtoC0qgc+8l/KAP9HgccsqOPCWAuYkXRkfWjmQUbb3v
         DwutaswFV9nVp4ese307KjmO68Npubljca9IDGsn38SGgXLwp4S442kKADQINcPAB4
         bEhlfei93EJoJmfdM8I/a15BlccAEGyQ2lQ4V3q69t9p2Wol94jZeur5RILwBh32ua
         6AtKqbDdtmnbAuQpOsq+PPLtgvY7C2evq43ccDugZhH1Qb6TiWfr5Wgc43BID/7cPk
         k+RRrXCEIUEAg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next 1/2] wcn36xx: clean up some inconsistent indenting
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220408000113.129906-1-yang.lee@linux.alibaba.com>
References: <20220408000113.129906-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        loic.poulain@linaro.org, toke@toke.dk, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164976919327.15500.7970749626802998679.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:13:14 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> Eliminate the follow smatch warning:
> drivers/net/wireless/ath/wcn36xx/smd.c:3151
> wcn36xx_smd_gtk_offload_get_info_rsp() warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Acked-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

2578171ff85e wcn36xx: clean up some inconsistent indenting

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220408000113.129906-1-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

