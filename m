Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BEA141DA0
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgASLbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:31:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgASLbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:31:24 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 610F614C8D41A;
        Sun, 19 Jan 2020 03:31:23 -0800 (PST)
Date:   Fri, 17 Jan 2020 04:25:40 -0800 (PST)
Message-Id: <20200117.042540.384618667285089808.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] netns: Constify exported functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a681349038fd0358b304c8b9a744946831e5e5f1.1579205730.git.gnault@redhat.com>
References: <a681349038fd0358b304c8b9a744946831e5e5f1.1579205730.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 03:31:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Thu, 16 Jan 2020 21:16:46 +0100

> Mark function parameters as 'const' where possible.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thank you.
