Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2FF190488
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgCXEgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:36:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXEgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:36:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EDFF1577D95E;
        Mon, 23 Mar 2020 21:36:50 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:36:49 -0700 (PDT)
Message-Id: <20200323.213649.309447918206966603.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, sd@queasysnail.net, andrew@lunn.ch,
        willemb@google.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net v2] macsec: restrict to ethernet devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200322175113.91143-1-willemdebruijn.kernel@gmail.com>
References: <20200322175113.91143-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:36:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sun, 22 Mar 2020 13:51:13 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Only attach macsec to ethernet devices.
> 
> Syzbot was able to trigger a KMSAN warning in macsec_handle_frame
> by attaching to a phonet device.
> 
> Macvlan has a similar check in macvlan_port_create.
> 
> v1->v2
>   - fix commit message typo
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable.
