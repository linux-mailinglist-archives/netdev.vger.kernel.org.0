Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7962BA20A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgKTFu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:50:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgKTFu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 00:50:58 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 462A422244;
        Fri, 20 Nov 2020 05:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605851457;
        bh=Zhk9rnP8ITs0gdeg2nubKkwfzZIdwWH5N20bebn+B0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uquP7V/lj09Ygg67TGeDcK7BTZaYMYuBc634P3NV+u67qbt1VQCFbaHol/dbzzhpZ
         6/+L6mXd3Khpz7qVxnY0VaKyEBWjf8uhs3oW3d/UakgCS8i7WjWO5oVt7UFX3nOE6m
         qwuLHyf/vdKp3zcIyKB0t/MFf2CnhtzltWZdCP0g=
Date:   Thu, 19 Nov 2020 21:50:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] bnxt_en: fix error return code in bnxt_init_one()
Message-ID: <20201119215056.0b43a8f7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAKOOJTy8AnrX9N51G1C73+G-7pLaip_Vt1FBk44RRQzDec9Y7w@mail.gmail.com>
References: <1605701851-20270-1-git-send-email-zhangchangzhong@huawei.com>
        <CAKOOJTy8AnrX9N51G1C73+G-7pLaip_Vt1FBk44RRQzDec9Y7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 10:53:47 -0800 Edwin Peer wrote:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Fixes: c213eae8d3cd ("bnxt_en: Improve VF/PF link change logic.")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>

Applied, thanks!
