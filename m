Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDD727356
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfEWAeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:34:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWAeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:34:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3ED0B1504289D;
        Wed, 22 May 2019 17:34:36 -0700 (PDT)
Date:   Wed, 22 May 2019 17:34:33 -0700 (PDT)
Message-Id: <20190522.173433.211776873726810866.davem@davemloft.net>
To:     baruch@tkos.co.il
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, abel.vesa@nxp.com, peng.fan@nxp.com
Subject: Re: [PATCH] net: fec: remove redundant ipg clock disable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b88a935c6e3f845b8eac78c32e2f15743014e418.1558533375.git.baruch@tkos.co.il>
References: <b88a935c6e3f845b8eac78c32e2f15743014e418.1558533375.git.baruch@tkos.co.il>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:34:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>
Date: Wed, 22 May 2019 16:56:15 +0300

> Don't disable the ipg clock in the regulator error path. The clock is
> disable unconditionally two lines below the failed_regulator label.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Applied to net-next.
