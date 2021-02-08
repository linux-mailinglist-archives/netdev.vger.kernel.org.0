Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A773141EF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhBHVfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236596AbhBHVfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:35:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2352964E66;
        Mon,  8 Feb 2021 21:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612820093;
        bh=AeZbDf2uAYLml2HHXggg0lpyaNJI2z/wjZNYf8VawBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UUTkFMRnR1yb0YNZ34yB2VKXJlL4y8DQ7GxCo1nve5424WXkTgYeNj9hzQSYJ8l7s
         eiUlWzUAuH8HmePVTImCnpTWQtuNuORNvAg3sacnQCUjRJ62nJeqcVNnR0tugCblx5
         F8VLT412saynUFyxRhRhxZ/c95QOUj7jUmITpXIME8zh0zxOZnEoMxVZGPVZXWxq3l
         S2V4XtLdhzobB2MT8ZF1yCnqWxE16y1+VYaz6Ry5YMi/E+0Zb/zJZVhYmE+g37bpKA
         rXgJbsOAg+WJ4lfN58qcM18mGcFsEadG2K8v9yUMEZ/qYppsaDYIrayt2ITPdHD4nN
         joFUNDmLQakeQ==
Date:   Mon, 8 Feb 2021 13:34:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 03/12] net: hns3: check cmdq message parameters
 sent from VF
Message-ID: <20210208133447.14e1118a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612784382-27262-4-git-send-email-tanhuazhong@huawei.com>
References: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
        <1612784382-27262-4-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 19:39:33 +0800 Huazhong Tan wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> The parameters sent from VF may be unreliable. If these
> parameters are used directly, memory overwriting may occur.
> Therefore, we need to check parameters before using.
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Are you sure this is not a fix which should target net and stable?

Other than that the patches look good to me.
