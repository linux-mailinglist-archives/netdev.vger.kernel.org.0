Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7383D679
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406832AbfFKTHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:07:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388777AbfFKTHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:07:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D8EB15255007;
        Tue, 11 Jun 2019 12:07:53 -0700 (PDT)
Date:   Tue, 11 Jun 2019 12:07:52 -0700 (PDT)
Message-Id: <20190611.120752.609112346564383333.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     gnault@redhat.com, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] Don't assume linear buffers in error handlers
 for VXLAN and GENEVE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1560205281.git.sbrivio@redhat.com>
References: <cover.1560205281.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 12:07:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Tue, 11 Jun 2019 00:27:04 +0200

> Guillaume noticed the same issue fixed by commit 26fc181e6cac ("fou, fou6:
> do not assume linear skbs") for fou and fou6 is also present in VXLAN and
> GENEVE error handlers: we can't assume linear buffers there, we need to
> use pskb_may_pull() instead.

Series applied and queued up for -stable, thanks for fixing this.
