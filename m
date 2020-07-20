Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5002F226196
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgGTOHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgGTOHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 10:07:21 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E2C20B1F;
        Mon, 20 Jul 2020 14:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595254041;
        bh=w0+DZGFDydbPGiykrRNE0uBxfs1HEY3VFFmgRswPWLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mk3Rua/LU/vFgtK3rCuvE8WIYlVT00Jy3FL9/Tj1diNzUjeKPeoiBs3LSOjAObF81
         hfP5pTClEg2K3vScVVIDJIJMrN7xU9zzya51ccjcM0BYd408AOUpeYwgHGvzRewq35
         mFvHUligmn1ObgIfCrHnKqaOnJrvAXXqeC6/VtCk=
Date:   Mon, 20 Jul 2020 17:07:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for v5.9] RDS: Replace HTTP links with HTTPS ones
Message-ID: <20200720140716.GB1080481@unreal>
References: <20200719155845.59947-1-grandmaster@al2klimov.de>
 <20200720045626.GF127306@unreal>
 <20200720075848.26bc3dfe@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720075848.26bc3dfe@lwn.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 07:58:48AM -0600, Jonathan Corbet wrote:
> On Mon, 20 Jul 2020 07:56:26 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > >  Documentation/networking/rds.rst | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Why can't it be done in one mega-patch?
> > It is insane to see patch for every file/link.
> >
> > We have more than 4k files with http:// in it.
>
> Do *you* want to review that megapatch?  The number of issues that have
> come up make it clear that these patches do, indeed, need review...

Can you point me to the issues?
What can go wrong with such a simple replacement?

I can review per-folder patches if it helps.

Thanks

>
> jon
