Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF576C0098
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfI0IEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:04:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfI0IEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:04:11 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C377014DD99F2;
        Fri, 27 Sep 2019 01:04:07 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:04:05 +0200 (CEST)
Message-Id: <20190927.100405.1303962323198385596.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: netsec: Fix signedness bug in netsec_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925105638.GE3264@mwanda>
References: <20190925105638.GE3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:04:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 13:56:38 +0300

> The "priv->phy_interface" variable is an enum and in this context GCC
> will treat it as an unsigned int so the error handling is never
> triggered.
> 
> Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
