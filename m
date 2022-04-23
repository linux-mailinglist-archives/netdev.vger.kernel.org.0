Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091E950C7EE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 09:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiDWHOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 03:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiDWHOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 03:14:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A68B5E;
        Sat, 23 Apr 2022 00:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C17E8B80022;
        Sat, 23 Apr 2022 07:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED7FC385A5;
        Sat, 23 Apr 2022 07:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650697904;
        bh=54N2y6k5E9toeQNKry6B5Iwwayov2BxK7D3aXm5bbQU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Br8SGKDcW1H7h5lQKauNpfzbm6kskdo2xyY670ndgkt1WicxmA8SU1OAXGaDyNiGx
         trA57x7prYZIaIKQpduj/0EXgHuHZ8Ow75aXd2jAw9BJ6eP6eYayAaMrmiDGZbaOQT
         IuaRm3p0M6FtSyYsoHAkB4KNrod4bYjmjzJfL6cInmdXk8bBV0ojKZsNDsYe3LosH0
         HrABjObZbf4PffSO4Cwycvzy46+ezMRw0xMhJ0XfxfqWCGOjb/elFkwkpE8Ah38fNF
         EnRc4Sq93x5zvz8e99LPdcaSVNDD7rgUylhydySD0u/9aI17fZFVaFnSOSnXj9x3GU
         fRkt4Z+SFjPOg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: testmode: use pm_runtime_resume_and_get() instead
 of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220413093502.2538316-1-chi.minghao@zte.com.cn>
References: <20220413093502.2538316-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165069790028.11296.14239261919383930715.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 07:11:42 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Patch applied to wireless-next.git, thanks.

3447eebe6084 wlcore: testmode: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220413093502.2538316-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

