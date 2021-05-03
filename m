Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DE43721D2
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhECUsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:48:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46088 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhECUr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 16:47:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 2C75F4D2CA82E;
        Mon,  3 May 2021 13:47:06 -0700 (PDT)
Date:   Mon, 03 May 2021 13:47:05 -0700 (PDT)
Message-Id: <20210503.134705.2258039169931960684.davem@davemloft.net>
To:     shubhankarvk@gmail.com
Cc:     pshelar@ovn.org, kuba@kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: openswitch: flow_netlink.c: Fix indentation errors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210503181706.vd5onvgptqd7squ2@kewl-virtual-machine>
References: <20210503181706.vd5onvgptqd7squ2@kewl-virtual-machine>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 03 May 2021 13:47:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Date: Mon, 3 May 2021 23:47:06 +0530

> Every subsequent line starts with a * of block comment
> The closing */ is shifted to a new line
> New line added after declaration
> The repeasted word 'is' is omitted from comment block
> This is done to maintain code uniformity
> 
> Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Please resubmit this when net-next opens back up.

Thank you.
