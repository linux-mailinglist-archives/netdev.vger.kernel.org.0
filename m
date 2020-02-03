Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F3B1503FB
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 11:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBCKNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 05:13:32 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37353 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgBCKNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 05:13:32 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so6200379pjb.2;
        Mon, 03 Feb 2020 02:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GD14FMeWoDKUquusWa5QP4XNkdd6IXnIuERNShAs1x4=;
        b=ktB4pnhKlWRnPkz0racHaBHuc4IRVlnEqRkL7gFlMe/O5nOh48rXm+Sb2bhp49WEFK
         BfL+re4bXVVbbKa8e9ULQxlulvWoouNli844YmkOhDNmLgQ7CQv9DoFN7ZSAgE6gv3h9
         rQnNEM577Sal69BSvXTeKFEdLcc3W8FQdNXaOjRCqKGpnVFwQnkov4oXKL6aHPD6YoTP
         ObrzvVGNgNf6X8E0c44bpGalQZutXWwGmRD/2S7WOFcFIBql+FFrLmAEs2Z8EybK9KCa
         m3UjpwRmIfnru1/eIqeeZ2FpUCd6vjXOQzkbs2jrQPkk+PIKbHX93KR11VCIhpKiAq1q
         83Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GD14FMeWoDKUquusWa5QP4XNkdd6IXnIuERNShAs1x4=;
        b=XQ8F+oyM/Vq9vZkoFY1eHiF72HnvbmFjq5ep7To/zYds07R6yoWaWhpNsJnCImSKjE
         9NcMBt0YoEDHIuijp8VFaFGLs2JqY9mBg5KZO7PiA89lyrkAUmmL6hBhPw+klamubKhm
         Hx1cuJn8jcY/ebcr60EY/o0jfM9dsP/sijrTCcdwFPvOqsIqoOBiEzIpy/kyaa0vGiZ7
         I7Yqmo1m/RlRhhPgKjATe/79k4y+0OMr0tpJkd16B2P8E71nUZHPq2c7SzjMhkw3+KCr
         SjnAKMyCuMvXjNqRize/rEhpbLqB8AakoYI7/fFbOc5qkJZnKkYPNTnx15I5dhVmwALT
         juOQ==
X-Gm-Message-State: APjAAAU0HCgXprCvNGdxT7EAtJVEQ3SrIKM3iWcM4NSoMdTN1jwyPZW6
        jY7LKHYxl39gtc/bggEYFrMUhcgXXVld03NZM8g=
X-Google-Smtp-Source: APXvYqwGyhQNbP8YuInSmt7jSMBKWaXjhTPEzV9pZ9Pnd3o4H2NF3Q3L6Ro9oY5ldYGpbcNAhn/s7De7NMoPaHshqNI=
X-Received: by 2002:a17:90a:2004:: with SMTP id n4mr28825873pjc.20.1580724811635;
 Mon, 03 Feb 2020 02:13:31 -0800 (PST)
MIME-Version: 1.0
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com> <20200202124306.54bcabea@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200202124306.54bcabea@cakuba.hsd1.ca.comcast.net>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 3 Feb 2020 12:13:23 +0200
Message-ID: <CAHp75VdVXqz7fab4MKH2jZozx4NGGkQnJyTWHDKCdgSwD2AtpA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 2, 2020 at 10:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat,  1 Feb 2020 13:43:01 +0100, Lukas Bulwahn wrote:
> > Commit 6d97985072dc ("isdn: move capi drivers to staging") cleaned up the
> > isdn drivers and split the MAINTAINERS section for ISDN, but missed to add
> > the terminal slash for the two directories mISDN and hardware. Hence, all
> > files in those directories were not part of the new ISDN/mISDN SUBSYSTEM,
> > but were considered to be part of "THE REST".
> >
> > Rectify the situation, and while at it, also complete the section with two
> > further build files that belong to that subsystem.
> >
> > This was identified with a small script that finds all files belonging to
> > "THE REST" according to the current MAINTAINERS file, and I investigated
> > upon its output.
> >
> > Fixes: 6d97985072dc ("isdn: move capi drivers to staging")
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>
> Applied to net, thanks!

I'm not sure it's ready. I think parse-maintainers.pl will change few
lines here.

-- 
With Best Regards,
Andy Shevchenko
