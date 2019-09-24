Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70B1BCA6E
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732472AbfIXOkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:40:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52482 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfIXOkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 10:40:20 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 463811527969B;
        Tue, 24 Sep 2019 07:40:18 -0700 (PDT)
Date:   Tue, 24 Sep 2019 16:40:16 +0200 (CEST)
Message-Id: <20190924.164016.43204807921728597.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, keescook@google.com,
        dvyukov@google.com, edumazet@google.com, maheshb@google.com,
        lorenzo@google.com
Subject: Re: [PATCH] net-icmp: remove ping_group_range sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190919103944.129616-1-zenczykowski@gmail.com>
References: <20190919103944.129616-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 07:40:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Removing this is going to break things, you can't just remove a sysctl
because "oh it was a bad idea to add this, sorry."
