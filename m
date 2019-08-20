Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55D196947
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfHTTUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:20:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729231AbfHTTUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:20:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E851146D0CC0;
        Tue, 20 Aug 2019 12:20:31 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:20:30 -0700 (PDT)
Message-Id: <20190820.122030.1841548147195646151.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, sbrivio@redhat.com, wenxu@ucloud.cn,
        ast@fb.com, eric.dumazet@gmail.com
Subject: Re: [PATCHv2 0/2] fix dev null pointer dereference when send pkg
 larger than mtu in collect_md mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819075327.32412-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
        <20190819075327.32412-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:20:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Mon, 19 Aug 2019 15:53:25 +0800

> Subject: [PATCHv2 0/2] fix dev null pointer dereference when send pkg larger than mtu in collect_md mode

Please don't use the word "package" or the shorthand "pkg" when referring
to network packets.  Always use the full word "packets".

Please fix this up for your entire submission.

Thank you.
