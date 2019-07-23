Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876D270E8F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 03:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbfGWBRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 21:17:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfGWBRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 21:17:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46D5A15305A03;
        Mon, 22 Jul 2019 18:17:32 -0700 (PDT)
Date:   Mon, 22 Jul 2019 18:17:31 -0700 (PDT)
Message-Id: <20190722.181731.1661840445301919861.davem@davemloft.net>
To:     skunberg.kelsey@gmail.com
Cc:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@helgaas.com, rjw@rjwysocki.net,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] drivers: net: xgene: Remove acpi_has_method() calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
References: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 18:17:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kelsey Skunberg <skunberg.kelsey@gmail.com>
Date: Sun, 21 Jul 2019 21:04:01 -0600

> +			 		      "_RST", NULL, NULL);
               ^^^^

SPACE before TAB in indentation.

> +				 	      "_RST", NULL, NULL);
                            ^^^^^^

Likewise.

GIT even warns about this when I try to apply this patch.

Please fix this.

Thank you.
