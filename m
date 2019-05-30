Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB9930448
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfE3Vxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:53:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfE3Vxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:53:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B069C14DB1C74;
        Thu, 30 May 2019 14:34:45 -0700 (PDT)
Date:   Thu, 30 May 2019 14:34:45 -0700 (PDT)
Message-Id: <20190530.143445.293369224441787273.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: avoid indirect calls in L4 checksum
 calculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529151348.31311-1-mcroce@redhat.com>
References: <20190529151348.31311-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:34:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Wed, 29 May 2019 17:13:48 +0200

> Commit 283c16a2dfd3 ("indirect call wrappers: helpers to speed-up
> indirect calls of builtin") introduces some macros to avoid doing
> indirect calls.
> 
> Use these helpers to remove two indirect calls in the L4 checksum
> calculation for devices which don't have hardware support for it.
> 
> As a test I generate packets with pktgen out to a dummy interface
> with HW checksumming disabled, to have the checksum calculated in
> every sent packet.
> The packet rate measured with an i7-6700K CPU and a single pktgen
> thread raised from 6143 to 6608 Kpps, an increase by 7.5%
> 
> Suggested-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied.
