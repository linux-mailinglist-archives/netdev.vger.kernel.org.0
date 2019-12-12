Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4077F11D6C1
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbfLLTD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:03:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730168AbfLLTD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:03:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DCB6153DFC91;
        Thu, 12 Dec 2019 11:03:55 -0800 (PST)
Date:   Thu, 12 Dec 2019 11:03:54 -0800 (PST)
Message-Id: <20191212.110354.354662228217900367.davem@davemloft.net>
To:     info@metux.net
Cc:     linux-kernel@vger.kernel.org, jchapman@katalix.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: l2tp: remove unneeded MODULE_VERSION() usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191212133613.25376-1-info@metux.net>
References: <20191212133613.25376-1-info@metux.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 11:03:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Date: Thu, 12 Dec 2019 14:36:13 +0100

> Remove MODULE_VERSION(), as it isn't needed at all: the only version
> making sense is the kernel version.
> 
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>

Is there a plan to remove MODULE_VERSION across the entire kernel tree?

Where is that documented?

Otherwise what gave you the reason to make this change in the first place?

No context, no high level explanation of what's going on, so it's hard
to review and decide whether to accept your change sorry.

At the least, you will have to write a more complete commit log message.
