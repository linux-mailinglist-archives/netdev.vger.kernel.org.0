Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311177D255
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 02:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfHAAol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 20:44:41 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37823 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfHAAol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 20:44:41 -0400
Received: by mail-ot1-f66.google.com with SMTP id s20so6717747otp.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 17:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FwrY14/rA4YnTcEaKkYTP5TSJlckznr4xniXZWLqSIs=;
        b=DBOI06OLegNR8ZR+FlLTPHMxEnpeXS+lrfvtmdV36VmJ7qv3AQzm84/2M5ZcbYEwTU
         vBgC1+QMNkp517guFSzS6SjVGx2ZGO8FQ45mSuPuYqa6kA/n5xCSV2JK5Kob+hTzqprn
         GhlqVSXdH8ibuNrj4lA0UYBgrf/SbvU9bnGcC3vLma7iEeP8z8XkQMtOZumLjBQb2RVP
         NPcQFSv+BLQc7UdanpZ5sXkwIGrhs6o27wJ5Q1lupx5222DZ3D9HFZwzuWGRXEB5Frx0
         Qa3ZTspE+B8Ibqxcu5NIFEyv1bgX1toOOjYf572sIU2gxD1ZOND9a7FrwP6ZgYE8X7JQ
         XK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FwrY14/rA4YnTcEaKkYTP5TSJlckznr4xniXZWLqSIs=;
        b=raIO1H1Dwmf0cebu+N+XFzY67U44R0agAfbNkzdPjq0N1cR7Re3DbT9z3Y8V6ImK9L
         evI9v63l/Xe/e6MyOHaQmmPFx5u97KWcNcyXIT1xKyE9v/ZasosuNtXFnwqv/sOQZIyg
         eCuoE1JL9IjjNJ4k0XtRtQhqCE2dhNxjOVQ36+qugMz55R7Agz6E0rS+C4zDrk7mSIee
         BtB1rxZ6AqqC0N0T1L/mciIGDmL9eMj6VmOUc8MAHLG2cgCwfbh6Q2KFBn+eq4WfyVWa
         ppplRx8clvYX+z0T9GrZIV0NoYaqkMVwMB6HTsKeka7jL27pE+GKLcYOBW+MwaS2Vo0C
         HGzQ==
X-Gm-Message-State: APjAAAW4zUrYudbib2mdaLlhyhzcmrlFMea9ibsDIPI9iPWNAYHBMkY2
        L692oX/iBDwMjTN5nd6eKsREJ1kpW592gxMYw1s=
X-Google-Smtp-Source: APXvYqy4ReT1PSjiPMdKfowY/Vf2trazFcklqLwGG/eDnfSY8h71ohr6BEUMDkMO0N1gn4LGUh8bACs897RSlI7C6bo=
X-Received: by 2002:a05:6830:1155:: with SMTP id x21mr47592882otq.336.1564620280804;
 Wed, 31 Jul 2019 17:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAJ3xEMhAEMBBW=s_iWA=qD23w8q4PWzWT-QowGBNtCJJzHUysA@mail.gmail.com>
 <CAMDZJNV6S5Wk5jsS5DiHMYGywU2df0Lyey9QYzcdwGZDJbjSeg@mail.gmail.com>
 <CAJ3xEMgc6j=+AxRUwdYOT6_cP69fY-ThVVbF+4EqtZGQ+-Sjnw@mail.gmail.com>
 <CAMDZJNU=8BHZJs95knTzuCv=7X3BXbqHrZAznOOcK2m_7QO2Pw@mail.gmail.com> <CAJ3xEMj43wFacxR1bfqG8B0yVPiPyCh=DT5S3TojV8S8ZHaDsA@mail.gmail.com>
In-Reply-To: <CAJ3xEMj43wFacxR1bfqG8B0yVPiPyCh=DT5S3TojV8S8ZHaDsA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 1 Aug 2019 08:44:04 +0800
Message-ID: <CAMDZJNWZ=s-yf7vho0zHySD01uOZzbUdcFmgu+Rk=p-nRoHN=A@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Allow removing representors netdev to other namespace
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 12:49 PM Or Gerlitz <gerlitz.or@gmail.com> wrote:
>
> On Wed, May 22, 2019 at 4:26 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> > I review the reps of netronome nfp codes,  nfp does't set the
> > NETIF_F_NETNS_LOCAL to netdev->features.
> > And I changed the OFED codes which used for our product environment,
> > and then send this patch to upstream.
>
> The real question here is if we can provide the required separation when
> vport rep netdevs are put into different name-spaces -- this needs deeper
> thinking. Technically you can do that with this one liner patch but we have
> to see if/what assumptions could be broken as of that.
Hi Or,
Can we add a mode parm for allowing user to switch it off/on ?
