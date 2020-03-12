Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E651828E8
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387961AbgCLGUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:20:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387908AbgCLGUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:20:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B354D14DA84AA;
        Wed, 11 Mar 2020 23:20:20 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:20:20 -0700 (PDT)
Message-Id: <20200311.232020.386617617756186776.davem@davemloft.net>
To:     jbi.octave@gmail.com
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        allison@lohutok.net, pankaj.laxminarayan.bharadiya@intel.com,
        ptalbert@redhat.com, ap420073@gmail.com, lirongqing@baidu.com,
        tglx@linutronix.de, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH 6/8] net: Add missing annotation for
 *netlink_seq_start()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311010908.42366-7-jbi.octave@gmail.com>
References: <0/8>
        <20200311010908.42366-1-jbi.octave@gmail.com>
        <20200311010908.42366-7-jbi.octave@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:20:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>
Date: Wed, 11 Mar 2020 01:09:06 +0000

> Sparse reports a warning at netlink_seq_start()
> 
> warning: context imbalance in netlink_seq_start() - wrong count at exit
> The root cause is the missing annotation at netlink_seq_start()
> Add the missing  __acquires(RCU) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Applied.
