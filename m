Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D660B4624E2
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhK2Wcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhK2Wcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:32:43 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C7FC08EAF8;
        Mon, 29 Nov 2021 14:20:17 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 689EF221;
        Mon, 29 Nov 2021 22:20:17 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 689EF221
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1638224417; bh=cWLrV3sN2L9a4mscHC8cxOkPTpNjGMnBB/U3F0GHUiU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=amLKGQw3djDEOU+47izoYgQzfXrLLH34050mH4vZTGowUk3dD499jGGSQqAZxHjfP
         A/lacmoeR1uI2rAADXQDiuks3pAkl4qUwfjFSsNxqo0RNUMH5VnWz00Q3ADdoU4DU4
         DGm5iQ/oP628IjteMr6Nn1hKpSlTypvkjzdawST30dQ4SzsYGGfn6rXEVPofllAAo/
         N3YMha6D8WFjIxlGVavWNI1zJsb+uenrT0EbK7v1+xGYugVlmDP0OPaJeAJw2VjhOR
         l0Nx3LWHur7+Q8RGQ63g9sRTuinhgHC25dQQw/rm7ZNmTWrFMRpNyPxnr7mnKyJVwS
         Pj35NErOMidVg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Ahmed Zaki <anzaki@gmail.com>, linux-doc@vger.kernel.org
Cc:     Ahmed Zaki <anzaki@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] Doc: networking: Fix the title's Sphinx overline in
 rds.rst
In-Reply-To: <20211128171719.3286255-1-anzaki@gmail.com>
References: <20211128171719.3286255-1-anzaki@gmail.com>
Date:   Mon, 29 Nov 2021 15:20:16 -0700
Message-ID: <87y256r4db.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ahmed Zaki <anzaki@gmail.com> writes:

> A missing "=" caused the title and sections to not show up properly in
> the htmldocs.
>
> Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
> ---
>  Documentation/networking/rds.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/rds.rst b/Documentation/networking/rds.rst
> index 44936c27ab3a..498395f5fbcb 100644
> --- a/Documentation/networking/rds.rst
> +++ b/Documentation/networking/rds.rst
> @@ -1,6 +1,6 @@
>  .. SPDX-License-Identifier: GPL-2.0
>  
> -==
> +===
>  RDS
>  ===

The networking folks normally like to handle documentation patches for
their subsystem, so netdev@vger.kernel.org should have been in the CC.
I believe scripts/get_maintainer.pl should have told you that.

For something so small and obvious, though, I don't see any point in
making you do it again, so I've just applied it; hopefully they'll
forgive me :)

Thanks,

jon
