Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06C512AF8A
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfLZXJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:09:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfLZXJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:09:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EA3815387C03;
        Thu, 26 Dec 2019 15:09:43 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:09:41 -0800 (PST)
Message-Id: <20191226.150941.618022568387879445.davem@davemloft.net>
To:     po.liu@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, ivan.khoronzhuk@linaro.org
Subject: Re: [net-next] enetc: add support time specific departure base on
 the qos etf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223032618.18205-1-Po.Liu@nxp.com>
References: <20191223032618.18205-1-Po.Liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:09:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Mon, 23 Dec 2019 03:42:39 +0000

> - Transmit checksum offloads and time specific departure operation
> are mutually exclusive.

I do not see anything which enforces this conflict.

It looks to me like if the user configures time specific departure,
and TX SKBs will be checksum offloaded, the time specific departure
will simply not be performed.

If true, this behavior will be very surprising for the user.

Instead, the configuration operation that creates the conflict should
throw and error and fail.

Thank you.
