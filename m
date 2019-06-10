Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96F83AD62
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbfFJC5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:57:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48950 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfFJC5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:57:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D21614EAF62D;
        Sun,  9 Jun 2019 19:57:43 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:57:42 -0700 (PDT)
Message-Id: <20190609.195742.739339469351067643.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        akpm@linux-foundation.org, rdunlap@infradead.org,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190608125019.417-1-mcroce@redhat.com>
References: <20190608125019.417-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:57:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Sat,  8 Jun 2019 14:50:19 +0200

> MPLS routing code relies on sysctl to work, so let it select PROC_SYSCTL.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied, thanks.
