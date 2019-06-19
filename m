Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8314AFB7
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 03:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbfFSBw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 21:52:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFSBw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 21:52:56 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E721714D08ED1;
        Tue, 18 Jun 2019 18:52:48 -0700 (PDT)
Date:   Tue, 18 Jun 2019 21:52:43 -0400 (EDT)
Message-Id: <20190618.215243.219004228932777039.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [PATCH net-next v5 0/3] hinic: add rss support and rss
 parameters configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618062053.7545-1-xuechaojing@huawei.com>
References: <20190618062053.7545-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 18:52:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xue Chaojing <xuechaojing@huawei.com>
Date: Tue, 18 Jun 2019 06:20:50 +0000

> This series add rss support for HINIC driver and implement the ethtool
> interface related to rss parameter configuration. user can use ethtool
> configure rss parameters or show rss parameters.

Series applied, thanks.
