Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E51BDB41
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 11:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfIYJke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 05:40:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfIYJke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 05:40:34 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E0731549287F;
        Wed, 25 Sep 2019 02:40:32 -0700 (PDT)
Date:   Wed, 25 Sep 2019 11:40:31 +0200 (CEST)
Message-Id: <20190925.114031.379108392028630817.davem@davemloft.net>
To:     bruno@wolff.to
Cc:     Jason@zx2c4.com, wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: WireGuard to port to existing Crypto API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925091700.GA9970@wolff.to>
References: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
        <20190925091700.GA9970@wolff.to>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 02:40:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruno Wolff III <bruno@wolff.to>
Date: Wed, 25 Sep 2019 04:17:00 -0500

> Are there going to be two branches, one for using the current API and
> one using Zinc?

This is inapproprate to even discuss at this point.

Let's see what the crypto based stuff looks like, evaluate it,
and then decide how to proceed forward.

Thank you.
