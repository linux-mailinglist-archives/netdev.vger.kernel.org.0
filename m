Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305641B8BD8
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgDZD5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgDZD5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:57:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB6FC061A0C;
        Sat, 25 Apr 2020 20:57:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D41415A00EB0;
        Sat, 25 Apr 2020 20:57:09 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:57:08 -0700 (PDT)
Message-Id: <20200425.205708.525782253974441.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH V2 net-next 0/9] net: hns3: refactor for MAC table
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f1d27955-7ffc-7569-9038-17bff854af02@huawei.com>
References: <1587867228-9955-1-git-send-email-tanhuazhong@huawei.com>
        <f1d27955-7ffc-7569-9038-17bff854af02@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:57:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: tanhuazhong <tanhuazhong@huawei.com>
Date: Sun, 26 Apr 2020 11:44:18 +0800

> This V2 only adds patch #9 in V1. Since V1 has applied, could you pick
> patch #9 from V2, or i just resend patch #9?

I applied patch #9 from V2.
