Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AABB8037C
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 02:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390597AbfHCAb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 20:31:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52562 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfHCAb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 20:31:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E30CB1264F96F;
        Fri,  2 Aug 2019 17:31:26 -0700 (PDT)
Date:   Fri, 02 Aug 2019 17:31:25 -0700 (PDT)
Message-Id: <20190802.173125.399771294364845553.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: iphase: Fix Spectre v1 vulnerability
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731032141.GA30246@embeddedor>
References: <20190731032141.GA30246@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 17:31:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Tue, 30 Jul 2019 22:21:41 -0500

> board is controlled by user-space, hence leading to a potential
> exploitation of the Spectre variant 1 vulnerability.
> 
> This issue was detected with the help of Smatch:

Applied and queued up for -stable.

Do not CC: -stable for networking fixes, we take care of the stable
submissions manually for this subsystem.

Thank you.
