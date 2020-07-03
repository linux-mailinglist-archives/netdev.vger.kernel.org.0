Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055D52140FA
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 23:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgGCVis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 17:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgGCVis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 17:38:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10297C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 14:38:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1024155DAB39;
        Fri,  3 Jul 2020 14:38:47 -0700 (PDT)
Date:   Fri, 03 Jul 2020 14:38:47 -0700 (PDT)
Message-Id: <20200703.143847.1757040149328578065.davem@davemloft.net>
To:     tannerlove.kernel@gmail.com
Cc:     netdev@vger.kernel.org, tannerlove@google.com, willemb@google.com
Subject: Re: [PATCH net-next] selftests/net: add ipv6 test coverage in
 rxtimestamp test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703185306.2858752-1-tannerlove.kernel@gmail.com>
References: <20200703185306.2858752-1-tannerlove.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 14:38:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove.kernel@gmail.com>
Date: Fri,  3 Jul 2020 14:53:06 -0400

> From: tannerlove <tannerlove@google.com>
> 
> Add the options --ipv4, --ipv6 to specify running over ipv4 and/or
> ipv6. If neither is specified, then run both.
> 
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied.
