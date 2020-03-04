Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8EAA1787BF
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbgCDBwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:52:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgCDBwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:52:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0F4115AD971B;
        Tue,  3 Mar 2020 17:52:52 -0800 (PST)
Date:   Tue, 03 Mar 2020 17:52:52 -0800 (PST)
Message-Id: <20200303.175252.808306006931675226.davem@davemloft.net>
To:     bjorn.andersson@linaro.org
Cc:     kuba@kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 0/2] net: qrtr: Nameserver fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200302070305.612067-1-bjorn.andersson@linaro.org>
References: <20200302070305.612067-1-bjorn.andersson@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 17:52:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Sun,  1 Mar 2020 23:03:03 -0800

> The need to respond to the HELLO message from the firmware was lost in the
> translation from the user space implementation of the nameserver. Fixing this
> also means we can remove the FIXME related to launching the ns.

Series applied to net-next, thanks.
