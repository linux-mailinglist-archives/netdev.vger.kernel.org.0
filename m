Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D171DA9BFB
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732079AbfIEHhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 03:37:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbfIEHhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 03:37:23 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 876E815383DDF;
        Thu,  5 Sep 2019 00:37:21 -0700 (PDT)
Date:   Thu, 05 Sep 2019 00:37:19 -0700 (PDT)
Message-Id: <20190905.003719.181800411074203471.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/sched: cbs: remove redundant assignment to
 variable port_rate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190902182637.22167-1-colin.king@canonical.com>
References: <20190902182637.22167-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 00:37:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon,  2 Sep 2019 19:26:37 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable port_rate is being initialized with a value that is never read
> and is being re-assigned a little later on. The assignment is redundant
> and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
