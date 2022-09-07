Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC7C5AFE43
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiIGH7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiIGH7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:59:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39B125FE;
        Wed,  7 Sep 2022 00:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8757615E3;
        Wed,  7 Sep 2022 07:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E35C433D6;
        Wed,  7 Sep 2022 07:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662537566;
        bh=D1dAw+aNRWaAnlIYe9fxn7j36jFtAkbZ16B8SP8wQ/4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ayihZRm7a9rN/Coa8nH3F9D1cBh0glDsrnfJfsqMqP9b7wo80+IvnViDQJxCrPW38
         p80xc9P47Gz7TMBJO6A7v5PDrrI4eDDpZQRCuDzg6InxfrLeim5geWyKe+DF5PBKBK
         Bp+PBX9cHdgH7iF7RErntPueaRdFcE7qV+gq+oAqOKAiljiD1uPxlXZ4uvP9uhPU8k
         mYZdoMlCg/MKCdUMglbJX2bSL92DzprMilD3t1MvK73OBpMaEEfe6Bdi8TRpOzkozM
         Pwqjo/Slg3NwdlIEQJ2Ri/gMS0x3J4LihBrrgPlZEe2GsDW/tWz9C5RLacLOWS6UzA
         2bZWVb40Ce6rA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: mwifiex: Fix comment typo
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220811120201.10824-1-wangborong@cdjrlc.com>
References: <20220811120201.10824-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     ganapathi017@gmail.com, amitkarwar@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253756181.23292.9598319261128136862.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 07:59:23 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Wang <wangborong@cdjrlc.com> wrote:

> The double `the' is duplicated in the comment, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

ed03a2af74d2 wifi: mwifiex: Fix comment typo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220811120201.10824-1-wangborong@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

