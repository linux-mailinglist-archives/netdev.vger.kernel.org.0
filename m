Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880044A6BF
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfFRQZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:25:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbfFRQZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:25:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0DB6150988A8;
        Tue, 18 Jun 2019 09:25:12 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:25:12 -0700 (PDT)
Message-Id: <20190618.092512.1610110055396742434.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     sbrivio@redhat.com, jishi@redhat.com, weiwan@google.com,
        kafai@fb.com, edumazet@google.com,
        matti.vaittinen@fi.rohmeurope.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v5 0/6] Fix listing (IPv4, IPv6) and flushing
 (IPv6) of cached route exceptions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a88182c7-10ee-0505-3b5b-bec852e24e97@gmail.com>
References: <cover.1560827176.git.sbrivio@redhat.com>
        <a88182c7-10ee-0505-3b5b-bec852e24e97@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 09:25:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Tue, 18 Jun 2019 08:51:01 -0600

> Changing the dump code has been notoriously tricky to get right in one
> go, no matter how much testing you have done. Given that I think this
> should go to net-next first and once it proves ok there we can look at a
> backport to stable trees.

I agree, this is probably the wisest way forward with these changes.
