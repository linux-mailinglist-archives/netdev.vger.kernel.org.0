Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725E4DF504
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbfJUSXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:23:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUSXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:23:32 -0400
Received: from localhost (unknown [4.14.35.89])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB5571423DA55;
        Mon, 21 Oct 2019 11:23:31 -0700 (PDT)
Date:   Mon, 21 Oct 2019 11:23:29 -0700 (PDT)
Message-Id: <20191021.112329.2163071075397415534.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: act_police: re-use tcf_tm_dump()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8f87292222c28f9b497bbd1f192045b57b38ce72.1571503698.git.dcaratti@redhat.com>
References: <8f87292222c28f9b497bbd1f192045b57b38ce72.1571503698.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Oct 2019 11:23:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Sat, 19 Oct 2019 18:49:32 +0200

> Use tcf_tm_dump(), instead of an open coded variant (no functional change
> in this patch).
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied.
