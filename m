Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2463F3720
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 01:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238719AbhHTXAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 19:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhHTXAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 19:00:37 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C010C061575;
        Fri, 20 Aug 2021 15:59:59 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id g26so21652421ybe.0;
        Fri, 20 Aug 2021 15:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5N+b3wOihMALaJmPpP13xN80cULdgks84ZuFcJ4Lqvk=;
        b=e4AsedA7BbI048hd6BciCpkwEXxr12d8azmp/cis/ZRj1t77xjjRRxYp8hOiPOdyBV
         l5VtXir0kobg1g6K44KlcTXjbyFNBBBXmv/F2raLLVx3RC3rlcYXrCvhy2FUXdA/DKmS
         BYdX9t/VSwBxxbAWeckNBXMmjN+rXFCW/yPSX/4ytsGAnOd12R/vBVn8Xu5UIUJPPQLY
         sdorUeG6gXvBvw2pQK93shF4JWCtk0pLgTgUNm9I+m/EVFJFMjh2+KvD11CRStjigL63
         +CRrRSm7LptGr7coosujWHqPXmSPFImamlQU4Djr+X69hr9JpzG3Yu9zBWgwJctw59rH
         Q2sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5N+b3wOihMALaJmPpP13xN80cULdgks84ZuFcJ4Lqvk=;
        b=lRUsgZ/jZIZBZr2mgI/tmlN9zO2k4kQPqUsnBEVcn6hf4ICxRX3jUg+ALFqOaxBR+u
         N0b7Zu0PikqihiCMc+1CQOao7kix/iTue0MMJSQOgxWSUJNu/HH9JcNIaJkagthaqIWc
         QCjaBynZHeaEaxBtDq9dcbUlRSO/XFQ/D4MkPBRYGqPWH9OifwpNdmdQsq19x8cOvAen
         FM1s055BgYGmUL7vOCdf2CjF49hVjixJugkKzVvCPEZrPcx8sNqA0TkKQzZ0aX9uFWcy
         2c0fFvnbJCPwEtEb7s6StjI+xF93lEtOSfyju61p+9XpwhXlgPprVvDfDH9rb2GZUGC2
         EEkw==
X-Gm-Message-State: AOAM531emPlPJ0CNpU0b1ronOdPD1Y/QZGtg/4nhOjcskkOaxCuTlbQo
        t/hIL4in19cKsL3rl8pm0oyy8wkRO4if5TF8fiITGrOp
X-Google-Smtp-Source: ABdhPJyjslmcvtoD5j26IAscy7jdLMc0UG9s5eocFS7q6/noc0zqsi3zPOdZBLQnzrol0w5lMDAWmYTRy2pPDAp2mlM=
X-Received: by 2002:a05:6902:114c:: with SMTP id p12mr30417216ybu.282.1629500398491;
 Fri, 20 Aug 2021 15:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210819222307.242695-1-luiz.dentz@gmail.com> <20210820.124629.2213659775230733647.davem@davemloft.net>
In-Reply-To: <20210820.124629.2213659775230733647.davem@davemloft.net>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 20 Aug 2021 15:59:47 -0700
Message-ID: <CABBYNZ+N0d96GieMggHx+x2075cK5aswJpBua-wX2LA87LkgkQ@mail.gmail.com>
Subject: Re: pull request: bluetooth 2021-08-19
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, Aug 20, 2021 at 4:46 AM David Miller <davem@davemloft.net> wrote:
>
> From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> Date: Thu, 19 Aug 2021 15:23:07 -0700
>
> > The following changes since commit 4431531c482a2c05126caaa9fcc5053a4a5c495b:
> >
> >   nfp: fix return statement in nfp_net_parse_meta() (2021-07-22 05:46:03 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-08-19
> >
>
> There was a major merge conflict with the deferred hci cleanup fix that came in via
> 'net'.  Please double check my conflict resolution.

My bad, I thought I had rebased it on top of net-next but perhaps I
didn't do it correctly, anyway the correct version would be the one
Linus had pushed to his tree so you could have just skipped the one we
had in bluetooth-next which was an early attempt to fix the same
issue.


-- 
Luiz Augusto von Dentz
