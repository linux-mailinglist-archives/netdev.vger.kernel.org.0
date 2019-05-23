Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8B628392
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbfEWQ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:28:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48508 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730957AbfEWQ21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:28:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC6D61509BADB;
        Thu, 23 May 2019 09:28:25 -0700 (PDT)
Date:   Thu, 23 May 2019 09:28:25 -0700 (PDT)
Message-Id: <20190523.092825.2184612182055559835.davem@davemloft.net>
To:     yash.shah@sifive.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, ynezz@true.cz, paul.walmsley@sifive.com,
        sachin.ghadi@sifive.com
Subject: Re: [PATCH 0/2] net: macb: Add support for SiFive FU540-C000
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:28:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please be consistent in your subsystem prefixes used in your Subject lines.
You use "net: macb:" then "net/macb:"  Really, plain "macb: " is sufficient.

Thank you.
