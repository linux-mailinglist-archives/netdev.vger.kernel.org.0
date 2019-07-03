Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F085EB94
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfGCS20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:28:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCS20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:28:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC779140D2A74;
        Wed,  3 Jul 2019 11:28:25 -0700 (PDT)
Date:   Wed, 03 Jul 2019 11:28:25 -0700 (PDT)
Message-Id: <20190703.112825.158608951903177341.davem@davemloft.net>
To:     csully@google.com
Cc:     netdev@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH] gve: Fix u64_stats_sync to initialize start
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702224657.23568-1-csully@google.com>
References: <20190702224657.23568-1-csully@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 11:28:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>
Date: Tue,  2 Jul 2019 15:46:57 -0700

> u64_stats_fetch_begin needs to initialize start.
> 
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Reported-by: kbuild test robot <lkp@intel.com>

Applied, but in the future please indicate the target GIT tree in your
Subject line, in this case it would be "[PATCH net-next] ..."
