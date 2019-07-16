Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789EF6B0F7
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfGPVTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:19:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58156 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbfGPVTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:19:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5E961264EA04;
        Tue, 16 Jul 2019 14:19:04 -0700 (PDT)
Date:   Tue, 16 Jul 2019 14:19:04 -0700 (PDT)
Message-Id: <20190716.141904.308520366333461345.davem@davemloft.net>
To:     vedang.patel@intel.com
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com, stephen@networkplumber.org
Subject: Re: [PATCH net-next v1] fix: taprio: Change type of txtime-delay
 parameter to u32
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563306738-2779-1-git-send-email-vedang.patel@intel.com>
References: <1563306738-2779-1-git-send-email-vedang.patel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jul 2019 14:19:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vedang Patel <vedang.patel@intel.com>
Date: Tue, 16 Jul 2019 12:52:18 -0700

> During the review of the iproute2 patches for txtime-assist mode, it was
> pointed out that it does not make sense for the txtime-delay parameter to
> be negative. So, change the type of the parameter from s32 to u32.
> 
> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>

You should have targetted this at 'net' as that's the only tree open
right now.

I'll apply this.
