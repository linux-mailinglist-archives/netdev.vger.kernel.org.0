Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038CB28FCE9
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 05:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394165AbgJPDbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 23:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394161AbgJPDbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 23:31:43 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70787C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 20:31:43 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id o4so2004819iov.13
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 20:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ji2Vjm1Z9a/WK/S/7DljCv+8mumo7ML1VdJsHBQ5NAo=;
        b=n8KmmtBhB/oBQcmHdtEM4zD9u2lnZZ+rY/d3hcUavW3LA0IuhfCVeKTgudaHRB7Ljw
         sEgqByPrwNmJ/GFSCo95jGwvW6FnXAmaAfvBhbaLolFK/WbEEZQMUDx08s0fok8CLMz7
         vQc1VIGR2ifrcfeuKz5pEwBksLRHP1vRC+1JtxFjZO4PryH4ezncAEQaxaSRxmyUb600
         4B1lq1rxUAt2cY8tSZ3KUS00Cy7Q6aHd20k0h6W/xf5X9XMvCMNKPapi4Tp5Bs/sJo2N
         TAfq6JbwvEru4qTrcRv7jsyyuhwn2g2LsTmtaGxDdSoN2ak0Cj8RpIid2uFVd9U02T81
         lWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ji2Vjm1Z9a/WK/S/7DljCv+8mumo7ML1VdJsHBQ5NAo=;
        b=gKPz55oGhP0qpSxk28qBwHpi32DsE5x02U5x+/WmcOV4DCcMzA3T302d+n8th6aHQG
         UhnYhTK/Pckp5Ulm3wvG6F63XWq151kdkui3FU0Q67FLokATmXLS0xfmbVKn0G8CHiEo
         eIR2B+pONqn3AU66tpEVDyytWPwVVvxLy2zn1AM1OYh7BgdwG7LWoR268Ss7Bg0+xMP6
         FTcN+9d5yv1OYZl/7lFcX1nLJuhSyIMF2WcoLbW4lfj2K+7UFCrAEra5QSUOUC5AZrOy
         NtJ6USW1OXulEIdGt1Wxp2EgOhBD2OKFE+vfltGvvfJMuydFvu48XAgLYiWZC/XM0DdI
         uA0w==
X-Gm-Message-State: AOAM532ekhaYVEweH9fzv2+1jUv11QhZ444IaeZr43XWUL4jLRpGtJ1X
        c5kP6DvgLSUSgdh8hcMt5mcGx25E5enH4lJSJEI=
X-Google-Smtp-Source: ABdhPJzHMXf2yQZHR3UEA0IfSc8TVv17X7KIKgrYaTitUctp9uGJNDMuRrLTjfAVQm1zU9y+0Wuf0YIt8Fd3DavXuJ4=
X-Received: by 2002:a6b:fc18:: with SMTP id r24mr965085ioh.127.1602819102768;
 Thu, 15 Oct 2020 20:31:42 -0700 (PDT)
MIME-Version: 1.0
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
 <1602584792-22274-2-git-send-email-sundeep.lkml@gmail.com> <20201015085754.000037d9@intel.com>
In-Reply-To: <20201015085754.000037d9@intel.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 16 Oct 2020 09:01:31 +0530
Message-ID: <CALHRZup8LuYMZNCirgCP948q3Ouu30cFPXt_C7_DfJoF-X7cNA@mail.gmail.com>
Subject: Re: [net-next PATCH 01/10] octeontx2-af: Update get/set resource
 count functions
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        rsaladi2@marvell.com, Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesse Branderburg,

On Thu, Oct 15, 2020 at 9:27 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> sundeep.lkml@gmail.com wrote:
>
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > Since multiple blocks of same type are present in
> > 98xx, modify functions which get resource count and
> > which update resource count to work with individual
> > block address instead of block type.
> >
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
>
> LGTM
>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Thank you,
Sundeep
