Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7611F3E9C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 04:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfKHDzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 22:55:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfKHDzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 22:55:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3079B14F2001D;
        Thu,  7 Nov 2019 19:55:32 -0800 (PST)
Date:   Thu, 07 Nov 2019 19:55:31 -0800 (PST)
Message-Id: <20191107.195531.1750270574797606914.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 07/12] net: atlantic: loopback tests via
 private flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <40050bde3262ea177f9656b530000f0154814d5a.1573158382.git.irusskikh@marvell.com>
References: <cover.1573158381.git.irusskikh@marvell.com>
        <40050bde3262ea177f9656b530000f0154814d5a.1573158382.git.irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 19:55:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Thu, 7 Nov 2019 22:41:58 +0000

> + 	$ ethtool --set-priv-flags ethX DMASystemLoopback on

There is a space before the TAB character here, which I removed
while applying this series.
