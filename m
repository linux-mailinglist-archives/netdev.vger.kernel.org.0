Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C12E491F3
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfFQVGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:06:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfFQVGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:06:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A6DBC151397AE;
        Mon, 17 Jun 2019 14:05:59 -0700 (PDT)
Date:   Mon, 17 Jun 2019 14:05:59 -0700 (PDT)
Message-Id: <20190617.140559.2007026200675147689.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: hns3: fix dereference of ae_dev before it
 is null checked
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617114214.25276-1-colin.king@canonical.com>
References: <20190617114214.25276-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 14:05:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 17 Jun 2019 12:42:14 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer ae_dev is null checked however, prior to that it is dereferenced
> when assigned pointer ops. Fix this by assigning pointer ops after ae_dev
> has been null checked.
> 
> Addresses-Coverity: ("Dereference before null check")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
