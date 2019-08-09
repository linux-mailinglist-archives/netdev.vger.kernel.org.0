Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E248387131
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404954AbfHIFBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:01:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55888 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfHIFBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:01:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D07D140505DB;
        Thu,  8 Aug 2019 22:01:11 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:01:10 -0700 (PDT)
Message-Id: <20190808.220110.894522042255176514.davem@davemloft.net>
To:     ivan.khoronzhuk@linaro.org
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sched: sch_taprio: fix memleak in error path
 for sched list parse
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806224540.24912-1-ivan.khoronzhuk@linaro.org>
References: <20190806224540.24912-1-ivan.khoronzhuk@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:01:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Wed,  7 Aug 2019 01:45:40 +0300

> In error case, all entries should be freed from the sched list
> before deleting it. For simplicity use rcu way.
> 
> Fixes: 5a781ccbd19e46 ("tc: Add support for configuring the taprio scheduler")
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied and queued up for -stable, thank you.
