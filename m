Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14704694DEC
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjBMR02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBMR01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:26:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A175E19688;
        Mon, 13 Feb 2023 09:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 530BEB81637;
        Mon, 13 Feb 2023 17:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8430C433B4;
        Mon, 13 Feb 2023 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676309158;
        bh=DHxm33OpmpOZeWHjtjQbXckyZTgIPj3vHeUqIStqU8k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pMn6odgFIlGV1xVk3g2Wxc3k9TOkWc3kZ1pD+5lwncB0o1XBnzaY8oa+ET61GF1e7
         gm0EtF5KBC+GZ1PBMGMMl4H5h3Olbrej1UPXg7CpW7gwY9BroaWuyzcN1PkKkbSyIY
         28U3FC+t7/NBJFVRXmM3Hns31/kRcDHMOMTox5akRPERqZ2fs09TBmL+Hr2ivfaHyY
         3lAsMDZ7TIFItjwa3shQot64yuQb3Xjk1Gx0kb5PXcRIMTEd9kc3s4D1vcVugsb5SW
         3OXX7YA/ABRiEYyJHJO1Nms9beFDGLR65qi+768BTFwIKFjKQNkcmt5IubY2BNdy3g
         05dWweKbs6jRQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: zd1211rw: remove redundant decls
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230204200902.1709343-1-trix@redhat.com>
References: <20230204200902.1709343-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     kune@deine-taler.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630915417.12830.2730153875610217688.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 17:25:55 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> building with W=2 has these errors
> redundant redeclaration of ‘zd_rf_generic_patch_6m’ [-Werror=redundant-decls]
> redundant redeclaration of ‘zd_rf_patch_6m_band_edge’ [-Werror=redundant-decls]
> 
> Remove the second decls.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

9d5dbfe0e170 wifi: zd1211rw: remove redundant decls

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230204200902.1709343-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

