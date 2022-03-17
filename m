Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B214DC891
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiCQOS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiCQOS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:18:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC3BA6E1D;
        Thu, 17 Mar 2022 07:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A13DDB81E54;
        Thu, 17 Mar 2022 14:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D83C340E9;
        Thu, 17 Mar 2022 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647526629;
        bh=4yTtPxDsez82JJrZymLem6q7cLgKEHs+DjNsrwNpr7g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KSBKjh4bc42EwYX8CQMC3a8puVBTt5rQCMd8+xoPtDceLi0VWXlpX5tsYGzhARJNg
         a3ulk1xTqpJPe3/9+naGcmuPFCMjQ5feYh/MKClGeaYD1sNjmr+eC1a0HchYBpe4RX
         I+pVH93dRSg6/GbGCGjR4KzxdvBh/p1pFRnhn+OWQXRMwhYDdrCrRPI1vW4hXntiCU
         +2zgMKzuXAdTVCMF5Ze+OD2DZTIhXfv0GbF+1nEiOcLMTOiR0ZU1xeIZNkLqB7s5lu
         Au8rvSTFlRoHhawag+J8JVdYCDfLMEoP08xbVO0dGgqHuiKhf6ZFN1Y3YjHbjlGnvN
         XMDMjdjWiJn7A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: p2p: Fix spelling mistake "Comback" ->
 "Comeback"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220316233938.55135-1-colin.i.king@gmail.com>
References: <20220316233938.55135-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164752662488.16149.346921748924515883.kvalo@kernel.org>
Date:   Thu, 17 Mar 2022 14:17:06 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> There are some spelling mistakes in comments and brcmf_dbg messages.
> Fix these.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Patch applied to wireless-next.git, thanks.

7f5f00cdf795 brcmfmac: p2p: Fix spelling mistake "Comback" -> "Comeback"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220316233938.55135-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

