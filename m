Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E8A1A19A3
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgDHBiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:38:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgDHBiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:38:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9E4B1210A3E3;
        Tue,  7 Apr 2020 18:38:09 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:38:08 -0700 (PDT)
Message-Id: <20200407.183808.1820111338460470376.davem@davemloft.net>
To:     wenhu.wang@vivo.com
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org, allison@lohutok.net,
        hofrat@osadl.org, mkl@pengutronix.de, tglx@linutronix.de,
        arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, opensource.kernel@vivo.org
Subject: Re: [PATCH] net: qrtr: send msgs from local of same id as broadcast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200407132930.109738-1-wenhu.wang@vivo.com>
References: <20200407132930.109738-1-wenhu.wang@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:38:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: WANG Wenhu <wenhu.wang@vivo.com>
Date: Tue,  7 Apr 2020 06:29:28 -0700

> -		enqueue_fn = qrtr_bcast_enqueue;
> -		if (addr->sq_port != QRTR_PORT_CTRL) {
> +		if (addr->sq_port != QRTR_PORT_CTRL &&
> +				qrtr_local_nid != QRTR_NODE_BCAST) {

Please line up the second line of this if() statement with the column
after the openning parenthesis of the first line.
