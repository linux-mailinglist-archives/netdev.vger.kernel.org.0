Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF0E15050D
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 12:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgBCLTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 06:19:13 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38680 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgBCLTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 06:19:12 -0500
Received: by mail-pj1-f67.google.com with SMTP id j17so6263139pjz.3;
        Mon, 03 Feb 2020 03:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dLAb3xztgDHweesldz/wp0VQkjaUb67kJlNH5oaiVi8=;
        b=JskEg8dlqaXPpSQ2Di8o07memgkmylmIYUdT7hSZIIGW22O7KlyKQClBDj2CYtbklr
         1b1l4XZJWnb5575BmdoR/lc8gCgyAQtkXWQz/PRaLVKV3Qr/j2qDtILn59+8RgZ7wcRA
         fATWh0PfN0aY9cCUELRlwXO/x0pXWGLckfwp+vHo18TEtBJ8TNdObprSCTnY5d/5D6Sv
         yYpT+9rN5Ah8cQWbUUP0HMZq/TRcb/hFbaQ33FsCB2EbOvyjEc17uV1KAl4AozhTWAKX
         TYJTgGUwlWtjhGF66PB+ydAjjVe2hK9nioclqgWLlus8mXfWCH7HgpXlGLjJ2RqQ19l4
         Hw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dLAb3xztgDHweesldz/wp0VQkjaUb67kJlNH5oaiVi8=;
        b=DshpTRHiEK4ZxQC/n1QYCcfNh1eyRxR+IKXE/pvHksN/6978LlXk7HIOaT7vTZ5khx
         hjLOtrL19icISw7Xet+ZtuLXvyimroDfaJNhZ6314k/WzrKqv+ZkBxXUebxz/c1mg3p8
         3eueMlyWK2RWjguuAJyQPL+5BWLjNXYhnD2Dg5S9vOEn9NqGDyxjWtalYdxlmJE+HMD6
         xIUNJyS+T9nxIW51ICYDGN4uaZNqa4OpgrL8Dq3bqVohp/FXbC5iv34FaE9I0+/BUff5
         a0I6U24mYybUUycXz1WVPHPjfLW+p+c4o4xbk+J12INgHGIg0XjU0VD0pEDIIb+Fv2hO
         KMvQ==
X-Gm-Message-State: APjAAAU7wX1NcR0zLMn9udpxQuIGquNSe0KPr1QDpnOJ+3NDnFGwdPyF
        XypzW6FEzbHzekaugpgPzdVSuYXc+IEQvQZmSRs=
X-Google-Smtp-Source: APXvYqyw5xhbbzVw+yQ2wqY0NDnDkGXCz6bNcND50+B6/eor7++FXaiNu0XJDggLxBk/oVzl6mwP8r50ymp5sDq4ov4=
X-Received: by 2002:a17:90a:2004:: with SMTP id n4mr29122443pjc.20.1580728750105;
 Mon, 03 Feb 2020 03:19:10 -0800 (PST)
MIME-Version: 1.0
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
 <20200202124306.54bcabea@cakuba.hsd1.ca.comcast.net> <CAHp75VdVXqz7fab4MKH2jZozx4NGGkQnJyTWHDKCdgSwD2AtpA@mail.gmail.com>
 <ce81e9b1ac6ede9f7a16823175192ef69613ec07.camel@perches.com>
In-Reply-To: <ce81e9b1ac6ede9f7a16823175192ef69613ec07.camel@perches.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 3 Feb 2020 13:17:44 +0200
Message-ID: <CAHp75VdaaOW0ktt4eo4NsLFu2QT1K1mHK8DZeycOPhbvcMq4wQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 1:08 PM Joe Perches <joe@perches.com> wrote:
> On Mon, 2020-02-03 at 12:13 +0200, Andy Shevchenko wrote:
> > On Sun, Feb 2, 2020 at 10:45 PM Jakub Kicinski <kuba@kernel.org> wrote:

...

> > I'm not sure it's ready. I think parse-maintainers.pl will change few
> > lines here.
>
> parse-maintainers would change a _lot_ of the MAINTAINERS file
> by reordering section letters.

I think it's quite easy to find out if it had changed the record in question.

-- 
With Best Regards,
Andy Shevchenko
