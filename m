Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E81D3822A8
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 04:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhEQCTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 22:19:06 -0400
Received: from mx.socionext.com ([202.248.49.38]:8370 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhEQCTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 22:19:05 -0400
Received: from unknown (HELO kinkan2-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 17 May 2021 11:17:49 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by kinkan2-ex.css.socionext.com (Postfix) with ESMTP id 87E402059027;
        Mon, 17 May 2021 11:17:49 +0900 (JST)
Received: from 172.31.9.53 (172.31.9.53) by m-FILTER with ESMTP; Mon, 17 May 2021 11:17:49 +0900
Received: from yuzu2.css.socionext.com (yuzu2 [172.31.9.57])
        by iyokan2.css.socionext.com (Postfix) with ESMTP id 330F0B1D40;
        Mon, 17 May 2021 11:17:49 +0900 (JST)
Received: from [10.212.23.88] (unknown [10.212.23.88])
        by yuzu2.css.socionext.com (Postfix) with ESMTP id E39B3106B24;
        Mon, 17 May 2021 11:17:48 +0900 (JST)
Subject: Re: [PATCH 20/34] net: socionext: Demote non-compliant kernel-doc
 headers
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
 <1621076039-53986-21-git-send-email-shenyang39@huawei.com>
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Message-ID: <0927db5b-12f4-6374-f869-84685906df31@socionext.com>
Date:   Mon, 17 May 2021 11:17:48 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1621076039-53986-21-git-send-email-shenyang39@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yang,

On 2021/05/15 19:53, Yang Shen wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/net/ethernet/socionext/sni_ave.c:28: warning: expecting prototype for sni_ave.c(). Prototype was for AVE_IDR() instead
> 
> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>

I confirmed the fix of the warning.

Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

Thank you,

---
Best Regards
Kunihiko Hayashi
