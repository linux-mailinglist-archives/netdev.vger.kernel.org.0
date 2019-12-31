Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C43912D623
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfLaE0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:26:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaE0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:26:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56EF913EF09B8;
        Mon, 30 Dec 2019 20:26:53 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:26:52 -0800 (PST)
Message-Id: <20191230.202652.128958107020164612.davem@davemloft.net>
To:     po.liu@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, ivan.khoronzhuk@linaro.org
Subject: Re: [v2,net-next] enetc: add support time specific departure base
 on the qos etf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227025547.4452-1-Po.Liu@nxp.com>
References: <20191223032618.18205-1-Po.Liu@nxp.com>
        <20191227025547.4452-1-Po.Liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:26:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Fri, 27 Dec 2019 03:12:18 +0000

> v2:
> - fix the csum and time specific deaprture return directly if both
> offloading enabled

The test is in the wrong location.

You are testing at run time when packets are being transmitted.

Instead, you should test when the configuration change is made
which creates the conflict, and disallow the configuration change
in such a conflicting case.
