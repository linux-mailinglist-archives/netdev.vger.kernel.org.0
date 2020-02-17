Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B5D16085E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgBQC4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:56:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQC4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:56:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6806153DF5F0;
        Sun, 16 Feb 2020 18:56:00 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:56:00 -0800 (PST)
Message-Id: <20200216.185600.43507558643527863.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: qrtr: Migrate nameservice to kernel from
 userspace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200213091427.13435-2-manivannan.sadhasivam@linaro.org>
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
        <20200213091427.13435-2-manivannan.sadhasivam@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:56:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Thu, 13 Feb 2020 14:44:26 +0530

> +static int service_announce_new(struct sockaddr_qrtr *dest,
> +				struct qrtr_server *srv)
> +{
> +	struct qrtr_ctrl_pkt pkt;
> +	struct msghdr msg = { };
> +	struct kvec iv = { &pkt, sizeof(pkt) };

Please use reverse christmas tree ordering for local variables.

Please fix this for your entire submission.
