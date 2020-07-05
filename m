Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9C821495B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGEAqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgGEAqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 20:46:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D10C061794;
        Sat,  4 Jul 2020 17:46:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE2BE157A9A2D;
        Sat,  4 Jul 2020 17:46:44 -0700 (PDT)
Date:   Sat, 04 Jul 2020 17:46:41 -0700 (PDT)
Message-Id: <20200704.174641.1885452358119891777.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, linux-hams@vger.kernel.org, wg@grandegger.com,
        mkl@pengutronix.de, linux-can@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        dhowells@redhat.com, linux-afs@lists.infradead.org
Subject: Re: [PATCH 0/7] Documentation: networking: eliminate doubled words
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703224115.29769-1-rdunlap@infradead.org>
References: <20200703224115.29769-1-rdunlap@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 17:46:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Fri,  3 Jul 2020 15:41:08 -0700

> Drop all duplicated words in Documentation/networking/ files.

Series applied, thanks Randy.
