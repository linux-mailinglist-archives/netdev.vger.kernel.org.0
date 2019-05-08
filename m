Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AF417E62
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfEHQou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:44:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfEHQot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:44:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21CFA14052394;
        Wed,  8 May 2019 09:44:49 -0700 (PDT)
Date:   Wed, 08 May 2019 09:44:48 -0700 (PDT)
Message-Id: <20190508.094448.2122383359846407940.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns3: remove redundant assignment of l2_hdr to
 itself
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508105135.13170-1-colin.king@canonical.com>
References: <20190508105135.13170-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 09:44:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed,  8 May 2019 11:51:35 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer l2_hdr is being assigned to itself, this is redundant
> and can be removed.
> 
> Addresses-Coverity: ("Evaluation order violation")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
