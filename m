Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD1974197
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfGXWnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:43:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfGXWnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:43:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A5B31543C8C1;
        Wed, 24 Jul 2019 15:43:51 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:43:50 -0700 (PDT)
Message-Id: <20190724.154350.1802484068909792335.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: use helper skb_ensure_writable in
 skb_checksum_help and skb_crc32c_csum_help
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d5791755-5b1e-6dc6-fa9d-da3bb0353847@gmail.com>
References: <d5791755-5b1e-6dc6-fa9d-da3bb0353847@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:43:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 24 Jul 2019 23:47:49 +0200

> Instead of open-coding making the checksum writable we can use an
> appropriate helper. skb_ensure_writable is a candidate, however we
> might also use skb_header_unclone. Hints welcome.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

FWIW these conversions look accurate to me.

The only real difference is the perhaps unnecessary pskb_may_pull()
check.
