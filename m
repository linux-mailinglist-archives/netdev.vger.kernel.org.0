Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0771B8BC4
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgDZDqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgDZDqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:46:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462B7C061A0C;
        Sat, 25 Apr 2020 20:46:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A37A2159FFB1B;
        Sat, 25 Apr 2020 20:46:43 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:46:42 -0700 (PDT)
Message-Id: <20200425.204642.967836707202430007.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next v1 0/3] hinic: add SR-IOV support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200425012111.4297-1-luobin9@huawei.com>
References: <20200425012111.4297-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:46:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Sat, 25 Apr 2020 01:21:08 +0000

> patch #1 adds mailbox channel support and vf can
> communicate with pf or hw through it.
> patch #2 adds support for enabling vf and tx/rx
> capabilities based on vf.
> patch #3 adds support for vf's basic configurations.

Series applied, thanks.
