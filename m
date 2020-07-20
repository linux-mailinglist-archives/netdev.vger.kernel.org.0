Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFF12272B5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgGTXUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGTXUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:20:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C65C061794;
        Mon, 20 Jul 2020 16:20:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E8A811E8EC0A;
        Mon, 20 Jul 2020 16:20:16 -0700 (PDT)
Date:   Mon, 20 Jul 2020 16:20:13 -0700 (PDT)
Message-Id: <20200720.162013.456211151711627380.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     hch@lst.de, kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 24/24] net: pass a sockptr_t into ->setsockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <deaedc6d-edde-68da-50e8-6474ca818191@datenfreihafen.org>
References: <20200720124737.118617-1-hch@lst.de>
        <20200720124737.118617-25-hch@lst.de>
        <deaedc6d-edde-68da-50e8-6474ca818191@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 16:20:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Mon, 20 Jul 2020 16:19:38 +0200

> For the ieee802154 part:
> 
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

Please do not quote an entire patch just to add an ACK, trim it just
to the commit message, or even less.

Thank you.
