Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB95184E9A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgCMSam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:30:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCMSal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:30:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EF19159DA2B9;
        Fri, 13 Mar 2020 11:30:41 -0700 (PDT)
Date:   Fri, 13 Mar 2020 11:30:40 -0700 (PDT)
Message-Id: <20200313.113040.218139161280414513.davem@davemloft.net>
To:     yangpc@wangsu.com
Cc:     edumazet@google.com, ncardwell@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] tcp: fix stretch ACK bugs in BIC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584118044-9798-1-git-send-email-yangpc@wangsu.com>
References: <1584118044-9798-1-git-send-email-yangpc@wangsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 11:30:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You must always submit a patch series with an appropriate "[PATCH 0/N ..."
posting, which explains what the series as a whole is doing, how it is doing
it, and why it is doing it that way.

Thank you.
