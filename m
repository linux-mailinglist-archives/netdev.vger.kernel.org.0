Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164A322891D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgGUT1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729497AbgGUT1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 15:27:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E401C20717;
        Tue, 21 Jul 2020 19:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595359626;
        bh=fozw1cpObQL1pAWpim7tPz9oo3n4tbKaXzap/Tq2o1g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yhuqhb/fVjD5L0foAUri/jCRg+GUY9I1RUFF85QRp2q/A4ik/wYPEQPe3pEEGsJBK
         y7owgxUSXCaaKsAldgKA0q9Ohz5hI2JDku8B/rfU17DTo477cqyon5Yjbzq0hynQ3q
         dhevdqIs/Hbatjg1MYMkQtAiksNcQaEdW2aPG3l0=
Date:   Tue, 21 Jul 2020 12:27:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net v2] netdevsim: fix unbalaced locking in
 nsim_create()
Message-ID: <20200721122704.1a6db3b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721145150.25964-1-ap420073@gmail.com>
References: <20200721145150.25964-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 14:51:50 +0000 Taehee Yoo wrote:
> In the nsim_create(), rtnl_lock() is called before nsim_bpf_init().
> If nsim_bpf_init() is failed, rtnl_unlock() should be called,
> but it isn't called.
> So, unbalanced locking would occur.
> 
> Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
