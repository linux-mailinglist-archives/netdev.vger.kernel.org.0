Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA50400835
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350737AbhICXTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242236AbhICXS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 19:18:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01236610A1;
        Fri,  3 Sep 2021 23:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630711079;
        bh=CMv2yzOriKxUFNa+lX88svxSoDV86oQxgdOPGV0yMmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=If11kSyEDck2Kc9GqI3l5Toy7xn7uOyeEbZ1QtZDdJtFVlUQ7dsOUmyRcYo3b4r95
         7O7oVwGphLakX5TQMmDPURRPbkCaXw+Hf7Zk538LuuZwgNmBdWsZL9cEw3vc/Xsfwa
         PaCuoYw0P3taJYR0dsO/AxvsL4rNcWUdxA6sJeW6CyEqLOFJfN8uRj8k1daJNOKnpM
         mXFkllnvE/CieVGQAGw0hBmVNltcwigFZ8LdY7y+W5/hsgbGrc6ICuD+MVjsekFQeC
         yoVwJBPte4jbfzwwiXN6O83uygsohdzL3q8Ghrl8F/iThjZ7VIwBvTRE02yhiw9FT9
         uNJ1tzzS52KeQ==
Date:   Fri, 3 Sep 2021 16:17:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     drivers@pensando.io, "David S. Miller" <davem@davemloft.net>,
        Allen Hubbe <allenbh@pensando.io>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ionic: fix a sleeping in atomic bug
Message-ID: <20210903161757.5290ff75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9ff5b195-decd-a49d-29e7-02c407cf4c0d@pensando.io>
References: <20210903131856.GA25934@kili>
        <9ff5b195-decd-a49d-29e7-02c407cf4c0d@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Sep 2021 08:14:25 -0700 Shannon Nelson wrote:
> On 9/3/21 6:18 AM, Dan Carpenter wrote:
> > This code is holding spin_lock_bh(&lif->rx_filters.lock); so the
> > allocation needs to be atomic.
> >
> > Fixes: 969f84394604 ("ionic: sync the filters in the work task")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>  
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thanks!
