Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE491190A0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfLJTcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:32:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJTcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:32:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D271A146E9458;
        Tue, 10 Dec 2019 11:32:16 -0800 (PST)
Date:   Tue, 10 Dec 2019 11:32:16 -0800 (PST)
Message-Id: <20191210.113216.1897128321839303084.davem@davemloft.net>
To:     mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, jcfaracco@gmail.com,
        netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [PATCH net-next v11 0/3] netdev: ndo_tx_timeout cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210130837.47913-1-mst@redhat.com>
References: <20191210130837.47913-1-mst@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 11:32:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 10 Dec 2019 08:08:58 -0500

> Sorry about the churn, v10 was based on net - not on net-next
> by mistake.

Ugh sorry, I just saw this.  vger is sending postings massively out of
order today.

Ignore my previous reply to #1 :-)
