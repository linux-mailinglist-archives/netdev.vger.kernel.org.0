Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A565B2B7DD0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 13:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgKRMr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 07:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKRMr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 07:47:56 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A524C0613D4;
        Wed, 18 Nov 2020 04:47:56 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 34so1113978pgp.10;
        Wed, 18 Nov 2020 04:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2DjGzshzKdHWrGiaGRKCB67Oy3hkCcTIVQFEgISUXfQ=;
        b=bbkvjKynxttrfV7/oq9VBdsZRxyp8CYW0iQnwyHY2HQbZ8N8VD6K/YIk13UnytI6GI
         FS3/dNG0wZ0GJHZP04YZWas/v7pnHBBsaIG8OXl9vAgg0MB3TNdLE+n5XY1Kt583X//w
         XC3qfJjF1HP1MaY2pJD173Z3fvTvOJuOWCMF3LILbG6FygQvRsTCf+gWRKKs+q+q8HSe
         TzKGXQLOUSaSZkRuq0lY+xwT0ncLPPzN/ocG2nM5lXvj0wxncVW5YcxtwSm/K+tDDlcz
         9SakYjXuMYyhd+lMWqVve1RaJmL/8zEm/l1ZAkZTzM/H+Jm+yVt3bN58dfWbZuDXs9b3
         1N7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2DjGzshzKdHWrGiaGRKCB67Oy3hkCcTIVQFEgISUXfQ=;
        b=kd2I2O97+hRALMHkPLkP12MG6t/xF2NavIjVtBqfBDF7i/Nf+VHAB6bNKKtZbc9zdx
         W/WpgbFzq+0ceqnVdY9lE6qKOTYTsg+8yrMbXC+ergHxtxYGGQnIv5fd+RjRLZ0hAcEw
         7IPQNwG9YihfvOA5AmSS81TEdoh1LLf/Y+5zjvwe9+kJLkplhewVojPYd50a6ZLT5EQr
         ds4tozPIa6VOnj9qdMa/IXbcZh+fgcy65ccQMwG9vXZpPLwz8I+78d1zBxQ4eArekzek
         Bxg+uDWgh64u3d0YYz1e/MiseDAP8OagjfsBaFTMmQGNhFSfdVMywBFVRV/apcvDeFeC
         SvPQ==
X-Gm-Message-State: AOAM530op2DWFUpZtvH+b1mGA6er4qPBxhyoHme7FzXPr602s4Wq+aQ0
        KXzAPRdDddghKKwru2s2FRYCYt7VFWr+eQtFExA=
X-Google-Smtp-Source: ABdhPJzEg5T27QrloGArlelWEc+01Ji/j5nHAavxP4ExA5OBq3+ypXhnjgCr0vYLdLvWm8tjsZULsf4bGi5Faa//Kds=
X-Received: by 2002:a63:1d0b:: with SMTP id d11mr5357330pgd.368.1605703676179;
 Wed, 18 Nov 2020 04:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20201118161959.1537d7cc@canb.auug.org.au>
In-Reply-To: <20201118161959.1537d7cc@canb.auug.org.au>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 18 Nov 2020 04:47:46 -0800
Message-ID: <CAJht_ENp-AHgOj4GZhSgg7P3mXtN6AYqeiZTYObji3qJWkw0pw@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 9:20 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced this warning:
>
> Documentation/networking/index.rst:6: WARNING: toctree contains reference to nonexisting document 'networking/framerelay'
>
> Introduced by commit
>
>   f73659192b0b ("net: wan: Delete the DLCI / SDLA drivers")

Thanks for reporting! I submitted another patch to remove the
reference to the deleted document. Thanks!
