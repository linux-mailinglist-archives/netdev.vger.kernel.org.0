Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1042E7D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfFLSVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:21:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFLSVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:21:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 710271528383F;
        Wed, 12 Jun 2019 11:21:15 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:21:14 -0700 (PDT)
Message-Id: <20190612.112114.818829552569501636.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] tcp: add optional per socket transmit delay
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612.110344.817827105748265826.davem@davemloft.net>
References: <20190611030334.138942-1-edumazet@google.com>
        <20190612.110344.817827105748265826.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:21:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 12 Jun 2019 11:03:44 -0700 (PDT)

> Applied to net-next and build testing.

Missing symbol export it seems...

ERROR: "tcp_tx_delay_enabled" [net/ipv6/ipv6.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:91: __modpost] Error 1
