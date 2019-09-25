Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640C5BDB39
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 11:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfIYJjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 05:39:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33496 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfIYJjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 05:39:35 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76B5A15492860;
        Wed, 25 Sep 2019 02:39:34 -0700 (PDT)
Date:   Wed, 25 Sep 2019 11:39:28 +0200 (CEST)
Message-Id: <20190925.113928.2046484827308019751.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: WireGuard to port to existing Crypto API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
References: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 02:39:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 25 Sep 2019 10:29:45 +0200

> His viewpoint has recently solidified: in order to go upstream,
> WireGuard must port to the existing crypto API, and handle the Zinc
> project separately.

I didn't say "must" anything, I suggested this as a more smoothe
and efficient way forward.

I'm also a bit disappointed that you felt the need to so quickly
make such an explosive posting to the mailing list when we've
just spoken about this amongst ourselves only 20 minutes ago.

Please proceed in a more smoothe and considerate manner for all
parties involved.

Thank you.
