Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA6F50C7F6
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 09:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiDWHPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 03:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiDWHPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 03:15:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E50E77;
        Sat, 23 Apr 2022 00:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 885BFB802C6;
        Sat, 23 Apr 2022 07:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FB7C385A5;
        Sat, 23 Apr 2022 07:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650697960;
        bh=J5jMXGylimVpTn2SlCRUPm/5z4Abv22keiWd1plZlTs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LucOI3IIkNaKx74mZPKIZZlAJt1L7zmuv1EpjK/pVLK8EXXQQXUqivdhp67PHIK1c
         WuR1fRX+jE/HxApQo0XubcHW7hHipFTyIgVoknqgK+7G201/vctxIB/P7A6HkXXlmY
         GAEMjXS8IYq+MWqjoV+uYbqbL3aHJljfRepeqXtTlXF2omMp/tmGdAGm9fDqmPRk9o
         xKlbxM1h99kx8iHfr935D6S1U0QB/LH+bRdFMNyW5bNZxBFawr8Sn2wTKVnNQi1BIL
         wiCHpqS6BgULRi445btIU6EMbY3czMqi+WVNN11Fu9W7Ut0EsQY8Q4XagQqsZ6+ZpP
         +unHM5zK3p03Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wlcore: cmd: using pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220420090141.2588553-1-chi.minghao@zte.com.cn>
References: <20220420090141.2588553-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165069795660.11296.2623975498511981713.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 07:12:38 +0000 (UTC)
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

e05c7ddfeb23 wlcore: cmd: using pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220420090141.2588553-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

