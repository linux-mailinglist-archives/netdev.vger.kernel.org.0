Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9935410B460
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfK0RZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:25:50 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40105 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfK0RZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 12:25:50 -0500
Received: by mail-qk1-f195.google.com with SMTP id a137so18391846qkc.7
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 09:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SyLTci+74nRZSDUku0dXTAAk3nRjI4NMyLYHOUy9iSw=;
        b=FKB+SRN7f5uu10rogzWGvTOhlLIYfQ/Y8d558EUQxpvznsOl4zlOodjodErrJcvyCR
         MvhH4os/sL4NL5d38vTDE+x3T7NYUkxPBd/UAVZR6STgQr5l2EgXBP1C/ueMsFI2/QeN
         9QsGPAAbF9TaTxLPfHk5k3eaZy9eBJXGTbiSyTdf1JMRR47b4yVd+CJMVrLTaapMybAa
         TMUMrAidk1NEJvrsBRXbD1aVKL1t8ne7kBbmfoAV0itok4RefXITJhuLVqUzqfiHxlT+
         O0vmYHYJuvdX08pjUMumwTxnNGyK5Lf9BD4FkuyfWZDgG8nCXbkKcZ1t2U5uY5gwTwwk
         N86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SyLTci+74nRZSDUku0dXTAAk3nRjI4NMyLYHOUy9iSw=;
        b=V3tGHBmSeISyJXmt7fSl0Bi6nw+oQV06pr1er3/67oCqMlwLtTKMLQaN0Py1Tpzyuv
         +IyqVs42huKbzFqE8nCmxXkho47eZ+s/LdVh6aaT5gpCnJnsn2qK+eFbYER8PyVG/FaM
         0+f5BwNCZMaAeKDL91RltgXejtjFAQB8FMky55NyJ3HoI2lAJdMT5GtKKzgP0K/sW2b6
         GkMKCcV/bZnjayOTR+FJ/zTCi0acdoeSdIecsBYkGkrw/5T3kiE2f9RN9ucLRFT6Ew6S
         SBKnFbdmQ6+IHyLS+cBuabOqAltdxWyFvQvYi93TKmhykBiThj8Dq6G/VZ5p5jcFggvK
         PH1w==
X-Gm-Message-State: APjAAAXeg0n7B2jXzBwIuHTVwI3+7PxLGHeXnCp1ad2CXkvYOh7z6dvI
        J3i7Govrp4nD3JeW9Q7Tz0Y0TL+YuOlwEsi/FpfyfA==
X-Google-Smtp-Source: APXvYqySq1fLKpo1mLqFnH5TItrk1NRYj4qQ3IrR6ckKUIrvKy7hmmKzQSrm9p1f81OS7EM04oJQykfDCuP34DmZKg4=
X-Received: by 2002:a37:a3c1:: with SMTP id m184mr5398890qke.49.1574875549140;
 Wed, 27 Nov 2019 09:25:49 -0800 (PST)
MIME-Version: 1.0
References: <20191127052059.162120-1-brianvv@google.com> <20191127082655.2e914675@hermes.lan>
 <CANP3RGctgy98FsyeHq+aVk2S=N8ndY0Y+qMkZUhTB=26H_Y3Rg@mail.gmail.com>
In-Reply-To: <CANP3RGctgy98FsyeHq+aVk2S=N8ndY0Y+qMkZUhTB=26H_Y3Rg@mail.gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Wed, 27 Nov 2019 09:25:37 -0800
Message-ID: <CAMzD94R4AqjgtqxgpnZ67H6GvQzin1idxj8OjMmOfmruEc9_CQ@mail.gmail.com>
Subject: Re: [PATCH iproute2] tc: fix warning in q_pie.c
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Leslie Monis <lesliemonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 8:44 AM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> > What compiler is this?
> > The type seems correct already.  The type of double / unsigned long is =
double.
> > And the conversion may give different answer.

I don't think this conversion will give a different answer, the
compiler already change the value from UINT64_MAX to 'UINT64_MAX + 1'
which is pow of 2 and can be represented precisely in a double.  This
change is just making that conversion explicit to avoid the warning.

>
> Probably some recent version of clang with -Wall.

It's clang 10

>
> That said, I think the warning/error is correct.
> UINT64 doesn't fit in double (which is also 64 bits, but includes sign
> and exponent) - you lose ~13 bits of precision.
> I'm not aware of a way to (natively) divide a double by a uint64
> without the loss (not that it really matters since the double doesn't
> have the requisite precision in the first place).
>
> Why do you think the conversion will give a different answer?
> Isn't this exactly what the compiler will do anyway?
> It's not like we have long double anymore...
