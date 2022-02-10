Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FC04B08C4
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237900AbiBJIrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:47:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbiBJIrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:47:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2811E7;
        Thu, 10 Feb 2022 00:47:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ADE860EFB;
        Thu, 10 Feb 2022 08:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0412C340ED;
        Thu, 10 Feb 2022 08:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644482827;
        bh=38hpu9snVYLkh52SddNroOa3n7Mojq75rM3tru+Si1M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ptm/3qISA+Z/QNILqwZUknrnwihP60fcjaBWDXHpEyMclieqiWh+33qXp7JGdENi8
         RNam1xnsOb+80zCyoCoI/hw6WXdeMbLWs8TFqCRg/t6b/fooMMx86VHFLa7HDC4fwE
         l1LRnJRWR1bdZw+q4/3Kg6zuEey0r/plSbgdmAk4/O87MGhljeqaTLm+R1LQNx/puq
         Rau74jEJzeSFVmTo/dN3KX2FUwoB6rMMqXWnQJCcf3XIxJ+3hish8GQxCZdpF3rHie
         Di8mvsjGS7piZhL7/uCcu2vkP8wu6hNlZh7xybMgNxQ5T648kIyAikxt8qnU+2jI6+
         ViGrjjEUfHmdA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] brcmfmac: of: remove redundant variable len
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220207133329.336664-1-colin.i.king@gmail.com>
References: <20220207133329.336664-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164448282223.15541.14523972377351410590.kvalo@kernel.org>
Date:   Thu, 10 Feb 2022 08:47:03 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> The variable len is being assigned bit is never used. The variable
> and the strlen call are redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Patch applied to wireless-next.git, thanks.

2fd6d2ef6860 brcmfmac: of: remove redundant variable len

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220207133329.336664-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

