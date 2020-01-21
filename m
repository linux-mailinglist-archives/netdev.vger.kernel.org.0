Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99AF143FA5
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAUOf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:35:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgAUOf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:35:29 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CA15153A4B96;
        Tue, 21 Jan 2020 06:35:26 -0800 (PST)
Date:   Tue, 21 Jan 2020 15:35:22 +0100 (CET)
Message-Id: <20200121.153522.1248409324581446114.davem@davemloft.net>
To:     gautamramk@gmail.com
Cc:     netdev@vger.kernel.org, tahiliani@nitk.edu.in, jhs@mojatatu.com,
        dave.taht@gmail.com, toke@redhat.com, kuba@kernel.org,
        stephen@networkplumber.org, lesliemonis@gmail.com
Subject: Re: [PATCH net-next v4 05/10] pie: rearrange structure members and
 their initializations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121141250.26989-6-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
        <20200121141250.26989-6-gautamramk@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 06:35:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gautamramk@gmail.com
Date: Tue, 21 Jan 2020 19:42:44 +0530

> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> 
> Rearrange the members of the structures such that they appear in
> order of their types. Also, change the order of their
> initializations to match the order in which they appear in the
> structures. This improves the code's readability and consistency.
> 
> Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>

What matters for structure member ordering is dense packing and
grouping commonly-used-together elements for performance.

"order of their types" are none of those things.
