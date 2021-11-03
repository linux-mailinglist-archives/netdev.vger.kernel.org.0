Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E44443F6E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhKCJet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbhKCJep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:34:45 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828F6C061203
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 02:32:06 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f3so3844800lfu.12
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 02:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jLfcvZTy1cBouZO6QrI9vaaVat0R0Pbk2rQ5RPumBWg=;
        b=UNGe+Z14ZHLZtG8AqZQ0kPjcAVrldxXCaR5imeRCaVVPqwpcVfOCVfyZnUJeG291ZP
         +6aIzMGcxDvd4IrHt0g0K1oqY1mAoKuTolO35Zs5gKAXgXGedIjmCRYvM0g7DZvEjkWq
         0VLdfLPel0dYMhm01TdmwQuxoJTrFBT8X1/mDXLKDW8VDYbm47Wk/h6qOo1DvP7wYb1k
         z83f7NbmggbYUN0nt3719vYQeQa5uaGlw4MXG4/rYX9HzTGxgiKBgqI2VwxvDwKh5tud
         ByQ3N/r9s8hIKJC1ADPLKBYpm8U4TngRHQSwQCNfRu+5aEeoJPrtZLAYWPrkY+eljUgx
         oBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=jLfcvZTy1cBouZO6QrI9vaaVat0R0Pbk2rQ5RPumBWg=;
        b=ElLz2EFucwmuNmHdEu9zTgH2eyE0WyHrR82Yd7hCJ/MEGD3nJP69wmYCEaj+uHpoWM
         sZK1bIGNPf2xsR++fN3oUKQBc9hGDY3zHxlYvQ7Qw4rYlWVwdAT46CM2Nafpj9YdghPZ
         Kz3MBMGZCkOmR3fqDp1z4OnN/tm1JXaKDM4h/WmJQUKOsC6f4RLR9F/YTsHo9W6l4XeW
         4OaAgaFp4eCV766vlflm/e6JA5SJXk1NLm7ju6NSB3zJ9spv8z2LbHpuzFYLygjJAYVx
         e/3QMm9wZ8Q1kQUxsiuByRgqFKpvQRE6Erf2OrtkRaZOA7JofgU65DdG2TfN3RcMtzBX
         90Ow==
X-Gm-Message-State: AOAM5331RJSmk/Uzz6e5UBPkfXK3TFI+ote9Js52aT2NVufURrqd6ttQ
        veZgPrC732WN2vxoIDiDU5fOSV8Z13BQ6tFNEEw=
X-Google-Smtp-Source: ABdhPJzm+4TqzB+HNICwVYvtT1knke/TBrnm24CU2HQaJEydQc25YqtKPdCSNLdkkqEqvawNFstuvEUbVRzy1RGSI+0=
X-Received: by 2002:a05:6512:a8e:: with SMTP id m14mr39931477lfu.575.1635931924695;
 Wed, 03 Nov 2021 02:32:04 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrmahammedmamoud@gmail.com
Sender: amosj3177@gmail.com
Received: by 2002:a05:6520:458e:b0:14d:5771:7384 with HTTP; Wed, 3 Nov 2021
 02:32:04 -0700 (PDT)
From:   =?UTF-8?Q?Mr_Mahammed=C2=A0Mamoud?= <mr.mahammedmamoud0@gmail.com>
Date:   Wed, 3 Nov 2021 02:32:04 -0700
X-Google-Sender-Auth: i0aAVQRtp13Hmncf5FdIVMv5Jzc
Message-ID: <CAPoFYWnHFZ-X2gUWe_ZDk6vKH-YUqResCinxPh14E9k5XdG4jg@mail.gmail.com>
Subject: Von: Herr Mohammed,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guten Tag,

Ich bin Herr Mahammed Mamoud, Account Manager bei einer Investmentbank
hier in Burkina Faso. In meiner Firma wurde ein Wechselkonto von einem
langj=C3=A4hrigen Kunden unserer Bank er=C3=B6ffnet. Ich habe die M=C3=B6gl=
ichkeit,
den Restfonds (15,8 Millionen US-Dollar) f=C3=BCnfzehn Millionen
achthunderttausend US-Dollar zu =C3=BCberweisen.

Ich m=C3=B6chte dieses Geld investieren und Sie unserer Bank f=C3=BCr diese=
s
Gesch=C3=A4ft vorstellen, und dies wird im Rahmen einer legitimen
Vereinbarung durchgef=C3=BChrt, die uns vor jeglichen Gesetzesverst=C3=B6=
=C3=9Fen
sch=C3=BCtzt. Wir teilen den Fonds zu 40% f=C3=BCr Sie, 50% f=C3=BCr mich u=
nd 10% f=C3=BCr
die Gr=C3=BCndung einer Stiftung f=C3=BCr die armen Kinder in Ihrem Land. W=
enn
Sie wirklich an meinem Vorschlag interessiert sind, werden Ihnen
weitere Details der Geld=C3=BCberweisung mitgeteilt.

Dein,
Herr Mahammed Mamoud.
