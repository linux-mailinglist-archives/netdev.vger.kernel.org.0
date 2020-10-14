Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC3828D758
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgJNAPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbgJNAPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 20:15:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8157220776;
        Wed, 14 Oct 2020 00:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602634507;
        bh=R5PKJvozLLXMD2g3JUBdfEV6OMzBc8v0tDUBd3YQOcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tzQ6yKqJpJ2sO2/FjWY7Gxkf3XyMyP/GmNKbAYBBWW+Mj3emvldpLZHkykQOOhXqA
         OTfBrfl18qK2ZZ3qFDWtD12FjROt2jnAwwiFh3yjixg6r5SBrj5JU9mZv6wJqbV7Mu
         8t1lGcntxgtCKwyNwYPC8Y0ktP1eZbwXGrY5PXKc=
Date:   Tue, 13 Oct 2020 17:15:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     linux-security-module@vger.kernel.org,
        Valdis =?UTF-8?B?S2zEk3RuaWVr?= =?UTF-8?B?cw==?= 
        <valdis.kletnieks@vt.edu>, Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH 0/5] net: use semicolons rather than commas to separate
 statements
Message-ID: <20201013171504.5089fe3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
References: <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 12:34:53 +0200 Julia Lawall wrote:
> These patches replace commas by semicolons.  Commas introduce
> unnecessary variability in the code structure and are hard to see.
> This was done using the Coccinelle semantic patch
> (http://coccinelle.lip6.fr/) shown below.

Applied 3-5 to net-next, thanks!
