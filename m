Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9524A1A3889
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgDIRDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:03:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33096 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgDIRDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:03:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1445128BEBFA;
        Thu,  9 Apr 2020 10:03:14 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:03:11 -0700 (PDT)
Message-Id: <20200409.100311.2093921025865714024.davem@davemloft.net>
To:     l.rubusch@gmail.com
Cc:     jiri@mellanox.com, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Documentation: devlink: fix broken link warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200408220931.27532-1-l.rubusch@gmail.com>
References: <20200408220931.27532-1-l.rubusch@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:03:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Wed,  8 Apr 2020 22:09:31 +0000

> At 'make htmldocs' the following warning is thrown:
> 
> Documentation/networking/devlink/devlink-trap.rst:302:
> WARNING: undefined label: generic-packet-trap-groups
> 
> Fixes the warning by setting the label to the specified header,
> within the same document.
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Applied, thank you.
