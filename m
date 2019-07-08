Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E476362C21
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfGHWvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:51:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59754 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfGHWvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:51:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E4A412DAD56E;
        Mon,  8 Jul 2019 15:51:13 -0700 (PDT)
Date:   Mon, 08 Jul 2019 15:51:13 -0700 (PDT)
Message-Id: <20190708.155113.958574804480165515.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, ast@kernel.org
Subject: Re: [PATCH net-next V2] MAINTAINERS: Add page_pool maintainer entry
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156233140902.25371.7033961410347587264.stgit@carbon>
References: <156233140902.25371.7033961410347587264.stgit@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 15:51:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 05 Jul 2019 14:57:55 +0200

> In this release cycle the number of NIC drivers using page_pool
> will likely reach 4 drivers.  It is about time to add a maintainer
> entry.  Add myself and Ilias.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
> V2: Ilias also volunteered to co-maintain over IRC

Applied.
