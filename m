Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02C72A0E71
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgJ3TSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbgJ3TRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 15:17:34 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D209320739;
        Fri, 30 Oct 2020 19:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604085454;
        bh=arZehGGpkCIhfaRvbxGKyH2vIZAVu2zq6R5OwstcIwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t7zrBdlePfvcpTSmB2cNcG5jq155Uk5bQLVJBA7mat4ZwZsHNYWx1JYlksTPgVQxB
         CPYOUlOOKXeK1FCkvwJQZTPM57etMQhJIgTRnf4/CM6WVsfWdn7bQ/9jci4mIpc/yH
         Soj7DSmsQeUCCGNrIXAHf5rmiJ8Pg2biHFCDNK8I=
Date:   Fri, 30 Oct 2020 12:17:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next] net: ipv6: calipso: Fix kerneldoc warnings
Message-ID: <20201030121732.0edd9145@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028013344.931928-1-andrew@lunn.ch>
References: <20201028013344.931928-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 02:33:44 +0100 Andrew Lunn wrote:
> net/ipv6/calipso.c:1236: warning: Excess function parameter 'reg' description in 'calipso_req_delattr'
> net/ipv6/calipso.c:1236: warning: Function parameter or member 'req' not described in 'calipso_req_delattr'
> net/ipv6/calipso.c:435: warning: Excess function parameter 'audit_secid' description in 'calipso_doi_remove'
> net/ipv6/calipso.c:435: warning: Function parameter or member 'audit_info' not described in 'calipso_doi_remove'
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Thanks Andrew, I applied all your W=1 fixes that hit patchwork.

I had to add review tags manually (probably due to the vger hiccup PW
didn't take them) and correct some spellings.

If there is anything I missed please resend :)
