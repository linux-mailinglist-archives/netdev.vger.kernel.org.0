Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF902A1550
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgJaKtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:49:14 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:59842 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgJaKtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:49:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6271020299;
        Sat, 31 Oct 2020 11:49:12 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Xjy7EPht49gR; Sat, 31 Oct 2020 11:49:12 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F3E332019C;
        Sat, 31 Oct 2020 11:49:11 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Sat, 31 Oct 2020 11:49:11 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Sat, 31 Oct
 2020 11:49:11 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1F8D331844CD;
 Sat, 31 Oct 2020 11:49:11 +0100 (CET)
Date:   Sat, 31 Oct 2020 11:49:11 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        "Antony Antony" <antony@phenome.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] xfrm: redact SA secret with lockdown confidentiality
Message-ID: <20201031104911.GO27824@gauss3.secunet.de>
References: <20200728154342.GA31835@moon.secunet.de>
 <20201016133352.GA2338@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201016133352.GA2338@moon.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 03:36:12PM +0200, Antony Antony wrote:
> redact XFRM SA secret in the netlink response to xfrm_get_sa()
> or dumpall sa.
> Enable this at build time and set kernel lockdown to confidentiality.

Wouldn't it be better to enable is at boot or runtime? This defaults
to 'No' at build time, so distibutions will not compile it in. That
means that noone who uses a kernel that comes with a Linux distribution
can use that.

