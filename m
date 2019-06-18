Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B2F4ADF5
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfFRWoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 18:44:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730758AbfFRWoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 18:44:11 -0400
Received: from localhost (unknown [198.134.98.50])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 209DD12D69F76;
        Tue, 18 Jun 2019 15:44:10 -0700 (PDT)
Date:   Tue, 18 Jun 2019 18:44:09 -0400 (EDT)
Message-Id: <20190618.184409.2227845117139305004.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     gregkh@linuxfoundation.org, naresh.kamboju@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, fklassen@appneta.com
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+FuTSdrphico4044QTD_-8VbanFFJx0FJuH+vVMfuHqbphkjw@mail.gmail.com>
References: <CAF=yD-+pNrAo1wByHY6f5AZCq8xT0FDMKM-WzPkfZ36Jxj4mNg@mail.gmail.com>
        <20190618173906.GB3649@kroah.com>
        <CA+FuTSdrphico4044QTD_-8VbanFFJx0FJuH+vVMfuHqbphkjw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 15:44:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 18 Jun 2019 14:58:26 -0400

> I see that in similar such cases that use the test harness
> (ksft_test_result_skip) the overall test returns success as long as
> all individual cases return either success or skip.
> 
> I think it's preferable to return KSFT_SKIP if any of the cases did so
> (and none returned an error). I'll do that unless anyone objects.

I guess this is a question of semantics.

I mean, if you report skip at the top level does that mean that all
sub tests were skipped?  People may think so... :)

