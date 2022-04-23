Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6880550CA0A
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 14:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbiDWMt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 08:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiDWMtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 08:49:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECA5114F;
        Sat, 23 Apr 2022 05:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA30610A5;
        Sat, 23 Apr 2022 12:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD2AC385A5;
        Sat, 23 Apr 2022 12:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650717985;
        bh=Uvl6zhZc/mlmKjzrsz1ZwJVfGfONfLa+j/xeTUPpcWw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EXG7R3RlOPZs0rgEu8pLeYglJcWYT2sTVSY7uqJEqUw1h4wzr+VPZgXRNj9+ygiuy
         LXyN+nXkGKE5B8cCDBpMv5uGLAjlobF1AQW+n+oxk+WgGC3jmg4Meynw7j0yT45zOJ
         aErA3hgGkm3bDOD8bXynceNRi0ccr8QZ+birRwZudpaUX+EyTaOi76zH3/lDKpXYB7
         5cPCSrTsrRgz4HHaaUIaym5/kKXvbah+BAWLNL81rUlZdxBuZ1+ceD1QYABpLfyWVp
         9lSKsmEf5jnA1OYQFCm1Msx6+0Ew+57UM80vSTak4mC5Kb3KyDOf20/cMX7M39ZsvL
         N7TiUs5UcW03Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wl12xx: scan: use pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220420090247.2588680-1-chi.minghao@zte.com.cn>
References: <20220420090247.2588680-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165071798166.1434.12954171686384361276.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 12:46:23 +0000 (UTC)
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

c94e36908467 wl12xx: scan: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220420090247.2588680-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

