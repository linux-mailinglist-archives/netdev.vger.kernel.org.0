Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC02326388C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgIIVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIIVfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:35:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE6CC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 14:35:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 678BC1298C8CA;
        Wed,  9 Sep 2020 14:19:00 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:35:46 -0700 (PDT)
Message-Id: <20200909.143546.587432993275749182.davem@davemloft.net>
To:     vinay.yadav@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next 0/6] chelsio/chtls:Fix inline tls bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909202540.22052-1-vinay.yadav@chelsio.com>
References: <20200909202540.22052-1-vinay.yadav@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 14:19:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Date: Thu, 10 Sep 2020 01:55:34 +0530

> Sending bug fixes in net-next tree because chtls directory restructure
> changes is available only in net-next not in net.

Since when is file movement a reason to not submit bugs to the correct
tree?

I'm not doing this sorry, please submit bug fixes to the correct location.
