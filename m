Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2025D468B64
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhLEO3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 09:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbhLEO3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 09:29:21 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D18BC061714;
        Sun,  5 Dec 2021 06:25:54 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id d1-20020a4a3c01000000b002c2612c8e1eso3598819ooa.6;
        Sun, 05 Dec 2021 06:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TXH4Vib3A0y/lG/pTpdUQ6nm+J2heVtS+E8cHBm/Eso=;
        b=KeV4QfYAQJsvhaKHDcbVSYqKkFDZ1Uuy9I2RWRGmLuoIFIziudejTUQSYl4FVJDHyo
         mNZLNRDskJdnxI4nghzuDv16WzYCesXBCcXKlgQJa7ddN3FmOgm10KcHiPwz9QluMJD9
         FDcOnaX6h3P++moN4vkyqJWsFmnfOoM/zKquR6SymmDv1fc97o1WTTrJt0lLQX4xnYWw
         fB4PwFHDL+FNpbKLMGXEG6jCT0eRPVZivgaF6Xyj/foMfiQTz3vzUqD+1Gfc75QgPC75
         F2lSyu9Ha6nWoaki0wZsSimgAVC49IlC56ttjfzj/3NkaMUSg9H8miAnT8UKLJ+i3mR0
         TDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TXH4Vib3A0y/lG/pTpdUQ6nm+J2heVtS+E8cHBm/Eso=;
        b=DvfmcowXKfqf/DB2N7WY9IOlAsByYzyxxbdrXc22CMyMa1kxyTaTY2IsaP/Di+FXjI
         azAFCcbFBysdfG1yLwNRAXpdwxaUNMKoFGcETENMgtVOzdXlau+Cs39vT2+nzXrHfsz1
         oobtlZF4eE2fakgZNfgdSHu7h1AXL//LughZm0u5YTAXaiSD+qisKtwYxvP4AIH5gPGb
         vQVTZK+S1uHZsmYxj8p10lIp3O8/pvVij3QwifnOouUBYJHbWFAR0ugaVjZR7b9PKpwW
         tVzzZrLvEPREg2qPjvMUjTYgUFIfI9DZJvzP3ti8mdR98n4zc0M2T7CdrNPUj6KOkEj5
         MJxA==
X-Gm-Message-State: AOAM532lxkEi9f20DWmlBe23gT7jOpse2mjqD6L3cBYOd3HOUlRoW3+T
        FoA7zxA+fLKBy7RhJrGu2OGRDt4w41GeUbblAw0=
X-Google-Smtp-Source: ABdhPJyJOoXt1tnSHKyS9V4waxZmHFu97XT0amw/R/d7BrQo+dtNctVhlL1wLStbyrsgO1zi1rH1ztuAXNyjtKJiV8Y=
X-Received: by 2002:a4a:cb83:: with SMTP id y3mr19402428ooq.56.1638714353609;
 Sun, 05 Dec 2021 06:25:53 -0800 (PST)
MIME-Version: 1.0
References: <20211205132141.4124145-1-siyanteng@loongson.cn> <YazChnNvaEMHzCQG@shell.armlinux.org.uk>
In-Reply-To: <YazChnNvaEMHzCQG@shell.armlinux.org.uk>
From:   yanteng si <siyanteng01@gmail.com>
Date:   Sun, 5 Dec 2021 22:25:13 +0800
Message-ID: <CAEensMyfThZf=yGwh9Ex_kO51bLJO+KL02xixW-RGuc9YPvRBw@mail.gmail.com>
Subject: Re: [PATCH] net: phy: Remove unnecessary indentation in the comments
 of phy_device
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell King (Oracle) <linux@armlinux.org.uk> =E4=BA=8E2021=E5=B9=B412=E6=
=9C=885=E6=97=A5=E5=91=A8=E6=97=A5 21:45=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Dec 05, 2021 at 09:21:41PM +0800, Yanteng Si wrote:
> > Fix warning as:
> >
> > linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:543=
: WARNING: Unexpected indentation.
> > linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:544=
: WARNING: Block quote ends without a blank line; unexpected unindent.
> > linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:546=
: WARNING: Unexpected indentation.
>
> This seems to be at odds with the documentation in
> Documentation/doc-guide/kernel-doc.rst.
>
> The warning refers to lines 543, 544 and 546.
>
> 543: *              Bits [23:16] are currently reserved for future use.
> 544: *              Bits [31:24] are reserved for defining generic
> 545: *                           PHY driver behavior.
> 546: * @irq: IRQ number of the PHY's interrupt (-1 if none)
>
> This doesn't look quite right with the warning messages above, because
> 544 doesn't unindent, and I've checked net-next, net, and mainline
> trees, and they're all the same.
They are not always precise.
> So, I think we first need to establish exactly which lines you are
> seeing this warning for before anyone can make a suggestion.
Dear Russell

My configuration environment and operation steps are as follows=EF=BC=9A

[siyanteng@sterling]$ cd linux-next
[siyanteng@sterling]$ ./scripts/sphinx-pre-install
Detected OS: CentOS Linux release 8.5.2111.
Sphinx version: 2.4.4


All optional dependencies are met.
Needed package dependencies are met.
[siyanteng@sterling]$ . sphinx_2.4.4/bin/activate
(sphinx_2.4.4) [siyanteng@sterling]$ make cleandocs
(sphinx_2.4.4) [siyanteng@sterling]$ make htmldocs

Thanks=EF=BC=8C
Yanteng
