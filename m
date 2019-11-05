Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B38F08DA
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfKEV7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:59:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729970AbfKEV7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:59:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEDF7150689D1;
        Tue,  5 Nov 2019 13:59:22 -0800 (PST)
Date:   Tue, 05 Nov 2019 13:59:22 -0800 (PST)
Message-Id: <20191105.135922.2017882327420588902.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] taprio: fix panic while hw offload sched list swap
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101232828.17023-1-ivan.khoronzhuk@linaro.org>
References: <20191101232828.17023-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 13:59:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Sat,  2 Nov 2019 01:28:28 +0200

> Don't swap oper and admin schedules too early, it's not correct and
> causes crash.
 ...

Applied, thanks.
