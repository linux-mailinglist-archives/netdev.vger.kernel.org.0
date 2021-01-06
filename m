Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68722EB709
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhAFAs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:48:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56418 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbhAFAs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:48:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 06B704CBCE162;
        Tue,  5 Jan 2021 16:47:46 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:47:46 -0800 (PST)
Message-Id: <20210105.164746.1640903873851313603.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, kuba@kernel.org, huangdaode@huawei.com
Subject: Re: [PATCH net 0/3] net: hns3: fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
References: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:47:47 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Tue, 5 Jan 2021 11:37:25 +0800

> There are some bugfixes for the HNS3 ethernet driver.

Series applies and queued up for -stable, thanks
