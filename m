Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D5519C4AB
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388751AbgDBOsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:48:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47682 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388516AbgDBOsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:48:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 321CC128A8288;
        Thu,  2 Apr 2020 07:48:37 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:33:21 -0700 (PDT)
Message-Id: <20200325.113321.1619926902166742185.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] selftests/net: add missing tests to Makefile
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325080701.14940-1-liuhangbin@gmail.com>
References: <20200325080701.14940-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 07:48:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Wed, 25 Mar 2020 16:07:01 +0800

> Find some tests are missed in Makefile by running:
> for file in $(ls *.sh); do grep -q $file Makefile || echo $file; done
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied.
