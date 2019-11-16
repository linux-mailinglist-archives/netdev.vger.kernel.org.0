Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4DFF5B4
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfKPVE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:04:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:04:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12CD3151A1603;
        Sat, 16 Nov 2019 13:04:56 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:04:55 -0800 (PST)
Message-Id: <20191116.130455.2286569815164174637.davem@davemloft.net>
To:     salil.mehta@huawei.com
Cc:     yisen.zhuang@huawei.com, lipeng321@huawei.com,
        mehta.salil@opnsrc.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net] net: hns3: cleanup of stray struct
 hns3_link_mode_mapping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115115232.18600-1-salil.mehta@huawei.com>
References: <20191115115232.18600-1-salil.mehta@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:04:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Salil Mehta <salil.mehta@huawei.com>
Date: Fri, 15 Nov 2019 11:52:32 +0000

> This patch cleans-up the stray left over code. It has no
> functionality impact.
> 
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>

Applied, thanks Salil.
