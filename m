Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A32101175
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 03:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKSCv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 21:51:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfKSCv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 21:51:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C0491511BACF;
        Mon, 18 Nov 2019 18:51:27 -0800 (PST)
Date:   Mon, 18 Nov 2019 18:51:25 -0800 (PST)
Message-Id: <20191118.185125.2116597513753649065.davem@davemloft.net>
To:     adisuresh@google.com
Cc:     netdev@vger.kernel.org, csully@google.com
Subject: Re: [PATCH net v3] gve: fix dma sync bug where not all pages synced
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119024706.161479-1-adisuresh@google.com>
References: <20191119024706.161479-1-adisuresh@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 18:51:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adi Suresh <adisuresh@google.com>
Date: Mon, 18 Nov 2019 18:47:06 -0800

> Fixes: 4a55e8417c5d ("gve: Fixes DMA synchronization")

This commit doesn't exist in any tree.

[davem@localhost net]$ git describe 4a55e8417c5d
fatal: Not a valid object name 4a55e8417c5d

The gve patch submission process is getting very frustrating for me,
just FYI...
