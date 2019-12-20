Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BE9127305
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfLTBrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:47:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfLTBrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:47:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 92D0B1540F21F;
        Thu, 19 Dec 2019 17:47:08 -0800 (PST)
Date:   Thu, 19 Dec 2019 17:47:08 -0800 (PST)
Message-Id: <20191219.174708.2100806310501253704.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net-next 0/3] nfp: tls: implement the stream sync RX
 resync
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217221202.12611-1-jakub.kicinski@netronome.com>
References: <20191217221202.12611-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 17:47:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 17 Dec 2019 14:11:59 -0800

> This small series adds support for using the device
> in stream scan RX resync mode which improves the RX
> resync success rate. Without stream scan it's pretty
> much impossible to successfully resync a continuous
> stream.

Series applied, thanks.
