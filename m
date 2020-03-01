Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21A2174B91
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgCAFha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:37:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgCAFha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:37:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAD9B15BD9535;
        Sat, 29 Feb 2020 21:37:29 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:37:29 -0800 (PST)
Message-Id: <20200229.213729.1698891858177446295.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] hsr: several code cleanup for hsr module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200228180046.27511-1-ap420073@gmail.com>
References: <20200228180046.27511-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:37:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Fri, 28 Feb 2020 18:00:46 +0000

> This patchset is to clean up hsr module code.

Looks good to me, series applied, thank you.
