Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7091CBB3C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgEHXXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbgEHXXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:23:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9249C061A0C;
        Fri,  8 May 2020 16:23:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14FAD128D4B47;
        Fri,  8 May 2020 16:23:05 -0700 (PDT)
Date:   Fri, 08 May 2020 16:23:02 -0700 (PDT)
Message-Id: <20200508.162302.1254541876589538843.davem@davemloft.net>
To:     ashwinh@vmware.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH 0/2] Backport to 4.19 - sctp: fully support memory
 accounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <F958DF99-EF43-4522-87AC-55C24ED93D4F@vmware.com>
References: <cover.1588242081.git.ashwinh@vmware.com>
        <F958DF99-EF43-4522-87AC-55C24ED93D4F@vmware.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 May 2020 16:23:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ashwin H <ashwinh@vmware.com>
Date: Fri, 8 May 2020 17:24:40 +0000

> Could you please let me know why this is not applicable to 4.19 ?

No, I cannot.  I only handle the most recent two -stable releases, and
4.19 is beyond that.

Thank you.
