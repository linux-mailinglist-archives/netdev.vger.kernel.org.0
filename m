Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CB924E2BE
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHUVem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgHUVek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:34:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052B5C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:34:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4937F128B34FA;
        Fri, 21 Aug 2020 14:17:52 -0700 (PDT)
Date:   Fri, 21 Aug 2020 14:34:37 -0700 (PDT)
Message-Id: <20200821.143437.434851727123776607.davem@davemloft.net>
To:     vinay.yadav@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        herbert@gondor.apana.org.au, secdev@chelsio.com
Subject: Re: [PATCH net-next 0/2] crypto/chelsio: Restructure chelsio's
 inline crypto drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819140121.20175-1-vinay.yadav@chelsio.com>
References: <20200819140121.20175-1-vinay.yadav@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Aug 2020 14:17:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Date: Wed, 19 Aug 2020 19:31:19 +0530

> This series of patches will move chelsio's inline crypto
> drivers (ipsec and chtls) from "drivers/crypto/chelsio/"
> to "drivers/net/ethernet/chelsio/inline_crypto/"
> for better maintenance.
> 
> Patch1: moves out chtls.
> Patch2: moves out inline ipsec, applies on top of Patch1.

Series applied, thank you.
