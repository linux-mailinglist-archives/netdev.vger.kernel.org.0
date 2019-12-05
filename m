Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E971138F4
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfLEAqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:46:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLEAqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:46:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C12B14F252A9;
        Wed,  4 Dec 2019 16:46:13 -0800 (PST)
Date:   Wed, 04 Dec 2019 16:46:12 -0800 (PST)
Message-Id: <20191204.164612.1086273679730587962.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ionic: keep users rss hash across lif reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203221734.70798-1-snelson@pensando.io>
References: <20191203221734.70798-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 16:46:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue,  3 Dec 2019 14:17:34 -0800

> If the user has specified their own RSS hash key, don't
> lose it across queue resets such as DOWN/UP, MTU change,
> and number of channels change.  This is fixed by moving
> the key initialization to a little earlier in the lif
> creation.
> 
> Also, let's clean up the RSS config a little better on
> the way down by setting it all to 0.
> 
> Fixes: aa3198819bea ("ionic: Add RSS support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Looks good, applied and queued up for -stable.
