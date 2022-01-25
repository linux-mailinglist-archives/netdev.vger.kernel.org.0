Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D57949B801
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582634AbiAYPwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582592AbiAYPuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 10:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16C9C06175C;
        Tue, 25 Jan 2022 07:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9345C61709;
        Tue, 25 Jan 2022 15:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89D0C340E0;
        Tue, 25 Jan 2022 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643125815;
        bh=Mi5eVYM6QJCHabfvmRhwsZzeukWWaZZdSnpEj1Kq9go=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gAzWjAGNNWq5M1HDijXlRV1Qm54BKJNF0JBd+33oKVFdZariM2Lfo0AU+od2dhqnD
         07Mr/5o9mfrxEa2jWYedwqw2zO8KsgfPwylN+oXciSfgR4QM+qOe/MyGhpj2mJzd3w
         jrDfGXrEouH6ReLLBqJ38+Zhd73K9zlBLPRpzPR8SiFWdSZX3rSGTvSKbDsOk7+X/I
         Dq1Jkr+iVHRZ9kjFeGJWeeOJFCuZwM3fyG4cFmyhJBvi9FGhsmlwtOw01jhoFjTEVW
         5LMU6t2aorVHunhvkF77kGyv/GJSRyY2KRxGjTIL5Rlzgg/k4j7fDX0mYTBig0vlEy
         6A8M9tPgSAIQQ==
Date:   Tue, 25 Jan 2022 07:50:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [PATCH net] net: hns3: handle empty unknown interrupt for VF
Message-ID: <20220125075013.6d5a9d0a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125070312.53945-1-huangguangbin2@huawei.com>
References: <20220125070312.53945-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 15:03:12 +0800 Guangbin Huang wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> Since some interrupt states may be cleared by hardware, the driver
> may receive an empty interrupt. Currently, the VF driver directly
> disables the vector0 interrupt in this case. As a result, the VF
> is unavailable. Therefore, the vector0 interrupt should be enabled
> in this case.
> 
> Fixes: b90fcc5bd904 ("net: hns3: add reset handling for VF when doing Core/Global/IMP reset")
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

Applied, thanks:

2f61353cd2f7 ("net: hns3: handle empty unknown interrupt for VF")
