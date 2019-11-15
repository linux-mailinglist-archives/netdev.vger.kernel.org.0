Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1637DFD2B8
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfKOCGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:06:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57554 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfKOCGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:06:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70C5314B79F6B;
        Thu, 14 Nov 2019 18:06:47 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:06:47 -0800 (PST)
Message-Id: <20191114.180647.1713082416024620207.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net 0/3] net: hns3: fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573698761-25682-1-git-send-email-tanhuazhong@huawei.com>
References: <1573698761-25682-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:06:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 14 Nov 2019 10:32:38 +0800

> This series includes misc fixes for the HNS3 ethernet driver.
> 
> [patch 1/3] adds a compatible handling for configuration of
> MAC VLAN swithch parameter.
> 
> [patch 2/3] re-allocates SSU buffer when pfc_en changed.
> 
> [patch 3/3] fixes a bug for ETS bandwidth validation.

Series applied.
