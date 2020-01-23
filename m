Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06406146933
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgAWNfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:35:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgAWNfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:35:04 -0500
Received: from localhost (unknown [83.137.1.205])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9114F1570D619;
        Thu, 23 Jan 2020 05:35:01 -0800 (PST)
Date:   Thu, 23 Jan 2020 14:34:27 +0100 (CET)
Message-Id: <20200123.143427.929752874130441642.davem@davemloft.net>
To:     kristian.evensen@gmail.com
Cc:     netdev@vger.kernel.org, dvyukov@google.com
Subject: Re: [PATCH net] fou: Fix IPv6 netlink policy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123122018.27805-1-kristian.evensen@gmail.com>
References: <20200123122018.27805-1-kristian.evensen@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 05:35:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>
Date: Thu, 23 Jan 2020 13:20:18 +0100

> When submitting v2 of "fou: Support binding FoU socket" (1713cb37bf67),
> I accidentally sent the wrong version of the patch and one fix was
> missing. In the initial version of the patch, as well as the version 2
> that I submitted, I incorrectly used ".type" for the two V6-attributes.
> The correct is to use ".len".
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Fixes: 1713cb37bf67 ("fou: Support binding FoU socket")
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>

Applied and queued up for -stable, thanks.
