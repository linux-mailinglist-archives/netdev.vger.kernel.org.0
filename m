Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2930449
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfE3Vxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:53:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfE3Vxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:53:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B150B14DB38BA;
        Thu, 30 May 2019 14:44:42 -0700 (PDT)
Date:   Thu, 30 May 2019 14:44:42 -0700 (PDT)
Message-Id: <20190530.144442.1709791688381360238.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: correct zerocopy refcnt with udp MSG_MORE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529193357.73457-1-willemdebruijn.kernel@gmail.com>
References: <20190529193357.73457-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:44:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 29 May 2019 15:33:57 -0400

> Fixes: 52900d22288ed ("udp: elide zerocopy operation in hot path")

This is not a valid commit ID.
