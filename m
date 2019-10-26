Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BADDE5807
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 04:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfJZCS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 22:18:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfJZCS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 22:18:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED0C614B79F98;
        Fri, 25 Oct 2019 19:18:57 -0700 (PDT)
Date:   Fri, 25 Oct 2019 19:18:55 -0700 (PDT)
Message-Id: <20191025.191855.2235401668260921153.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/2] net/smc: fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023134406.66319-1-kgraul@linux.ibm.com>
References: <20191023134406.66319-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 19:18:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Wed, 23 Oct 2019 15:44:04 +0200

> Fixes for the net tree, covering a memleak when closing
> SMC fallback sockets and fix SMC-R connection establishment
> when vlan-ids are used.

Series applied, thanks.
