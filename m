Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B697D12F240
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgACAhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:37:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:37:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 772D31572D903;
        Thu,  2 Jan 2020 16:37:44 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:37:44 -0800 (PST)
Message-Id: <20200102.163744.410305299962714453.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: use REXMIT_NEW instead of magic number
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102140227.77780-1-maowenan@huawei.com>
References: <20200102140227.77780-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:37:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Thu, 2 Jan 2020 22:02:27 +0800

> REXMIT_NEW is a macro for "FRTO-style
> transmit of unsent/new packets", this patch
> makes it more readable.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied.
