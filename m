Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDE01DA112
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgESTjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:39:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05583C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 12:39:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EB71128B9FFB;
        Tue, 19 May 2020 12:39:38 -0700 (PDT)
Date:   Tue, 19 May 2020 12:39:35 -0700 (PDT)
Message-Id: <20200519.123935.2150930371716574515.davem@davemloft.net>
To:     todd.malsbary@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, cpaasch@apple.com,
        matthieu.baerts@tessares.net
Subject: Re: [PATCH net] mptcp: use rightmost 64 bits in ADD_ADDR HMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519164534.147058-1-todd.malsbary@linux.intel.com>
References: <20200519164534.147058-1-todd.malsbary@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 12:39:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Todd Malsbary <todd.malsbary@linux.intel.com>
Date: Tue, 19 May 2020 09:45:34 -0700

> This changes the HMAC used in the ADD_ADDR option from the leftmost 64
> bits to the rightmost 64 bits as described in RFC 8684, section 3.4.1.
> 
> This issue was discovered while adding support to packetdrill for the
> ADD_ADDR v1 option.
> 
> Fixes: 3df523ab582c ("mptcp: Add ADD_ADDR handling")
> Signed-off-by: Todd Malsbary <todd.malsbary@linux.intel.com>
> Acked-by: Christoph Paasch <cpaasch@apple.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied, thanks.
