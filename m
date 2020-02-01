Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4F14F825
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 15:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgBAOqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 09:46:20 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36214 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgBAOqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 09:46:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so12172520wru.3;
        Sat, 01 Feb 2020 06:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=XkgwxaTMSilVxkSXtvoIRh+tbRh+Vl/guNQAn5ejMuc=;
        b=MQENr6FUr79PyuLZIxtmwnDxL6w7s6tpum0ju5bezwIBJqMaqdZTr2h/fVIXDLF6VT
         J7CTd8CjRNDnf36EO1fC/uKOo6VACMS71YOgZ2U3HDm6TJw1gK8PLMVz+L9cSkr5DMVj
         B/bJ7R2iAYKJ6RxUDKLEN/+66/CO8fSaAxgZgPSrcendgPYHf076oLwDbQwIp+MCu5aQ
         66CQKrJbE6LBxOQczNnoVlkawBjTZtjC4wI7WunZhyFtfeZSLwCvr6tBFf9eahlpCD3o
         r+6Ve9PCTUONbETMtzCiwama0b/5EpB+YDjYUnDE2MGrO7B/0Kf7/nYYSGRMgyYMKEj+
         W7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=XkgwxaTMSilVxkSXtvoIRh+tbRh+Vl/guNQAn5ejMuc=;
        b=YxySZ7gizwwLwnf9Xy0x5eYYyCMNDobRIr76NQnetccM+mX7sXpFHzh1LVuuwSUSAE
         r88tTVhzfxPZEUrw6cr5XK9xGPgVJz6y7dosgKt6CWTNfBI5J7vBoIR4A2/u7Kvdf2D7
         oKsoOW/mMtnN58p4LNvrVbANODvhZLN8zmgfMOiYWpDbHk11juzh3dyC4CbWSOcPYVSv
         ORg8VJMiCAHEppYKLjr9OaU3TBazSm1j79niDhxM7WeQnu2g7xauRoDObGVwPL5g7tWA
         48TOnD0t6QJqSQ/t04Aek/0uSVOAFWqCW5WFJDRhfP4CZPT9+rKzNiseAF+dSHG6LmWy
         S+cg==
X-Gm-Message-State: APjAAAUrIVyyxjr03bRieFfqZpp17vbk6vWhN80b4L9OBghTTRcfIGbR
        xAdVRzX9hWqb8lW/9f+hUcpuKJuh
X-Google-Smtp-Source: APXvYqyWxD1D7WkydwBQHsowrvtfeQMHFBD22s0XWXRKczphjNsz+CV/vacuJFH0bq1W5Y7xrwZhpg==
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr4821004wrs.222.1580568377961;
        Sat, 01 Feb 2020 06:46:17 -0800 (PST)
Received: from felia ([2001:16b8:2d5f:200:619d:5ce8:4d82:51eb])
        by smtp.gmail.com with ESMTPSA id i8sm17109355wro.47.2020.02.01.06.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 06:46:17 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Sat, 1 Feb 2020 15:46:09 +0100 (CET)
X-X-Sender: lukas@felia
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "isdn4linux@listserv.isdn4linux.de" 
        <isdn4linux@listserv.isdn4linux.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
In-Reply-To: <CAHp75Veb1fUkKyJ1_q=iXq=aFqtFrGoVMzoCk15CGaqmARUB+w@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2002011541360.24739@felia>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com> <CAHp75Veb1fUkKyJ1_q=iXq=aFqtFrGoVMzoCk15CGaqmARUB+w@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Sat, 1 Feb 2020, Andy Shevchenko wrote:

> 
> 
> On Saturday, February 1, 2020, Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>       Commit 6d97985072dc ("isdn: move capi drivers to staging") cleaned up the
>       isdn drivers and split the MAINTAINERS section for ISDN, but missed to add
>       the terminal slash for the two directories mISDN and hardware. Hence, all
>       files in those directories were not part of the new ISDN/mISDN SUBSYSTEM,
>       but were considered to be part of "THE REST".
> 
>       Rectify the situation, and while at it, also complete the section with two
>       further build files that belong to that subsystem.
> 
>       This was identified with a small script that finds all files belonging to
>       "THE REST" according to the current MAINTAINERS file, and I investigated
>       upon its output.
> 
> 
> Had you run parse-maintainers.pl to see if everything is correct now?
> 

Interesting... I did not know about that script.

On the current master and next-20200131, it reports:

Odd non-pattern line 'Documentation/devicetree/bindings/media/ti,cal.yaml'
for 'TI VPE/CAL DRIVERS' at ./scripts/parse-maintainers.pl line 147, 
<$file> line 16777.

I will send a patch to the TI VPE/CAL DRIVERS maintainers to fix that as 
well.

Lukas
