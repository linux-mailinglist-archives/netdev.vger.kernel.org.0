Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329394A77C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfFRQsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:48:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729423AbfFRQsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:48:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DF711509C5C8;
        Tue, 18 Jun 2019 09:47:59 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:47:59 -0700 (PDT)
Message-Id: <20190618.094759.539007481404905339.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     gregkh@linuxfoundation.org, naresh.kamboju@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, fklassen@appneta.com
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAF=yD-JnTHdDE8K-EaJM2fH9awvjAmOJkoZbtU+Wi58pPnyAxw@mail.gmail.com>
References: <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
        <20190618161036.GA28190@kroah.com>
        <CAF=yD-JnTHdDE8K-EaJM2fH9awvjAmOJkoZbtU+Wi58pPnyAxw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 09:47:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 18 Jun 2019 12:37:33 -0400

> Specific to the above test, I can add a check command testing
> setsockopt SO_ZEROCOPY  return value. AFAIK kselftest has no explicit
> way to denote "skipped", so this would just return "pass". Sounds a
> bit fragile, passing success when a feature is absent.

Especially since the feature might be absent because the 'config'
template forgot to include a necessary Kconfig option.
