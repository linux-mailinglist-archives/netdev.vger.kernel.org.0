Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B197E121
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 19:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfHARci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 13:32:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHARch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 13:32:37 -0400
Received: from localhost (c-24-22-75-21.hsd1.or.comcast.net [24.22.75.21])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31F76153F5907;
        Thu,  1 Aug 2019 10:32:37 -0700 (PDT)
Date:   Thu, 01 Aug 2019 13:32:36 -0400 (EDT)
Message-Id: <20190801.133236.1031691680093284497.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/12] net: hns3: some code optimizations &
 bugfixes & features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 10:32:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 1 Aug 2019 11:55:33 +0800

> This patch-set includes code optimizations, bugfixes and features for
> the HNS3 ethernet controller driver.

These look good, series applied, thanks.
