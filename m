Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABD112BEB9
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 20:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfL1Tek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 14:34:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59616 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfL1Tek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 14:34:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9C5815460C1A;
        Sat, 28 Dec 2019 11:34:39 -0800 (PST)
Date:   Sat, 28 Dec 2019 11:34:37 -0800 (PST)
Message-Id: <20191228.113437.849229183154552588.davem@davemloft.net>
To:     chenzhou10@huawei.com
Cc:     qiang.zhao@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] net/wan/fsl_ucc_hdlc: remove set but not used
 variables 'ut_info' and 'ret'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191228030947.92765-1-chenzhou10@huawei.com>
References: <20191228030947.92765-1-chenzhou10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 28 Dec 2019 11:34:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>
Date: Sat, 28 Dec 2019 11:09:47 +0800

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wan/fsl_ucc_hdlc.c: In function ucc_hdlc_irq_handler:
> drivers/net/wan/fsl_ucc_hdlc.c:643:23:
> 	warning: variable ut_info set but not used [-Wunused-but-set-variable]
> drivers/net/wan/fsl_ucc_hdlc.c: In function uhdlc_suspend:
> drivers/net/wan/fsl_ucc_hdlc.c:880:23:
> 	warning: variable ut_info set but not used [-Wunused-but-set-variable]
> drivers/net/wan/fsl_ucc_hdlc.c: In function uhdlc_resume:
> drivers/net/wan/fsl_ucc_hdlc.c:925:6:
> 	warning: variable ret set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

Applied.
