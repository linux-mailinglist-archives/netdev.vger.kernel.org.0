Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC55227405
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgGUAoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgGUAoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:44:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E3FC061794;
        Mon, 20 Jul 2020 17:44:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D651311E8EC0A;
        Mon, 20 Jul 2020 17:27:48 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:44:32 -0700 (PDT)
Message-Id: <20200720.174432.702526374205425580.davem@davemloft.net>
To:     wangxiongfeng2@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: add a newline when printing 'tx_timeout' by
 sysfs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595243869-57100-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1595243869-57100-1-git-send-email-wangxiongfeng2@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:27:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Date: Mon, 20 Jul 2020 19:17:49 +0800

> -	return sprintf(buf, "%lu", trans_timeout);
> +	return sprintf(buf, "%lu\n", trans_timeout);

Better to replace it with 'fmt_ulong'.
