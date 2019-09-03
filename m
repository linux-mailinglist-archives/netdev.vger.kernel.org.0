Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38604A7739
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfICWp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:45:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfICWp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:45:57 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AB9014B7A8B6;
        Tue,  3 Sep 2019 15:45:55 -0700 (PDT)
Date:   Tue, 03 Sep 2019 15:45:53 -0700 (PDT)
Message-Id: <20190903.154553.508717744184330290.davem@davemloft.net>
To:     sirus.shahini@gmail.com
Cc:     eric.dumazet@gmail.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        arnd@arndb.de, netdev@vger.kernel.org, sirus@cs.utah.edu
Subject: Re: [PATCH] Clock-independent TCP ISN generation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e02c0aac-05c5-e0a4-9ae1-57685a0c3160@gmail.com>
References: <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
        <492bb69e-0722-f6fc-077a-2348edf081d8@gmail.com>
        <e02c0aac-05c5-e0a4-9ae1-57685a0c3160@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Sep 2019 15:45:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cyrus Sh <sirus.shahini@gmail.com>
Date: Tue, 3 Sep 2019 10:27:41 -0600

> It's up to you whether to want to keep using a problematic code that
> may endanger users or want to do something about it since we won't
> insist on having a patch accepted.

At least our problematic code, unlike your patch, compiles.
