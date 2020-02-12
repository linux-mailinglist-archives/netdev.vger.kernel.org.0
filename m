Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0002215AFD1
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 19:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgBLSat convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Feb 2020 13:30:49 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41711 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgBLSat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 13:30:49 -0500
Received: by mail-ot1-f67.google.com with SMTP id r27so2912389otc.8;
        Wed, 12 Feb 2020 10:30:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z0AG2Die8L3g5W9S7z/Y2ysTgcDtotnI8+3IpRVg4QA=;
        b=LzDoxHbtix1JeGiwooXl3gSHA7ewzoEM4/GFzlzUdri7XfMTzI3FFDAxve8IL5DPuN
         nfHELOIxgwcWeK7k4IZfiLzzHtjL5Up842AYFXnZ1n7gQu4SpaSZCQKm0ubgFWydlpZr
         FzXWYbqP1XjouZkH3VuMtf5ROxooJ6BIm9cNtBqx1IZ+w9JIWesuk9YSR3JMX/ohaGCi
         hdTmjGhLXg0QUKe+T3yuUl3DmadnGqOCboAR0YIOwF/68Bv7ubdtPU5RL25XtJRZvAOA
         5e9erQ9d5etgfz/AygHEmZhQzblF6ScBtK/BnKnhEMGrfANqBkXNTBJYKqoml3UNwTx5
         DSMQ==
X-Gm-Message-State: APjAAAVQgADS54cgxvDVR5QvQ+yZhdYRm0999E4+SThCwlpBhxlPxpb0
        5ZpP7G2z3tE0GLWy+FdN0rR7yo01BDzFg0bnPHwKlw==
X-Google-Smtp-Source: APXvYqzkNrpV7VTuVPF4atPiTtOKIPM1reavlRAzZc4SIHLzG7h7/G7z+F6QXFB6MVVyng4zmXCwW3o9WwtCN1LJdKk=
X-Received: by 2002:a9d:7984:: with SMTP id h4mr10532076otm.297.1581532248757;
 Wed, 12 Feb 2020 10:30:48 -0800 (PST)
MIME-Version: 1.0
References: <20200212181332.520545-1-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20200212181332.520545-1-niklas.soderlund+renesas@ragnatech.se>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 12 Feb 2020 19:30:37 +0100
Message-ID: <CAMuHMdXjafF4s6U=mD6jEWDgx8CsmRsHiQOEVWmye87=soMz-Q@mail.gmail.com>
Subject: Re: [PATCH] Documentation: nfsroot.rst: Fix references to nfsroot.rst
To:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     "Daniel W . S . Almeida" <dwlsalmeida@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 7:15 PM Niklas Söderlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> When converting and moving nfsroot.txt to nfsroot.rst the references to
> the old text file was not updated to match the change, fix this.
>
> Fixes: f9a9349846f92b2d ("Documentation: nfsroot.txt: convert to ReST")
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
