Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E13525B92
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 08:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377237AbiEMGUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 02:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377208AbiEMGU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 02:20:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAAB284912;
        Thu, 12 May 2022 23:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79056B82C40;
        Fri, 13 May 2022 06:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95A3C34100;
        Fri, 13 May 2022 06:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652422824;
        bh=aHkk3J36Z8kJ+ZUFvfd3KyBC3/yaAGpykvfzHN6wCKc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aqKE+MHQ+fSAyMhnhSC+cX4cD/jnkTNa0vAXgm7tBAEtkZW+G/DrvhyDVU0PQUBme
         EJz2oI5oFwO0z78KktKpH1sCnc2+CLbhM5LsiWtGGTlJe/hA8VgDMity1mReG4667D
         bbXq2OH5QHBf2dYyJP7odXgWoXeUFbml72wE6GK1YQGne4abJIqBgtqPAy1aWmfe4I
         zqdWtqmEE/PkxZ9vYupmQ6ayR1dRll/5y78BrhlKb0SiE7Fb7gBC9JYt/ggDPEPIeo
         wk5QfySK/2yhiE75xLnDsZ04x23GeAwqPIsKcx0MS82kLYry9DNBwMInaTtc/me/fl
         tponHj0EHzETA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] rtlwifi: Use pr_warn instead of WARN_ONCE
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220511014453.1621366-1-dzm91@hust.edu.cn>
References: <20220511014453.1621366-1-dzm91@hust.edu.cn>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165242279758.13495.9636671855029489659.kvalo@kernel.org>
Date:   Fri, 13 May 2022 06:20:21 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dongliang Mu <dzm91@hust.edu.cn> wrote:

> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> This memory allocation failure can be triggered by fault injection or
> high pressure testing, resulting a WARN.
> 
> Fix this by replacing WARN with pr_warn.
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>

Patch applied to wireless-next.git, thanks.

ad732da434a2 rtlwifi: Use pr_warn instead of WARN_ONCE

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220511014453.1621366-1-dzm91@hust.edu.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

