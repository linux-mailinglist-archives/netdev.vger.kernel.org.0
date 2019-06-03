Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211A233BD3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfFCXTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:19:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfFCXTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:19:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D62A9136DF6FB;
        Mon,  3 Jun 2019 16:19:21 -0700 (PDT)
Date:   Mon, 03 Jun 2019 16:19:19 -0700 (PDT)
Message-Id: <20190603.161919.1231780626602694372.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        richardcochran@gmail.com, john.stultz@linaro.org,
        tglx@linutronix.de, sboyd@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/10] PTP support for the SJA1105 DSA
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hoOO1apNWXer01LE572pgdnVdmf_e7-Tnp6jgJuTPbGHg@mail.gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
        <CA+h21hoOO1apNWXer01LE572pgdnVdmf_e7-Tnp6jgJuTPbGHg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 16:19:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 4 Jun 2019 02:13:16 +0300

> This series appears in patchwork as "superseded":
> https://patchwork.ozlabs.org/project/netdev/list/?series=111356&state=*
> Perhaps it got mixed up with another one?

No, there was a comment in this thread that there would be a respin with
some changes.  Anticipating that respin, I mark this as superseded.
