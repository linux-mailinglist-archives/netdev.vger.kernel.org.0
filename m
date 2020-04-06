Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E790319FB6B
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgDFR00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:26:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgDFR0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 13:26:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66E5615DA672F;
        Mon,  6 Apr 2020 10:26:25 -0700 (PDT)
Date:   Mon, 06 Apr 2020 10:26:24 -0700 (PDT)
Message-Id: <20200406.102624.1004066216541067473.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     antoine.tenart@bootlin.com, dbogdanov@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] macsec: fix NULL dereference in
 macsec_upd_offload()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <74490212072a970d0b65114644f90b1c06c68402.1586165752.git.dcaratti@redhat.com>
References: <74490212072a970d0b65114644f90b1c06c68402.1586165752.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Apr 2020 10:26:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Mon,  6 Apr 2020 11:38:29 +0200

> macsec_upd_offload() gets the value of MACSEC_OFFLOAD_ATTR_TYPE
> without checking its presence in the request message, and this causes
> a NULL dereference. Fix it rejecting any configuration that does not
> include this attribute.
> 
> Reported-and-tested-by: syzbot+7022ab7c383875c17eff@syzkaller.appspotmail.com
> Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied.
