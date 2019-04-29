Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62889ECB5
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfD2WYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:24:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbfD2WYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:24:21 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C214314692ABD;
        Mon, 29 Apr 2019 15:24:20 -0700 (PDT)
Date:   Mon, 29 Apr 2019 18:24:19 -0400 (EDT)
Message-Id: <20190429.182419.1714394273539373115.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, ebiederm@xmission.com, willemb@google.com
Subject: Re: [PATCH net] ipv6: invert flowlabel sharing check in process
 and user mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190425160654.211972-1-willemdebruijn.kernel@gmail.com>
References: <20190425160654.211972-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 15:24:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 25 Apr 2019 12:06:54 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> A request for a flowlabel fails in process or user exclusive mode must
> fail if the caller pid or uid does not match. Invert the test.
> 
> Previously, the test was unsafe wrt PID recycling, but indeed tested
> for inequality: fl1->owner != fl->owner
> 
> Fixes: 4f82f45730c68 ("net ip6 flowlabel: Make owner a union of struct pid* and kuid_t")
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks Willem.
