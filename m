Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5C4FD2DF
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKOCRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:17:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfKOCRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:17:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7C7514B7A0C5;
        Thu, 14 Nov 2019 18:17:21 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:17:21 -0800 (PST)
Message-Id: <20191114.181721.1380376470346120906.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 00/11] s390/qeth: updates 2019-11-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114101924.29558-1-jwi@linux.ibm.com>
References: <20191114101924.29558-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:17:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 14 Nov 2019 11:19:13 +0100

> please apply the following qeth patches to net-next.
> Along with the usual cleanups, this
> (1) reduces collateral packet loss in the RX path when dealing with
>     bad packets and/or allocation errors, and
> (2) simplifies how the L3 driver deals with mcast IP addresses.

Series applied, thanks.
