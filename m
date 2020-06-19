Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E973F2000EB
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgFSDnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbgFSDnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:43:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3635C06174E;
        Thu, 18 Jun 2020 20:43:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68AF1120ED49C;
        Thu, 18 Jun 2020 20:43:29 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:43:28 -0700 (PDT)
Message-Id: <20200618.204328.986811763648446488.davem@davemloft.net>
To:     song.bao.hua@hisilicon.com
Cc:     kuba@kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, linyunsheng@huawei.com,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH 0/5] net: hns3: a bundle of minor cleanup and fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
References: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:43:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>
Date: Thu, 18 Jun 2020 13:02:06 +1200

> some minor changes to either improve the readability or make the code align
> with linux APIs better.

Series applied, thanks.
