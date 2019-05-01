Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7985010A11
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfEAPbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:31:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfEAPbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:31:10 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0881F1473AE57;
        Wed,  1 May 2019 08:31:09 -0700 (PDT)
Date:   Wed, 01 May 2019 11:31:09 -0400 (EDT)
Message-Id: <20190501.113109.1671453363452745363.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, David.Laight@aculab.com, willemb@google.com
Subject: Re: [PATCH net v2] packet: validate msg_namelen in send directly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429155318.20433-1-willemdebruijn.kernel@gmail.com>
References: <20190429155318.20433-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 08:31:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 29 Apr 2019 11:53:18 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Packet sockets in datagram mode take a destination address. Verify its
> length before passing to dev_hard_header.
> 
> Prior to 2.6.14-rc3, the send code ignored sll_halen. This is
> established behavior. Directly compare msg_namelen to dev->addr_len.
> 
> Change v1->v2: initialize addr in all paths
> 
> Fixes: 6b8d95f1795c4 ("packet: validate address length if non-zero")
> Suggested-by: David Laight <David.Laight@aculab.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable.
