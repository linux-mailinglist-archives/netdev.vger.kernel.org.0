Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF31CBCA63
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbfIXOil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:38:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfIXOik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 10:38:40 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C43E15269EC4;
        Tue, 24 Sep 2019 07:38:38 -0700 (PDT)
Date:   Tue, 24 Sep 2019 16:38:36 +0200 (CEST)
Message-Id: <20190924.163836.698259609196514149.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, jreuter@yaina.de,
        ralf@linux-mips.org, alex.aring@gmail.com,
        stefan@datenfreihafen.org, orinimron123@gmail.com
Subject: Re: [PATCH 0/5] Raw socket cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190920073549.517481-1-gregkh@linuxfoundation.org>
References: <20190920073549.517481-1-gregkh@linuxfoundation.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 07:38:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 20 Sep 2019 09:35:44 +0200

> Ori Nimron pointed out that there are a number of places in the kernel
> where you can create a raw socket, without having to have the
> CAP_NET_RAW permission.
> 
> To resolve this, here's a short patch series to test these odd and old
> protocols for this permission before allowing the creation to succeed
> 
> All patches are currently against the net tree.

Applied and queued up for -stable.
