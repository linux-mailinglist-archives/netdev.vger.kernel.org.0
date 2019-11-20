Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E468104213
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfKTR1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:27:53 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39950 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfKTR1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:27:53 -0500
Received: by mail-wm1-f66.google.com with SMTP id y5so487431wmi.5
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULqX+PhB8rVigfApzVN1hTvp/5xDuRhjEuggQtNz+1U=;
        b=EilpFIUMOIFBvbZs7Dkg83HlP9Vi/Q1tUd4A0WuGMB9ZD2ZXcIWjArq7xLaaez8lDa
         BIaDIlyVBU0dlf7dyDAN9WPKMlxPlsth4VtQz9SbnefFV4pAcZcZPjnAeqH1+yg1bm2G
         99ZzpCaxS2kIbGKhVRVaso1A7Zazy41TAadl1X3SqkDvL+Fbz73Y0OjdenvcXXFV2oFa
         RKXJPW9gAIGWs7AOCA2jxdYXOI3CNGQuzYWhBqbvZkk8fjDVTPdkA+u/Np7PevGj6tPD
         hnI9wQluwKXO6JognkB3IplWOk/BzjBgu9uDdo+MtTGwdplfoyj6EFXSIGJDLWrxJ666
         LkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULqX+PhB8rVigfApzVN1hTvp/5xDuRhjEuggQtNz+1U=;
        b=bHGgF5xLBYA2+tD/OYuLiGQdKeod2YYtrGzbxBz1541+g/aCVDndXfg2iCIyoWIxIm
         cE10CVj5c6/ufkjB1mt3jClA0AyK4MpJ/0XZe0jzO4/gfjnooyRrzCBDY4ubPtJeyb7T
         fzjOvSIbFtYdbiaIPdrVM2GtUf3C4PWpy50MqLLPIKufNJO8rzAbUZ+l4RxaYwuZu56M
         RM5X4SkZiHHaopWa+MnzMyaPM7cUazDRorSySKrLKIv2hWeqbb82Fdo79l/pfNhFDfNp
         oZnJ0mCuRoaN3+NqSkwPZsAexvrZtpuEyIAcFRmsp4qavlRDgQHvLBWv98llYUdjSJY0
         9D5w==
X-Gm-Message-State: APjAAAUceCKN17nQ3LooV5GNWT/l8H5pm7wMblwo5ZkecyNYCCv9LKJ7
        Dfcnp7teGRVwzcpebOEczikjVWO16Ws35Y5M0fE=
X-Google-Smtp-Source: APXvYqwhy7JxduDGn+hVwmQEW534X7cC5j/AY9sI2a8TNo8HkaIf89SkAXXMZfAmGKw3zTCohwHD/eyPI8C47lXdJjc=
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr4557325wmu.108.1574270871606;
 Wed, 20 Nov 2019 09:27:51 -0800 (PST)
MIME-Version: 1.0
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
 <1574007266-17123-3-git-send-email-sunil.kovvuri@gmail.com>
 <20191118132811.091d086c@cakuba.netronome.com> <CA+sq2CcrS4QmdVWhkpMb850j_g3kvvE1BriiQ2GyB-6Ti1ue2A@mail.gmail.com>
 <20191119133841.16f91648@cakuba.netronome.com>
In-Reply-To: <20191119133841.16f91648@cakuba.netronome.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 20 Nov 2019 22:57:40 +0530
Message-ID: <CA+sq2CcuXCbjSfijCUcU+e+TuGetSPsOhTRT98QisQD0q0LxKQ@mail.gmail.com>
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

On Wed, Nov 20, 2019 at 3:09 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 19 Nov 2019 13:01:41 +0530, Sunil Kovvuri wrote:
> > On Tue, Nov 19, 2019 at 2:58 AM Jakub Kicinskiwrote:
> > > Again, confusing about what this code is actually doing. Looks like
> > > it's responding to some mailbox requests..
> > >
> > > Please run checkpatch --strict and fix all the whitespace issues, incl.
> > > missing spaces around comments and extra new lines.
> >
> > I did check that and didn't see any issues.
> >
> > ./scripts/checkpatch.pl --patch --strict
> > 0002-octeontx2-af-Add-support-for-importing-firmware-data.patch
> > total: 0 errors, 0 warnings, 0 checks, 349 lines checked
> >
> > 0002-octeontx2-af-Add-support-for-importing-firmware-data.patch has no
> > obvious style problems and is ready for submission.
>
> Oh well, checkpatch didn't catch any errors so you didn't care to look
> for mistakes I pointed out yourself?
>
> Let me ask you again, please fix all the whitespace issues incl.
> missing spaces around comments and extra new lines.

Okay will check and fix.

Thanks,
Sunil.
