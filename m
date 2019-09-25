Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C71BDD75
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391258AbfIYLzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:55:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbfIYLzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:55:15 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC21E154ECD48;
        Wed, 25 Sep 2019 04:55:12 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:55:10 +0200 (CEST)
Message-Id: <20190925.135510.1792420576895991388.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: he: clean up an indentation issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190922114216.10158-1-colin.king@canonical.com>
References: <20190922114216.10158-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:55:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Sun, 22 Sep 2019 13:42:16 +0200

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a statement that is indented one level too many, remove
> the extraneous tab.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
