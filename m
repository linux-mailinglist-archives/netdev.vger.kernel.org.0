Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39E622D29B
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgGYAER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGYAEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE9AC0619D3;
        Fri, 24 Jul 2020 17:04:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F78D12756FF3;
        Fri, 24 Jul 2020 16:47:31 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:04:15 -0700 (PDT)
Message-Id: <20200724.170415.1190789583922952011.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com
Subject: Re: [PATCH net-next v4 1/2] hinic: add support to handle hw
 abnormal event
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724091732.19819-2-luobin9@huawei.com>
References: <20200724091732.19819-1-luobin9@huawei.com>
        <20200724091732.19819-2-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:47:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Fri, 24 Jul 2020 17:17:31 +0800

> +static int hinic_fw_reporter_dump(struct devlink_health_reporter *reporter,
> +				  struct devlink_fmsg *fmsg, void *priv_ctx,
> +				  struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (priv_ctx) {
> +		err = mgmt_watchdog_report_show(fmsg, priv_ctx);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}

As Edward Cree pointed out for v3 of this patch series, this 'err' is not
necessary at all.
