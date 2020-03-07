Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38FE17CC5E
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 07:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgCGGDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:03:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgCGGDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:03:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2ED65154F6F03;
        Fri,  6 Mar 2020 22:03:18 -0800 (PST)
Date:   Fri, 06 Mar 2020 22:03:17 -0800 (PST)
Message-Id: <20200306.220317.1524198732560462803.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org, parav@mellanox.com
Subject: Re: [PATCH v2 net] ionic: fix vf op lock usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304174210.63954-1-snelson@pensando.io>
References: <20200304174210.63954-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 22:03:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed,  4 Mar 2020 09:42:10 -0800

> These are a couple of read locks that should be write locks.
> 
> Fixes: fbb39807e9ae ("ionic: support sr-iov operations")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> ---
> v2 - fixed the Fixes line

Applied, thanks.
