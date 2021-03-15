Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F7B33ACF4
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCOICa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhCOICH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 04:02:07 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1DCC061574;
        Mon, 15 Mar 2021 01:02:07 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id o11so32448149iob.1;
        Mon, 15 Mar 2021 01:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tqMwSsxE8mSsOZPr95VkNebuiZwi7tRKMS9S8b6s9Z4=;
        b=XaFtGW31ERcEkEBmeuxVBQMgfDZzcM7jLzZ2lxTuy48U6hIHhrgaBBXd/9RZ5ZyLHE
         m7uDowuJ1+i9fVsBYUvzPkSOxrHjS8pO+sIIN4YZHkErzAAMalREgcaVDKq+i8D4zWZR
         a/yH+Z2RpMsOMih5g41EzlrbFKjZ4oXMOFXQxzLuKZHUNkGD1faHt3GCuCXKnCnvKobQ
         Pjl5Fl0FBHw8fZsN1cW14dVc3ELjvGhBoX9Q5qM+C3+A2zqa7sPmF3F96vzsRP8Zko5o
         OOm1cjB7i8WzzWqnWZUHtAowiURhqlsBN+oTYhrR0tKTcmKsdbUn3ezhy8mQw6x7fOzd
         aC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tqMwSsxE8mSsOZPr95VkNebuiZwi7tRKMS9S8b6s9Z4=;
        b=OCuJH8XgLC3dwaPMmyjV/eSKnuVn7a0tYhre2VKxV5fUvKioZs+OwZSipHeYvfUUjF
         PWQJKjr6ng4gTS1kX2Xnvn2eZT9slQnqi7AHWcfqMAi/fOvGV7J9IhHXUoOe/X+/dc+R
         wfKBB1vLbnfGAaunynhTavOieffeNenNkc7chLJdJwYrsTasm6HwIPN7qIStbISzeLXh
         iG6nAonH5Ljuwr3JZvXV/nFJARVxjMGTJ3KpQwigBJZWrWK88NzsK4ceszsXltqHXoL7
         FprCiD6oyfZK9T95rGM3RNdulMc13SXtkmVSR3sMQLx+rnl1BzQyAzlDd97B1UBvZDV3
         zuow==
X-Gm-Message-State: AOAM532IOm2Az8XFfP+7n6TwpsAkJ3iYo9/wDj7t3lczaK4YRM1IcFuk
        vJ5UMC+m9tP/rbkT3E5kl4Srb0FyEj4JYNMWmOI=
X-Google-Smtp-Source: ABdhPJwQiYkuELW/9smSceH+H6tbTZaziR6zdehTzqcKsNFxphJsP1z9Jk3ej+O9RkGa5WpzAuPeRZ0ptaBZXwPlggY=
X-Received: by 2002:a02:6a14:: with SMTP id l20mr8693220jac.12.1615795327125;
 Mon, 15 Mar 2021 01:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210314201818.27380-1-yashsri421@gmail.com>
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 15 Mar 2021 09:01:56 +0100
Message-ID: <CAKXUXMzH-cUVeuCT6eM_0iHzgKpzvZUPO6pKNpD0yUp2td09Ug@mail.gmail.com>
Subject: Re: [PATCH 00/10] rsi: fix comment syntax in file headers
To:     Aditya Srivastava <yashsri421@gmail.com>
Cc:     siva8118@gmail.com, linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 9:18 PM Aditya Srivastava <yashsri421@gmail.com> wrote:
>
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> There are files in drivers/net/wireless/rsi which follow this syntax in
> their file headers, i.e. start with '/**' like comments, which causes
> unexpected warnings from kernel-doc.
>
> E.g., running scripts/kernel-doc -none on drivers/net/wireless/rsi/rsi_coex.h
> causes this warning:
> "warning: wrong kernel-doc identifier on line:
>  * Copyright (c) 2018 Redpine Signals Inc."
>
> Similarly for other files too.
>
> Provide a simple fix by replacing the kernel-doc like comment syntax with
> general format, i.e. "/*", to prevent kernel-doc from parsing it.
>

Aditya, thanks for starting to clean up the repository following your
investigation on kernel-doc warnings.

The changes to all those files look sound.

However I think these ten patches are really just _one change_, and
hence, all can be put into a single commit.

Hints that suggest it is one change:

- The commit message is pretty much the same (same motivation, same
explanation, same design decisions)
- The change is basically the same (same resulting change in different files)
- All patches are sent to the same responsible people, all of the
patches would be reviewed and accepted by the same people.
- All ten patches can be reviewed at once.

How about merging all ten patches into one patch and sending out a v2.

Lukas
