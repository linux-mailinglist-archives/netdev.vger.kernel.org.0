Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8209BA0CD0
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfH1VyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:54:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37612 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1VyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:54:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E14B8153A8789;
        Wed, 28 Aug 2019 14:54:14 -0700 (PDT)
Date:   Wed, 28 Aug 2019 14:54:14 -0700 (PDT)
Message-Id: <20190828.145414.252682465710153157.davem@davemloft.net>
To:     gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, joe@wand.net.nz,
        jpettit@ovn.org
Subject: Re: [PATCH V3 net 2/2] openvswitch: Clear the L4 portion of the
 key for "later" fragments.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566917890-22304-2-git-send-email-gvrose8192@gmail.com>
References: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
        <1566917890-22304-2-git-send-email-gvrose8192@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 14:54:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Rose <gvrose8192@gmail.com>
Date: Tue, 27 Aug 2019 07:58:10 -0700

> From: Justin Pettit <jpettit@ovn.org>
> 
> Only the first fragment in a datagram contains the L4 headers.  When the
> Open vSwitch module parses a packet, it always sets the IP protocol
> field in the key, but can only set the L4 fields on the first fragment.
> The original behavior would not clear the L4 portion of the key, so
> garbage values would be sent in the key for "later" fragments.  This
> patch clears the L4 fields in that circumstance to prevent sending those
> garbage values as part of the upcall.
> 
> Signed-off-by: Justin Pettit <jpettit@ovn.org>

Applied.
