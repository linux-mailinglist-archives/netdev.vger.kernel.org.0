Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7678F3F1
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbfHOSuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:50:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48226 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbfHOSuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:50:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8006413CB309C;
        Thu, 15 Aug 2019 11:50:54 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:50:54 -0700 (PDT)
Message-Id: <20190815.115054.1638381523069532598.davem@davemloft.net>
To:     linyunsheng@huawei.com
Cc:     hawk@kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] page_pool: remove unnecessary variable init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565872860-63524-1-git-send-email-linyunsheng@huawei.com>
References: <1565872860-63524-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 11:50:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Thu, 15 Aug 2019 20:41:00 +0800

> Remove variable initializations in functions that
> are followed by assignments before use
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Applied.
