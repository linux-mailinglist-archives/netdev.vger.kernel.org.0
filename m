Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD133A6EA0
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhFNTPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:15:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59930 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhFNTPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 15:15:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 8A7904D0798AF;
        Mon, 14 Jun 2021 12:12:57 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:12:34 -0700 (PDT)
Message-Id: <20210614.121234.1863995090731912256.davem@davemloft.net>
To:     changbin.du@gmail.com
Cc:     viro@zeniv.linux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xiyou.wangcong@gmail.com, David.Laight@ACULAB.COM,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v4] net: make get_net_ns return error if NET_NS is
 disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210611142959.92358-1-changbin.du@gmail.com>
References: <20210611142959.92358-1-changbin.du@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 14 Jun 2021 12:12:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I applied an earlie5r version of this chsange already, so you will
need to send relative fixups.

Thank you.
