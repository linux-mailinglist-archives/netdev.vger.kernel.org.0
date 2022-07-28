Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B98583B96
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiG1J5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiG1J5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:57:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A536390D;
        Thu, 28 Jul 2022 02:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09D04B82393;
        Thu, 28 Jul 2022 09:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE1FC433C1;
        Thu, 28 Jul 2022 09:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659002258;
        bh=pzgNl7GHZa2hl9UPO39duiMSklaGM6oa/uofX+is3PE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tQFi3+7aGm02mP0NWlBfgPD8D2Cl5Cicsw0GLPtCFCJ8vY5s9Vu+4Kr3m4JlEGLG6
         3OQZLDfSRp+caucGWLumOJuqcP1VSyeXJRoktA0qWfUaxeuHp1/94fG+IvC3LtHpYg
         TPtfegQ4jaDBv8LWkrhSzyr2+Mj9d2hdPvPNqDLi5u24uDacXikafuiAZesHgT3ZZs
         pPOr5ZhzxkSOFMgBq7xmJh+1qJnlhPDuBCi2NITUTSbhioFlzCPLZsQVmC9EWvecuE
         7gmeYprDyknjAglV9vSu8Tq+BTVCTpEDdWpCv07O+kOGutZoiVUDmP7Fk7gA3K6+Yk
         W+VysNOjb9mbg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v3] wifi: brcmfmac: Remove #ifdef guards for PM related
 functions
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220627193701.31074-1-paul@crapouillou.net>
References: <20220627193701.31074-1-paul@crapouillou.net>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165900225429.25113.8345553765798520539.kvalo@kernel.org>
Date:   Thu, 28 Jul 2022 09:57:36 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Cercueil <paul@crapouillou.net> wrote:

> Use the new DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr() macros to
> handle the .suspend/.resume callbacks.
> 
> These macros allow the suspend and resume functions to be automatically
> dropped by the compiler when CONFIG_SUSPEND is disabled, without having
> to use #ifdef guards.
> 
> Some other functions not directly called by the .suspend/.resume
> callbacks, but still related to PM were also taken outside #ifdef
> guards.
> 
> The advantage is then that these functions are now always compiled
> independently of any Kconfig option, and thanks to that bugs and
> regressions are easier to catch.
> 
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Patch applied to wireless-next.git, thanks.

02a186f1e96b wifi: brcmfmac: Remove #ifdef guards for PM related functions

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220627193701.31074-1-paul@crapouillou.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

