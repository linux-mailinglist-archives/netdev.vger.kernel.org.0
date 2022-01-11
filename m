Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9148AF84
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 15:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbiAKO1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 09:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239980AbiAKO1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 09:27:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBCCC06173F;
        Tue, 11 Jan 2022 06:27:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC5A261683;
        Tue, 11 Jan 2022 14:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDE7C36AEB;
        Tue, 11 Jan 2022 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641911271;
        bh=q7UrMOAq8uxK4pV4AeXczZ5Zom8qNHsblmQ/HEPUX/g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=n3OjADGKqB7/yC+wlxG7zH38DNNCQcblNg847B5JPFHcKHBedmoVjuZAmd9Mnu3HH
         iXFd5+3QjSzcOZn1261lbuyuRDAxgxolfJj1ZOPC3nH4yHDGXgMB0NWhSPzlPf1DQ2
         aInu9rqgcz+wR/NU9bIn1/8PZnakU1iNSErYgZOkMJcCmaScAs2c5YFyGEpQXPW9jO
         c+0wKjGiKrKoTCApFoSvB9MXGnngpzwO5bmCEmOTzyjNYbyaFuQ2+Nmqe9Ha7lqSsd
         D+jTv0aqj47sNMhMtkmNJOjIcNEjUOpwNX/Tf6g6gURE1rmnHeJUCNi7GvCn6YBS8H
         GcQJ3bYQhBpdg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] ath11k: add missing of_node_put() to avoid leak
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211221114003.335557-1-yangyingliang@huawei.com>
References: <20211221114003.335557-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath11k@lists.infradead.org>,
        <akolli@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164191126809.24158.10097553913442842194.kvalo@kernel.org>
Date:   Tue, 11 Jan 2022 14:27:49 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> wrote:

> The node pointer is returned by of_find_node_by_type()
> or of_parse_phandle() with refcount incremented. Calling
> of_node_put() to aovid the refcount leak.
> 
> Fixes: 6ac04bdc5edb ("ath11k: Use reserved host DDR addresses from DT for PCI devices")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

3d38faef0de1 ath11k: add missing of_node_put() to avoid leak

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211221114003.335557-1-yangyingliang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

