Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C31A1C9FB7
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEHAkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEHAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:40:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF04C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:40:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24B2B11937761;
        Thu,  7 May 2020 17:40:19 -0700 (PDT)
Date:   Thu, 07 May 2020 17:40:17 -0700 (PDT)
Message-Id: <20200507.174017.1527194534722347929.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] hsr: hsr code refactoring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506154634.12352-1-ap420073@gmail.com>
References: <20200506154634.12352-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 17:40:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Wed,  6 May 2020 15:46:34 +0000

> There are some unnecessary routine in the hsr module.
> This patch removes these routines.
> 
> The first patch removes incorrect comment.
> The second patch removes unnecessary WARN_ONCE() macro.

Series applied, thanks.
