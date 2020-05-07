Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C951C9B91
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgEGUEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGUEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:04:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455DEC05BD43;
        Thu,  7 May 2020 13:04:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBE0D1195077C;
        Thu,  7 May 2020 13:04:34 -0700 (PDT)
Date:   Thu, 07 May 2020 13:04:33 -0700 (PDT)
Message-Id: <20200507.130433.641786124403769053.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: atheros: remove dead code in
 atl1c_resume()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507110836.37859-1-yanaijie@huawei.com>
References: <20200507110836.37859-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:04:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Thu, 7 May 2020 19:08:36 +0800

> This code has been marked dead for nearly 10 years. Remove it.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
