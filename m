Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E214F8FF
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfFVXmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:42:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFVXmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:42:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 29880153913ED;
        Sat, 22 Jun 2019 16:42:11 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:42:10 -0700 (PDT)
Message-Id: <20190622.164210.750959534323285399.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [PATCH net-next] hinic: implement the statistical interface of
 ethtool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620055808.13474-1-xuechaojing@huawei.com>
References: <20190620055808.13474-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:42:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Thu, 20 Jun 2019 05:58:08 +0000

> +			p = (char *)(&txq_stats) +
> +				hinic_tx_queue_stats[j].offset;

Parenthesis around &txq_stats is unnecessary.

> +			p = (char *)(&rxq_stats) +
> +				hinic_rx_queue_stats[j].offset;

Similarly for &rxq_stats.

> +		p = (char *)(net_stats) + hinic_netdev_stats[j].offset;

Similarly for net_stats.

> +		p = (char *)(&vport_stats) + hinic_function_stats[j].offset;

And &vport_stats.

> +		p = (char *)(port_stats) + hinic_port_stats[j].offset;

And port_stats.
