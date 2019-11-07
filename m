Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7407CF374E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfKGSeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:34:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfKGSeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:34:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC70A151E8C53;
        Thu,  7 Nov 2019 10:34:23 -0800 (PST)
Date:   Thu, 07 Nov 2019 10:34:21 -0800 (PST)
Message-Id: <20191107.103421.97006669944869516.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jbenc@redhat.com, tgraf@suug.ch, u9012063@gmail.com
Subject: Re: [PATCH net-next 0/5] lwtunnel: add ip and ip6 options setting
 and dumping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CADvbK_ePx7F62BR43UAFF5dmwHKJdkU6Tth06t5iirsH9_XgLg@mail.gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
        <20191106.211459.329583246222911896.davem@davemloft.net>
        <CADvbK_ePx7F62BR43UAFF5dmwHKJdkU6Tth06t5iirsH9_XgLg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 10:34:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 7 Nov 2019 18:50:15 +0800

> Now think about it again, nla_parse_nested() should always be used on
> new options, should I post a fix for it? since no code to access this
> from userspace yet.

If that is true, yes you should.
