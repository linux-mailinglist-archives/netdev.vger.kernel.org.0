Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3102D3685
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbgLHWyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbgLHWyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:54:33 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A3BC0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 14:53:53 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 887EF4D248DB8;
        Tue,  8 Dec 2020 14:53:50 -0800 (PST)
Date:   Tue, 08 Dec 2020 14:53:45 -0800 (PST)
Message-Id: <20201208.145345.1775872188097880675.davem@davemloft.net>
To:     qiangqing.zhang@nxp.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V3 0/5] patches for stmmac
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
References: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 14:53:50 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>
Date: Mon,  7 Dec 2020 18:51:36 +0800

> A patch set for stmmac, fix some driver issues.
> 
> ChangeLogs:
> V1->V2:
> 	* add Fixes tag.
> 	* add patch 5/5 into this patch set.
> 
> V2->V3:
> 	* rebase to latest net tree where fixes go.

Series applied, thank you.
