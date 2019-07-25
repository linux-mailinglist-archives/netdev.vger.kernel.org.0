Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C1B756C6
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGYSWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:22:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36812 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfGYSWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:22:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 233261434E34A;
        Thu, 25 Jul 2019 11:22:21 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:22:20 -0700 (PDT)
Message-Id: <20190725.112220.1065850726074526108.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+fbb5b288c9cb6a2eeac4@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] ife: error out when nla attributes are empty
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723044300.16143-1-xiyou.wangcong@gmail.com>
References: <20190723044300.16143-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:22:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 22 Jul 2019 21:43:00 -0700

> act_ife at least requires TCA_IFE_PARMS, so we have to bail out
> when there is no attribute passed in.
> 
> Reported-by: syzbot+fbb5b288c9cb6a2eeac4@syzkaller.appspotmail.com
> Fixes: ef6980b6becb ("introduce IFE action")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable.
