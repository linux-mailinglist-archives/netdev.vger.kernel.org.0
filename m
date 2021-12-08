Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E4646DB53
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbhLHSnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:43:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhLHSnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:43:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3792BB8226D;
        Wed,  8 Dec 2021 18:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F1DC00446;
        Wed,  8 Dec 2021 18:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638988810;
        bh=pp476RR2y8u8AR8R07J+ux4+dlPhsvc8xNy2iYUGXYA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EPpygiqUf8PPCTl3XOYmKmx+hEMo9xDCFgSo3ZK7NprdWJ8zHdp3dvtyN0sLENQQJ
         WnEfuinYmG375jIMN5t+0BnnrLgXZ2GPfLnObtJUWWF4c4jrWi7x+UjVveO1/Q6pV0
         84Fctv5UBlv6uyizczvWw2Mhylm8rbU8CArUED6KE1QEfoawigI8x/6HCpgtqECZVT
         BXDI6QbJFaW5BIglBK83+NWTTFZDf4GSG76Goi1ZhUlGnH9u2uMhevzZ7dWLGizEyx
         z0IIVZxWkpJs/D0h1rI9ElT5PMaiuqi6Sfc3M94422YKu/HtFkAOZyengfr3D4jLkS
         1pZdVFekSbKWQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] libertas: Add missing __packed annotation with
 struct_group()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211201173234.578124-2-keescook@chromium.org>
References: <20211201173234.578124-2-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Carlos Cobo <luisca@cozybit.com>,
        linux-kernel@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163898880630.25635.7269879453453801744.kvalo@kernel.org>
Date:   Wed,  8 Dec 2021 18:40:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> Build testing of the newly added struct_group() usage missed smaller
> architecture width tests for changes to pahole output. Add the missed
> __packed annotation with struct_group() usage in a __packed struct.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/linux-mm/202111302102.apaePz2J-lkp@intel.com
> Fixes: 5fd32ae0433a ("libertas: Use struct_group() for memcpy() region")
> Signed-off-by: Kees Cook <keescook@chromium.org>

2 patches applied to wireless-drivers-next.git, thanks.

978090ae8856 libertas: Add missing __packed annotation with struct_group()
05db148ee9a7 libertas_tf: Add missing __packed annotations

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211201173234.578124-2-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

