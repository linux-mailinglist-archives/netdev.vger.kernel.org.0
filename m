Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95A020287E
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 06:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgFUEaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 00:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFUEaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 00:30:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E69C061794;
        Sat, 20 Jun 2020 21:30:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1CD21274A803;
        Sat, 20 Jun 2020 21:30:10 -0700 (PDT)
Date:   Sat, 20 Jun 2020 21:30:03 -0700 (PDT)
Message-Id: <20200620.213003.385510660746410459.davem@davemloft.net>
To:     gaurav1086@gmail.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net/sched] Remove redundant skb null check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619192414.22158-1-gaurav1086@gmail.com>
References: <20200618014328.28668-1-gaurav1086@gmail.com>
        <20200619192414.22158-1-gaurav1086@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 21:30:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Date: Fri, 19 Jun 2020 15:24:13 -0400

> Remove the redundant null check for skb.
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Applied to net-next.
