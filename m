Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6807095D
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbfGVTLJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jul 2019 15:11:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47978 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfGVTLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:11:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7ECBC15258BA8;
        Mon, 22 Jul 2019 12:11:07 -0700 (PDT)
Date:   Mon, 22 Jul 2019 12:11:07 -0700 (PDT)
Message-Id: <20190722.121107.493176692915633338.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, lorenzo@google.com,
        reminv@google.com, raorn@raorn.name
Subject: Re: [PATCH] net-ipv6-ndisc: add support for RFC7710 RA Captive
 Portal Identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190719063003.10684-1-zenczykowski@gmail.com>
References: <20190719063003.10684-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 12:11:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Thu, 18 Jul 2019 23:30:03 -0700

> From: Maciej ¯enczykowski <maze@google.com>
> 
> This is trivial since we already have support for the entirely
> identical (from the kernel's point of view) RDNSS and DNSSL that
> also contain opaque data that needs to be passed down to userspace.
> 
> As specified in RFC7710, Captive Portal option contains a URL.
> 8-bit identifier of the option type as assigned by the IANA is 37.
> This option should also be treated as userland.
> 
> Hence, treat ND option 37 as userland (Captive Portal support)
> 
> See:
>   https://tools.ietf.org/html/rfc7710
>   https://www.iana.org/assignments/icmpv6-parameters/icmpv6-parameters.xhtml
> 
> Fixes: e35f30c131a56
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied to net-next.
