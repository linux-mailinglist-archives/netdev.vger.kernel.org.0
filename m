Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FE850C7F9
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 09:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiDWHPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 03:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiDWHPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 03:15:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B3CE77;
        Sat, 23 Apr 2022 00:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBF5D60B69;
        Sat, 23 Apr 2022 07:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739B6C385A0;
        Sat, 23 Apr 2022 07:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650697942;
        bh=Yzx0HIL7wHsmpJBZHkFDz/t3a+v8q6IOVcW1gs1/Kb8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=C1VJcJZuiENjFTFvwfiqTX98uLVIgnofb5JHNQ/L8+ykgp4BRxUrByyhiYYs+v8Fu
         ipzn3PFhQDt9mrrO/CpJLtQa2JOgHLYW2/UN2YGaSVCXthNJJ5gqQ3XBfzNPQnEy+A
         gWGfJLrXF/pQbwMza3B5Ju3idqOTWTN+xRHYUc3HUcp8ieAHwX3q8gXvv1rJmMSNr6
         yZWEZ31Rtf3+O+GAUIxfbpDW/b4jug/E04XXg2vbtmzs0YnMoC/ztWSSVszvoajUNR
         i7ozumAFEDLzHCXNiz2yWIXzQWpV4+guPtkYF5O1vJce5V3RAJYOv9rlBTIVlqeUaC
         WQ4m6eyOT6vnQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wlcore: sdio: using pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220419110445.2574424-1-chi.minghao@zte.com.cn>
References: <20220419110445.2574424-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165069793855.11296.1369751106102574287.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 07:12:20 +0000 (UTC)
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
> Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
> pm_runtime_put_noidle. This change is just to simplify the code, no
> actual functional changes.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Patch applied to wireless-next.git, thanks.

00bfc8964f43 wlcore: sdio: using pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220419110445.2574424-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

