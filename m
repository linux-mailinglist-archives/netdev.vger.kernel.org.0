Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225AF250E19
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgHYBOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgHYBOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:14:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EA9C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 18:14:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 042A51295778A;
        Mon, 24 Aug 2020 17:57:55 -0700 (PDT)
Date:   Mon, 24 Aug 2020 18:14:41 -0700 (PDT)
Message-Id: <20200824.181441.1227869990448071497.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] sfc: fix boolreturn.cocci warning and rename
 function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7c627a43-4339-cb08-c051-340100466033@solarflare.com>
References: <7c627a43-4339-cb08-c051-340100466033@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:57:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Mon, 24 Aug 2020 16:18:51 +0100

> check_fcs() was returning bool as 0/1, which was a sign that the sense
>  of the function was unclear: false was good, which doesn't really match
>  a name like 'check_$thing'.  So rename it to ef100_has_fcs_error(), and
>  use proper booleans in the return statements.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied, thank you.
