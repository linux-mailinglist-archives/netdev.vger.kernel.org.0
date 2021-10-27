Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8174243CEE3
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbhJ0QqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239719AbhJ0QqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 12:46:19 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76B8C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 09:43:53 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m17so12073184edc.12
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 09:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=lcG155bszJZKa/I5yFHkXvPvP1zyYSHlOzks09pl2zY=;
        b=CF8+A6/f8PXLG/aTZXuommuPzs0l6n2O6rWF9SNUhLyswn9xwZKT+7ySBTNUIngvAL
         sIluuZXdaKGkbLwNcmrDXkzCAVAvUJgbj/noZraC+IRryMz6XI/p/CcFR4WvnaV3/yWo
         i/Ot0tIRxmTCD4JQphw5e3sJ90M00z42FEVfW5U3Nod6OnrtpOXuHWsKQ2EPVfHZ9jfr
         tJUHg4IwQdfxG4SQiub4AL/8oo5qOgZbCjWYMIDWoNIgNT3EqybIvxtWMOFvIjqyh+V9
         gpgHMM5EHAajZwCi9t/XByDjLmX9vfCtk6CePxOPK8O8WLRyNkVC29Y/KzPGHs3KiXNc
         Dh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=lcG155bszJZKa/I5yFHkXvPvP1zyYSHlOzks09pl2zY=;
        b=7a8G4ts4deUKxiD5pqgNXtILcxqH+/KEOVGIu4rLmidm1ukSBB1cHGM7vdC+KEw31I
         7DaSnWbuDzw4/3MycLZSv5C4VtxUgHLWQ7pP2+mGbaXvkEpwopF7RjyVjLNi5ARw4ozm
         8HubGnFNO++iRsrVxq7NWnukO9rxoZKy+5nnNMlqaunr6lg9X9CarTDvsdF1yLc1D/V3
         DUUO3M8hRmQmm3Kk/jjTax/GYbS8uAEav1vgUODGC/KoR/l1apjNe69MrT1/CzKsf4IW
         7S+CKqE2qqhI7W4CrZC5CNNzbzt/TBqpc5e3erSudTBko4fO0zV1fG+qHngXuct90WF3
         H7qw==
X-Gm-Message-State: AOAM532aM/DYhf54o1ONnUYMr7OIbi6Alj24z4jgNX5k4FOdoLdBQEJ5
        MbcisSVYkj1m8SlTffVwfoh7kp9j5xfB2MsZbEQ=
X-Google-Smtp-Source: ABdhPJyMjIDHLxOS8yUleXmMZwGDpW6t0LEd2uev890EQVIakaQMtzHvxhGdT28kP47yU8O+hZTLlt76rszt88t+jDM=
X-Received: by 2002:a50:bf08:: with SMTP id f8mr44637495edk.400.1635353025096;
 Wed, 27 Oct 2021 09:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
 <1635330675-25592-2-git-send-email-sbhatta@marvell.com> <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 27 Oct 2021 22:13:32 +0530
Message-ID: <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
Subject: Re: Fw: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink
 param to init and de-init serdes
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rakesh Babu <rsaladi2@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi  Jakub,

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, October 27, 2021 9:08 PM
> To: Subbaraya Sundeep Bhatta
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Hariprasad Kelam; Geethasowjanya Akula; Sunil Kovvuri Goutham; Rakesh Babu Saladi; Vamsi Krishna Attunuru
> Subject: Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to init and de-init serdes
>
> On Wed, 27 Oct 2021 16:01:14 +0530 Subbaraya Sundeep wrote:
> > From: Rakesh Babu <rsaladi2@marvell.com>
> >
> > The physical/SerDes link of an netdev interface is not
> > toggled on interface bring up and bring down. This is
> > because the same link is shared between PFs and its VFs.
> > This patch adds devlink param to toggle physical link so
> > that it is useful in cases where a physical link needs to
> > be re-initialized.
>
> So it's a reset? Or are there cases where user wants the link
> to stay down?

There are cases where the user wants the link to stay down and debug.
We are adding this to help customers to debug issues wrt physical links.

Thanks,
Sundeep
