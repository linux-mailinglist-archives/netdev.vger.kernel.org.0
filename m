Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B694F0C2B
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfKFCky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:40:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:40:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3AB01510CE1E;
        Tue,  5 Nov 2019 18:40:53 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:40:53 -0800 (PST)
Message-Id: <20191105.184053.2112877734260713502.davem@davemloft.net>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2019-11-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105145823.3FF88616AE@smtp.codeaurora.org>
References: <20191105145823.3FF88616AE@smtp.codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:40:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <kvalo@codeaurora.org>
Date: Tue,  5 Nov 2019 14:58:23 +0000 (UTC)

> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.

Pulled.

There was a minor merge conflict, please double check my work.
