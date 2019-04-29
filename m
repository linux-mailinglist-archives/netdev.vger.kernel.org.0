Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C730CE587
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfD2Oz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:55:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48196 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbfD2Oz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:55:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5D3FF6090F; Mon, 29 Apr 2019 14:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549726;
        bh=QS3Z9hwLNrdVzBUp6XuItFZ4Ak5IeXrFgHwZxUTi/1I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VvFzsF5zk38NOG0T55BOWBsQGJ+D5b20UKMQITE/9VjdcPcGiJ48vzv++Oo/FTOWu
         1FHtjHWOFunAeuHtX/j7gpBSwnVaODegzD+uX8RxnzImzXJ7hsj6OtNhxcbDYZabfp
         IMxwAVFIPxzSN8GWTFPsMlvQyCO/5riSRZjMGLfs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19B55608BA;
        Mon, 29 Apr 2019 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549725;
        bh=QS3Z9hwLNrdVzBUp6XuItFZ4Ak5IeXrFgHwZxUTi/1I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eVRtDRCaZWCv/64j1qAuAUhJtCncEXX0o1xPMH6/a3CcQ7xnMquynYOx79K90fieW
         MNyXjSJHcBdvcNgqSMc4G5Xovz6LBdWZIY5uR2uYgGrn/ux7HukOwwxXvovDYY7EA+
         bz0cPwF2mJRVIHgE2e3/Bgh+yQsSEAy9aHt0gbrs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 19B55608BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: Remove some set but not used variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190417025745.24044-1-yuehaibing@huawei.com>
References: <20190417025745.24044-1-yuehaibing@huawei.com>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190429145526.5D3FF6090F@smtp.codeaurora.org>
Date:   Mon, 29 Apr 2019 14:55:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yue Haibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/ath9k/xmit.c: In function 'ath_tx_count_frames':
> drivers/net/wireless/ath/ath9k/xmit.c:413:25: warning: variable 'fi' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/xmit.c: In function 'ath_tx_complete_aggr':
> drivers/net/wireless/ath/ath9k/xmit.c:449:24: warning: variable 'hdr' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/xmit.c: In function 'ath_tx_start':
> drivers/net/wireless/ath/ath9k/xmit.c:2274:18: warning: variable 'avp' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/ath/ath9k/xmit.c:2269:24: warning: variable 'hdr' set but not used [-Wunused-but-set-variable]
> 
> These variables are not used any more
> and can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

05039f01e630 ath9k: Remove some set but not used variables

-- 
https://patchwork.kernel.org/patch/10904395/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

