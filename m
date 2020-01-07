Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DEA1334F0
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgAGVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:33:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAGVd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:33:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DE8F15A17305;
        Tue,  7 Jan 2020 13:33:57 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:33:56 -0800 (PST)
Message-Id: <20200107.133356.1098529764999241784.davem@davemloft.net>
To:     chenzhou10@huawei.com
Cc:     khc@pm.waw.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] drivers: net: cisco_hdlc: use __func__ in debug
 message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107093346.99855-1-chenzhou10@huawei.com>
References: <20200107093346.99855-1-chenzhou10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:33:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>
Date: Tue, 7 Jan 2020 17:33:46 +0800

> Use __func__ to print the function name instead of hard coded string.
> BTW, replace printk(KERN_DEBUG, ...) with netdev_dbg.
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

Applied, thanks.
