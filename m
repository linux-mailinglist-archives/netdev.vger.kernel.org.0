Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2AB1E914A
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 14:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgE3Mr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 08:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgE3Mrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 08:47:55 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 30 May 2020 05:47:52 PDT
Received: from out1.virusfree.cz (out1.virusfree.cz [IPv6:2001:67c:15a0:4000::e1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C628DC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 05:47:52 -0700 (PDT)
Received: (qmail 31796 invoked from network); 30 May 2020 14:41:10 +0200
Received: from out1.virusfree.cz by out1.virusfree.cz
 (VF-Scanner: Clear:RC:0(2001:67c:1591::6):SC:0(-2.5/5.0):CC:0:;
 processed in 0.3 s); 30 May 2020 12:41:10 +0000
X-VF-Scanner-Mail-From: pv@excello.cz
X-VF-Scanner-Rcpt-To: netdev@vger.kernel.org
X-VF-Scanner-ID: 20200530124110.282764.31761.out1.virusfree.cz.0
X-Spam-Status: No, hits=-2.5, required=5.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=excello.cz; h=
        date:message-id:from:to:subject:reply-to; q=dns/txt; s=default;
         t=1590842470; bh=0jWiyb3a8DKWM+5Wr7Pty+0oF/ve5Qx+saftlGXjYSg=; b=
        tYaVwRLR5uRoCwxwA2rAhHxHa/r8Bxj9z8M508+Eb9CQkueWIgZNUENXP3ShKcnC
        RokKT055Hu1Mvm6517erOCuk/n1lO2fKz5UfeVf5nrBcnxZgdmYW8iSDcayVDjqE
        WQZVzv2g1ZZx9108AANKuHG0WWpnYXDGX9kagS1lc0o=
Received: from posta.excello.cz (2001:67c:1591::6)
  by out1.virusfree.cz with ESMTPS (TLSv1.3, TLS_AES_256_GCM_SHA384); 30 May 2020 14:41:09 +0200
Received: from arkam (ip-86-49-32-164.net.upcbroadband.cz [86.49.32.164])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by posta.excello.cz (Postfix) with ESMTPSA id 70D819D7484;
        Sat, 30 May 2020 14:41:09 +0200 (CEST)
Date:   Sat, 30 May 2020 14:41:07 +0200
From:   Petr =?utf-8?B?VmFuxJtr?= <pv@excello.cz>
To:     Christophe Gouault <christophe.gouault@6wind.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] xfrm: no-anti-replay protection flag
Message-ID: <20200530124107.GB7476@arkam>
References: <20200525154633.GB22403@atlantis>
 <CADdy8Ho0v7SV_dNR+syBFX79U+iE62sumLjDQypgkxs536fCbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADdy8Ho0v7SV_dNR+syBFX79U+iE62sumLjDQypgkxs536fCbQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On Wed, May 27, 2020 at 07:11:21PM +0200, Christophe Gouault wrote:
> This patch is useful, however I think you should change the name of
> the option and amend its description:
> the option does not disable anti-replay in output (it can only be
> disabled in input), it allows the output sequence number to wrap, and
> it assumes that the remote peer disabled anti-replay in input.
> 
> So you I suggest you change the name of the option to something like
> XFRM_SA_XFLAG_OSEQ_MAY_WRAP or XFRM_SA_XFLAG_ALLOW_OSEQ_WRAP.

thank you for your suggestions, I changed the patch and sent the second
version.

Petr
