Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FD8254FF2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgH0UUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 16:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgH0UUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 16:20:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DF4C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 13:20:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0247912737DC2;
        Thu, 27 Aug 2020 13:03:24 -0700 (PDT)
Date:   Thu, 27 Aug 2020 13:20:10 -0700 (PDT)
Message-Id: <20200827.132010.1826967607816087414.davem@davemloft.net>
To:     antony.antony@secunet.com
Cc:     steffen.klassert@secunet.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, smueller@chronox.de,
        antony@phenome.org
Subject: Re: [PATCH ipsec-next v3] xfrm: add
 /proc/sys/core/net/xfrm_redact_secret
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827201536.GB11789@moon.secunet.de>
References: <20200820.154222.114300229292925699.davem@davemloft.net>
        <20200824060038.GA24035@moon.secunet.de>
        <20200827201536.GB11789@moon.secunet.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 13:03:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>
Date: Thu, 27 Aug 2020 22:15:36 +0200

> If there is a way to set lockdown per net namespace it would be
> better than /proc/sys/core/net/xfrm_redact_secret.

Lockmode is a whole system attribute.

As should any facility that restricts access to keying information
stored inside of the kernel.
