Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C819A396
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390570AbfHVXOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:14:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731799AbfHVXOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:14:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1B051539AF15;
        Thu, 22 Aug 2019 16:14:17 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:14:17 -0700 (PDT)
Message-Id: <20190822.161417.743543513075702589.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com
Subject: Re: [PATCH net-next] net: dsa: remove bitmap operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822161728.GB1471@t480s.localdomain>
References: <20190821062423.18735-1-vivien.didelot@gmail.com>
        <20190822161728.GB1471@t480s.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 16:14:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Thu, 22 Aug 2019 16:17:28 -0400

> David, I've included this patch into a new series with other related patches,
> you can ignore this one now.

Ok, thanks for letting me know.
