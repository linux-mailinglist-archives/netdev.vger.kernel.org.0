Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A451D83AEA
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfHFVPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:15:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfHFVPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:15:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97F9212B88C0D;
        Tue,  6 Aug 2019 14:15:51 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:15:51 -0700 (PDT)
Message-Id: <20190806.141551.1409190373431308674.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, pieter.jansenvanvuuren@netronome.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net 0/2] action fixes for flow_offload infra
 compatibility
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190803133619.10574-1-vladbu@mellanox.com>
References: <20190803133619.10574-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:15:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Sat,  3 Aug 2019 16:36:17 +0300

> Fix rcu warnings due to usage of action helpers that expect rcu read lock
> protection from rtnl-protected context of flow_offload infra.

Series applied.
