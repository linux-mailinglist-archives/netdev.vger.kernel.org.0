Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FDD3A82A7
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhFOOYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbhFOOWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:22:54 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365DDC061145;
        Tue, 15 Jun 2021 07:16:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 03970734;
        Tue, 15 Jun 2021 14:16:09 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 03970734
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1623766570; bh=9jVLOrXePqCK4mSCuMv8GHJ8fp2BhHDIGx1d1jJxisA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=sEG/k5gS8MR0zT7N48MxNxI3aG3JzjPFtFzU4I/iMJaEsfXXhEtr+OO2VxdaS3tQR
         Ez6OzWlnrEnRKMRMbbP6YBflNkcwYcmRjF/qhcj8O2pl9sVe9TxQtgdfb+6m/cYLTg
         BRyp5mwNVlbRv45jyqSm6d6Ehb5Zj966EK3f//ehsCgq5MfcKSHsv2rHthvZlY5EWg
         D/LvBhgvFwBlfgHB83adVw6MffhSr4CLg7RgQa/dTee8AV8/+uH870nkuJUQGST7Er
         ZkWGbRhrzJ9CKcvkcNAqRzD93VdNVVW+isLVwKzIb6GXWRBV5VF0TIEFrPWz1uIqhH
         UlYA9T8tW4SoQ==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org, sfr@canb.auug.org.au,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] documentation: networking: devlink: fix prestera.rst
 formatting that causes build errors
In-Reply-To: <20210615134847.22107-1-oleksandr.mazur@plvision.eu>
References: <20210615134847.22107-1-oleksandr.mazur@plvision.eu>
Date:   Tue, 15 Jun 2021 08:16:09 -0600
Message-ID: <87sg1jz00m.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oleksandr Mazur <oleksandr.mazur@plvision.eu> writes:

> Fixes: a5aee17deb88 ("documentation: networking: devlink: add prestera switched driver Documentation")
>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
>  Documentation/networking/devlink/devlink-trap.rst | 1 +
>  Documentation/networking/devlink/index.rst        | 1 +
>  Documentation/networking/devlink/prestera.rst     | 4 ++--
>  3 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
> index 935b6397e8cf..ef8928c355df 100644
> --- a/Documentation/networking/devlink/devlink-trap.rst
> +++ b/Documentation/networking/devlink/devlink-trap.rst
> @@ -497,6 +497,7 @@ drivers:
>  
>    * :doc:`netdevsim`
>    * :doc:`mlxsw`
> +  * :doc:`prestera`

Please, rather than using :doc: tags, just give the file name:

  * Documentation/networking/dev-link/prestera

(and fix the others while you're in the neighborhood).  Our automarkup
magic will make the links work in the HTML docs, and the result is more
readable for people reading the plain text.

Thanks,

jon
