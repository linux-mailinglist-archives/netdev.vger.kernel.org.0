Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4090A9C32
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731710AbfIEHwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 03:52:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731162AbfIEHwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 03:52:02 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94A2D15385198;
        Thu,  5 Sep 2019 00:52:00 -0700 (PDT)
Date:   Thu, 05 Sep 2019 00:51:58 -0700 (PDT)
Message-Id: <20190905.005158.375993170063792993.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net-next 0/5] net/tls: minor cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190903043106.27570-1-jakub.kicinski@netronome.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 00:52:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon,  2 Sep 2019 21:31:01 -0700

> This set is a grab bag of TLS cleanups accumulated in my tree
> in an attempt to avoid merge problems with net. Nothing stands
> out. First patch dedups context information. Next control path
> locking is very slightly optimized. Fourth patch cleans up
> ugly #ifdefs.

Series applied, thanks.
