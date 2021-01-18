Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511FE2FAC83
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394603AbhARVVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389683AbhARVUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 16:20:16 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E45C061757;
        Mon, 18 Jan 2021 13:19:35 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id m13so19640028ljo.11;
        Mon, 18 Jan 2021 13:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Gw9GWK1LY+wiC3xlS1+0EnqCUMmvekAt1MEE2u5Clg=;
        b=AT1ajz/a3PMJPAUuuNGw3hMwI7o0S4FiZc5V+xlgtrazeF1IJ/dRwjZT6aObPeajwu
         neZSMBur1kLY+oajIHHdBhAEud61L6V9Qowhyhkgv9PgThd6WO71fqWELaOYHefe1VW9
         t9HMUKJQ7v9bYRLiopX/42UsX5GcsgvKK5JeBuoA+OH+ve1UhCNHUdgg9h35zcKFkwfh
         i0nN9OIBzPgjf3qZCWMbsCirlDwPjT3VLGZnm/a9ykYgZriS9wfxyoqEySeciKPC2Osw
         zvA18FAISZsIUlD9S9J5llSsJDKSfi4DwGHfL1/OjLZ7FxIGc+xwBROUuxYBKQjqVRXc
         lCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Gw9GWK1LY+wiC3xlS1+0EnqCUMmvekAt1MEE2u5Clg=;
        b=J64br8y+pUmuVC6ki8CP2xmoFjWdU/u76VY9QtRYlHqkoG3WppWryoqAeOM7wxExKZ
         Gz/AluWcgLPKzXrI+/lB1TXF7ECAwED731Igt9fGpQRwwMLp5KXwq8Rp5m4gQdrGcKZz
         9f+A6+hqunptoRrppVgpEXmhhmrTneKAkDBCLE0DZZimmhmYLJGKIPeNsM+JMbaSjJ7o
         bwIFFeMGhUXGQDLRE4ldXniT9wyk+Kk6TOWCNmiLgu2XbvDI92my0lHp+aO28rZGK5vd
         8Ql+XQWG1d6bJIlfKEMm7prJlCcOhL+fIZICzjqShB7JkDpUYzdibjgU5zkYVtEazaa6
         qo+Q==
X-Gm-Message-State: AOAM5322yQS+Zc+dbU81JiBh/R70Phivu+tGegQCsGWOHA7XGM5Whf4Y
        NyLJe8fm8R/+q/Cct8b2b2paatco7YGBcngj5mWSYUjUqGo=
X-Google-Smtp-Source: ABdhPJzACseCUIk3O93p43wtSe9U6ueEHRh/iRgAn3tf5XogTMtTUYvYgZvbcKMKYf3XErfZk3wMfaQSWQC7BToJatw=
X-Received: by 2002:a05:651c:120f:: with SMTP id i15mr583141lja.339.1611004774188;
 Mon, 18 Jan 2021 13:19:34 -0800 (PST)
MIME-Version: 1.0
References: <20210118205522.317087-1-bongsu.jeon@samsung.com> <20210118130154.256b3851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118130154.256b3851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Tue, 19 Jan 2021 06:19:23 +0900
Message-ID: <CACwDmQDxa6WKq4UwCfk2sxC8JukV+CcnuSqrCdhSWSjJ9ppwOg@mail.gmail.com>
Subject: Re: [PATCH net] net: nfc: nci: fix the wrong NCI_CORE_INIT parameters
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 6:01 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 19 Jan 2021 05:55:22 +0900 Bongsu Jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > Fix the code because NCI_CORE_INIT_CMD includes two parameters in NCI2.0
> > but there is no parameters in NCI1.x.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
>
> What's the Fixes tag for this change?
Sorry to miss the Fixes tag.
This is the Fixes tag ( Fixes: bcd684aace34 ("net/nfc/nci: Support NCI
2.x initial sequence") )
Could I resend this patch after adding that tag?
