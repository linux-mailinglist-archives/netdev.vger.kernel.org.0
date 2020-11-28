Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B972C732D
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbgK1VuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387769AbgK1VIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 16:08:21 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAD822222C;
        Sat, 28 Nov 2020 21:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606597661;
        bh=1zXoyPKWy8VMUbxUdNfXvZKIMyO1RH6jo1//abetUBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MF3rR8q0/KGe2l5ppJbJfjbpfT45c9UpkM8z4VkKkJxQWlEI1UfPEYe8lrBrEj76i
         BEcv8BXPwL/35//2kt1HGbOvgwaUIxf/yUN3tKiKo9nqPQmAc7HpPbOWcouRg0Qhxb
         WWeT5n1ZfRUCaQd3Tts24K7pLmV1TgaP6hkjtSfQ=
Date:   Sat, 28 Nov 2020 13:07:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next v6 09/14] net/smc: Add support for obtaining
 system information
Message-ID: <20201128130740.4f12c6e3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201126203916.56071-10-kgraul@linux.ibm.com>
References: <20201126203916.56071-1-kgraul@linux.ibm.com>
        <20201126203916.56071-10-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 21:39:11 +0100 Karsten Graul wrote:
> +	attrs = nla_nest_start_noflag(skb, SMC_GEN_SYS_INFO);

Missed this, nla_nest_start(), the _noflag() is for legacy code.
New families should not use it.
