Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1706277E4F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgIYDCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgIYDCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:02:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D24C0613CE;
        Thu, 24 Sep 2020 20:02:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94145135F8F13;
        Thu, 24 Sep 2020 19:45:32 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:02:18 -0700 (PDT)
Message-Id: <20200924.200218.285331593689018732.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yin.yinshi@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, zengweiliang.zengweiliang@huawei.com
Subject: Re: [PATCH net] hinic: fix wrong return value of mac-set cmd
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200924013151.25754-1-luobin9@huawei.com>
References: <20200924013151.25754-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:45:32 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Thu, 24 Sep 2020 09:31:51 +0800

> It should also be regarded as an error when hw return status=4 for PF's
> setting mac cmd. Only if PF return status=4 to VF should this cmd be
> taken special treatment.
> 
> Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
> Signed-off-by: Luo bin <luobin9@huawei.com>

Applied and queued up for -stable.
