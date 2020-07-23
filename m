Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8A822B94D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgGWWUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgGWWUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:20:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD5EC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:20:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B635411E48C64;
        Thu, 23 Jul 2020 15:03:58 -0700 (PDT)
Date:   Thu, 23 Jul 2020 15:20:42 -0700 (PDT)
Message-Id: <20200723.152042.2176694627732181944.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com,
        sd@queasysnail.net
Subject: Re: [Patch net] geneve: fix an uninitialized value in
 geneve_changelink()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723015625.19255-1-xiyou.wangcong@gmail.com>
References: <20200723015625.19255-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 15:03:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 22 Jul 2020 18:56:25 -0700

> geneve_nl2info() sets 'df' conditionally, so we have to
> initialize it by copying the value from existing geneve
> device in geneve_changelink().
> 
> Fixes: 56c09de347e4 ("geneve: allow changing DF behavior after creation")
> Reported-by: syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com
> Cc: Sabrina Dubroca <sd@queasysnail.net>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks Cong.
