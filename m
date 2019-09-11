Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA09BAF771
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfIKIJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:09:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfIKIJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:09:06 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0CBCB15565B71;
        Wed, 11 Sep 2019 01:09:04 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:09:03 +0200 (CEST)
Message-Id: <20190911.100903.2146710144133658139.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH V2 net-next 0/7] net: hns3: add a feature & bugfixes &
 cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
References: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:09:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Wed, 11 Sep 2019 10:40:32 +0800

> This patch-set includes a VF feature, bugfixes and cleanups for the HNS3
> ethernet controller driver.

Series applied.
