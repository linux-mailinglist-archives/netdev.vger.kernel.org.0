Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A87389643
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfHLE1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:27:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfHLE1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:27:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F8121409711C;
        Sun, 11 Aug 2019 21:27:30 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:27:29 -0700 (PDT)
Message-Id: <20190811.212729.1591560042691137262.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 0/7] net: dsa: mv88e6xxx: prepare Wait Bit
 operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809224759.5743-1-vivien.didelot@gmail.com>
References: <20190809224759.5743-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:27:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Fri,  9 Aug 2019 18:47:52 -0400

> The Remote Management Interface has its own implementation of a Wait
> Bit operation, which requires a bit number and a value to wait for.
> 
> In order to prepare the introduction of this implementation, rework the
> code waiting for bits and masks in mv88e6xxx to match this signature.
> 
> This has the benefit to unify the implementation of wait routines while
> removing obsolete wait and update functions and also reducing the code.

Series applied, thanks.
