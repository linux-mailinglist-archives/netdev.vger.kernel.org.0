Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440254FD75
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfFWSIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:08:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43318 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfFWSIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:08:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D42A15310D44;
        Sun, 23 Jun 2019 11:08:35 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:08:35 -0700 (PDT)
Message-Id: <20190623.110835.523516058927476452.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     xuechaojing@huawei.com, aviad.krawczyk@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][net-next] hinic: fix dereference of pointer hwdev
 before it is null checked
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620132751.26438-1-colin.king@canonical.com>
References: <20190620132751.26438-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:08:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 20 Jun 2019 14:27:51 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently pointer hwdev is dereferenced when assigning hwif before
> hwdev is null checked.  Fix this by only derefencing hwdev after the
> null check.
> 
> Addresses-Coverity: ("Dereference before null check")
> Fixes: 4fdc51bb4e92 ("hinic: add support for rss parameters with ethtool")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
