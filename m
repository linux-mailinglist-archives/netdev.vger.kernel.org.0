Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99FF12A963
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 01:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLZAU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 19:20:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfLZAU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 19:20:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2CB231537E7C4;
        Wed, 25 Dec 2019 16:20:57 -0800 (PST)
Date:   Wed, 25 Dec 2019 16:20:56 -0800 (PST)
Message-Id: <20191225.162056.585355796118426575.davem@davemloft.net>
To:     netanel@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, akiyano@amazon.com
Subject: Re: [PATCH V1 net-next] MAINTAINERS: Add additional maintainers to
 ENA Ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191222094759.17542-1-netanel@amazon.com>
References: <20191222094759.17542-1-netanel@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Dec 2019 16:20:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Netanel Belgazal <netanel@amazon.com>
Date: Sun, 22 Dec 2019 09:47:59 +0000

> Signed-off-by: Netanel Belgazal <netanel@amazon.com>

MAINTAINERS updates can go straight upstream, so applied to 'net', thanks.
