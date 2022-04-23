Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201BA50C7EA
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 09:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiDWHOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 03:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiDWHOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 03:14:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3515E110;
        Sat, 23 Apr 2022 00:11:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3F22B80022;
        Sat, 23 Apr 2022 07:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9309C385A0;
        Sat, 23 Apr 2022 07:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650697886;
        bh=iNwP8qOtxDIsSz+nCz8pzGyQdnnohj5gTGhaN6qcpyE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bvUxZcy0NcuuXIDbMbpmn/ukf76n/QXt1lAaQP8hYfT9dy1J1Rkw6WFTzq660Z77Q
         n3zE7JKjev7cAr9aFiPdBAnRrmhVsAlt0s8sDy59JP/rT77+xshfXBhbZJawnpCbzz
         fXwob9XatUN1FcWIlatkqcPwUGqBKu9Qi3mpLTlmvW+1xyp6UEfr6nueri0maJorQd
         TupPLscKKtKnfyYvbjLVtTqoEgWCh4Fnb2XIdzZNItYV0HbLVfUlfOPJPSUBYQK56s
         ieHI5I5FM6Jv7HRjfs5nmWJk+eZn8wtV18PhkChAEDsH7GXWGe74M14l9RYbzQkp6V
         rEDzFVq5wqgVQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wlcore: sysfs: use pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220413093431.2538254-1-chi.minghao@zte.com.cn>
References: <20220413093431.2538254-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165069788270.11296.4920256235029537519.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 07:11:24 +0000 (UTC)
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

da8e909c99e4 wlcore: sysfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220413093431.2538254-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

