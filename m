Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2066827180D
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgITVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITVKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:10:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C912C061755;
        Sun, 20 Sep 2020 14:10:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FFCE13BC86AD;
        Sun, 20 Sep 2020 13:54:04 -0700 (PDT)
Date:   Sun, 20 Sep 2020 14:10:23 -0700 (PDT)
Message-Id: <20200920.141023.66488986181172964.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     tgraf@suug.ch, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rhashtable: fix indentation of a continue statement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918215126.49236-1-colin.king@canonical.com>
References: <20200918215126.49236-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 13:54:04 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 18 Sep 2020 22:51:26 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> A continue statement is indented incorrectly, add in the missing
> tab.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
