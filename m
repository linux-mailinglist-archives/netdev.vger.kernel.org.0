Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A369D103048
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfKSXdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:33:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46602 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfKSXdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:33:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B436C142A3422;
        Tue, 19 Nov 2019 15:33:41 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:33:41 -0800 (PST)
Message-Id: <20191119.153341.1849410731804008442.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, olteanv@gmail.com
Subject: Re: [net PATCH v2] taprio: don't reject same mqprio settings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119002312.23811-1-ivan.khoronzhuk@linaro.org>
References: <20191119002312.23811-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 15:33:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Tue, 19 Nov 2019 02:23:12 +0200

> The taprio qdisc allows to set mqprio setting but only once. In case
> if mqprio settings are provided next time the error is returned as
> it's not allowed to change traffic class mapping in-flignt and that
> is normal. But if configuration is absolutely the same - no need to
> return error. It allows to provide same command couple times,
> changing only base time for instance, or changing only scheds maps,
> but leaving mqprio setting w/o modification. It more corresponds the
> message: "Changing the traffic mapping of a running schedule is not
> supported", so reject mqprio if it's really changed.
> 
> Also corrected TC_BITMASK + 1 for consistency, as proposed.
> 
> Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Tested-by: Vladimir Oltean <olteanv@gmail.com>
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied and queued up for -stable.
