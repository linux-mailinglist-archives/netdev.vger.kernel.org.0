Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975A080399
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 02:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbfHCA5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 20:57:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387633AbfHCA5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 20:57:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CEC221265125D;
        Fri,  2 Aug 2019 17:57:33 -0700 (PDT)
Date:   Fri, 02 Aug 2019 17:57:33 -0700 (PDT)
Message-Id: <20190802.175733.1007297377658559404.davem@davemloft.net>
To:     xywang.sjtu@sjtu.edu.cn
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/ethernet/qlogic/qed: force the string buffer
 NULL-terminated
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731081542.14178-1-xywang.sjtu@sjtu.edu.cn>
References: <20190731081542.14178-1-xywang.sjtu@sjtu.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 17:57:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
Date: Wed, 31 Jul 2019 16:15:42 +0800

> strncpy() does not ensure NULL-termination when the input string
> size equals to the destination buffer size 30.
> The output string is passed to qed_int_deassertion_aeu_bit()
> which calls DP_INFO() and relies NULL-termination.
> 
> Use strlcpy instead. The other conditional branch above strncpy()
> needs no fix as snprintf() ensures NULL-termination.
> 
> This issue is identified by a Coccinelle script.
> 
> Signed-off-by: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>

Applied.
