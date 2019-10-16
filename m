Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C211BD98BE
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390342AbfJPRuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:50:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52296 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390071AbfJPRuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:50:05 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C43EB14239BEE;
        Wed, 16 Oct 2019 10:50:04 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:50:03 -0400 (EDT)
Message-Id: <20191016.135003.672960397161023411.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     tanhuazhong@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH net-next 00/12] net: hns3: add some bugfixes and
 optimizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016101943.415d73cf@cakuba.netronome.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
        <20191016101943.415d73cf@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 10:50:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 16 Oct 2019 10:19:43 -0700

> On Wed, 16 Oct 2019 15:16:59 +0800, Huazhong Tan wrote:
>> This patch-set includes some bugfixes and code optimizations
>> for the HNS3 ethernet controller driver.
> 
> The code LGTM, mostly, but it certainly seems like patches 2, 3 and 4
> should be a separate series targeting the net tree :(

Agreed, there are legitimate bug fixes.

I have to say that I see this happening a lot, hns3 bug fixes targetting
net-next in a larger series of cleanups and other kinds of changes.

Please handle this delegation properly.  Send bug fixes as a series targetting
'net', and send everything else targetting 'net-next'.
