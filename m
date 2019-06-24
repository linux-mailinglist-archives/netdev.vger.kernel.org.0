Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497965184B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfFXQVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:21:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56794 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfFXQVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:21:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39A511504D45B;
        Mon, 24 Jun 2019 09:21:10 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:21:09 -0700 (PDT)
Message-Id: <20190624.092109.2031618942295120088.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] tipc: check msg->req data len in
 tipc_nl_compat_bearer_disable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CADvbK_dSghWbMtmpH+oMpW=0CsSU-usjQ=_nZw2qkgQ0iEuH+A@mail.gmail.com>
References: <4fd888cb669434b00dce24ace4410524665be285.1561363146.git.lucien.xin@gmail.com>
        <061d3bd2-46a2-04aa-a3f7-3091e6ff8523@gmail.com>
        <CADvbK_dSghWbMtmpH+oMpW=0CsSU-usjQ=_nZw2qkgQ0iEuH+A@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 09:21:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 25 Jun 2019 00:00:39 +0800

> Sorry, David, do I need to resend this one?

Yes, please, that helps me a lot.
