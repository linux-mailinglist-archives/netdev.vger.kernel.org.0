Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4AC5A0C2A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfH1VGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:06:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfH1VGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:06:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60C3C1539AF06;
        Wed, 28 Aug 2019 14:06:47 -0700 (PDT)
Date:   Wed, 28 Aug 2019 14:06:44 -0700 (PDT)
Message-Id: <20190828.140644.534529249197568915.davem@davemloft.net>
To:     yash.shah@sifive.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        paul.walmsley@sifive.com, ynezz@true.cz, sachin.ghadi@sifive.com
Subject: Re: [PATCH v2 0/2] Update ethernet compatible string for SiFive
 FU540
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566882364-23891-1-git-send-email-yash.shah@sifive.com>
References: <1566882364-23891-1-git-send-email-yash.shah@sifive.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 14:06:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yash Shah <yash.shah@sifive.com>
Date: Tue, 27 Aug 2019 10:36:02 +0530

> This patch series renames the compatible property to a more appropriate
> string. The patchset is based on Linux-5.3-rc6 and tested on SiFive
> Unleashed board

You should always base changes off of "net" or "net-next" and be explicitly
in your Subject lines which of those two trees your changes are for f.e.:

	Subject: [PATCH v2 net-next N/M] ...

> 
> Change history:
> Since v1:
> - Dropped PATCH3 because it's already merged
> - Change the reference url in the patch descriptions to point to a
>   'lore.kernel.org' link instead of 'lkml.org'

Series applied to 'net'.
