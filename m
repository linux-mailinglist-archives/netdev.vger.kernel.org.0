Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE13101A56
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfKSHb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:31:56 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36526 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfKSHb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:31:56 -0500
Received: by mail-wr1-f66.google.com with SMTP id r10so22515331wrx.3
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 23:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cWFm84Oj9pgaJ4NIH9Yv7ha7L9etT4iR7rz65tv2icI=;
        b=X6KzpnXIXiOOsGiPKuqShbUOuiMjlyYBMGdiJYSbSs8DjpxY1mPlRcNDTzHW5KsYtU
         aTDLpmgwtogop2xpsbRsKhTI17oajHjVkQaDfFNJ4QKgwa15ouz7nUTuPG+2CXkxFLt1
         BW7hXrvlBPKoNlgT/bZLlz+uPWmwngY74DLmOLtzwCilYpzVQ1tFQ746GxyZ8pDLlQKD
         YkrHBdVYOyI7RRw0XLVOQdK6cvZVMNKSUAbF548cT4k2ulM4YIluiQvlISTlQ8wVE9qF
         6Y/i6zvE/C/vJI6JuZW4QM2WpaoN0dSSU6F5DMUzn5W1LB5ygdlo/3wVp5TtFx9wE8VD
         aKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWFm84Oj9pgaJ4NIH9Yv7ha7L9etT4iR7rz65tv2icI=;
        b=scaUKBH9JWbEdhpWEl8p7Ypfar6bMWAdjCzMwPHn9xqWKW759wrn9xXuFwqJASai12
         yixZ3b6zSgmV+xP+KIMvLdjm/f55aGyF7zMJDGTgGKIAiOGZLg7PjYZ+1YOF1G6k/8dI
         /p61C+KYYHymq023dHA4xx0iKLaL3+OOYISTyf//LebxWoteoVJAbWuZuQIuWyzp3/gJ
         DRc9Bl0f8chiPtpwt5tQpeka0ndCrxJrddKOIZ2imqLQgMhpSoYb4JlTI9UM6EluxqBm
         7o5xto5CGdaqUONHRmbfrMW1PnZ/1UyProw7ntkmb+UwQ+yndgXFF0GAW2h3b3wkXh1r
         EhSA==
X-Gm-Message-State: APjAAAVuMRAPyaGISirxY+BbOVXI2Cy7B+jd7cvZX7cOoeToLiAVHVdA
        /s6JLJzmX3NkMm2RA3/8FoC6msgVtLfBHX83fSs=
X-Google-Smtp-Source: APXvYqzeKYGvuSHFBNW/Y9eVcKhOKSFItROGUQWz27VTENOhtTRcF5GmgL5soD7VFDKrXgUsBTckxCXi8tgN7NWQPwE=
X-Received: by 2002:adf:efcb:: with SMTP id i11mr14164356wrp.229.1574148712062;
 Mon, 18 Nov 2019 23:31:52 -0800 (PST)
MIME-Version: 1.0
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
 <1574007266-17123-3-git-send-email-sunil.kovvuri@gmail.com> <20191118132811.091d086c@cakuba.netronome.com>
In-Reply-To: <20191118132811.091d086c@cakuba.netronome.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Tue, 19 Nov 2019 13:01:41 +0530
Message-ID: <CA+sq2CcrS4QmdVWhkpMb850j_g3kvvE1BriiQ2GyB-6Ti1ue2A@mail.gmail.com>
Subject: Re: [PATCH 02/15] octeontx2-af: Add support for importing firmware data
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linu Cherian <lcherian@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Vamsi Attunuru <vamsi.attunuru@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 2:58 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Sun, 17 Nov 2019 21:44:13 +0530, sunil.kovvuri@gmail.com wrote:
> > From: Linu Cherian <lcherian@marvell.com>
> >
> > Firmware data is essentially a block of one time configuration data
> > exported from firmware to kernel through shared memory. Base address
> > of this memory is obtained through CGX firmware interface commands.
> >
> > With this in place, MAC address of CGX mapped functions are inited
> > from firmware data if available else they are inited with
> > random MAC address.
> >
> > Also
> > - Added a new mbox for PF/VF to retrieve it's MAC address.
> > - Now RVU MSIX vector address is also retrieved from this fwdata struct
> >   instead of from CSR. Otherwise when kexec/kdump crash kernel loads
> >   CSR will have a IOVA setup by primary kernel which impacts
> >   RVU PF/VF's interrupts.
> >
> > Signed-off-by: Linu Cherian <lcherian@marvell.com>
> > Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
> > Signed-off-by: Vamsi Attunuru <vamsi.attunuru@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
> Again, confusing about what this code is actually doing. Looks like
> it's responding to some mailbox requests..
>
> Please run checkpatch --strict and fix all the whitespace issues, incl.
> missing spaces around comments and extra new lines.

I did check that and didn't see any issues.

./scripts/checkpatch.pl --patch --strict
0002-octeontx2-af-Add-support-for-importing-firmware-data.patch
total: 0 errors, 0 warnings, 0 checks, 349 lines checked

0002-octeontx2-af-Add-support-for-importing-firmware-data.patch has no
obvious style problems and is ready for submission.
