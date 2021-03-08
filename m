Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79F43308C4
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 08:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbhCHHWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 02:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhCHHWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 02:22:08 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40C9C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 23:22:07 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id p15so14728696ljc.13
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 23:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nOCsf3TvjDbLoHZ+E43Qbfo/UVnC7vzOmcssXnWKgIU=;
        b=LTYxMZpbirfW9NS3/H2t9WsZ1J8VldWjdnRYUwT3nECj78wsMImFgNrs4w2BLwwklB
         I1rdtY7jjV0vYIbJ/aJAWNLxQSrZ1C33xs021R3m3JoQodMDYK/JZvLcDe9LCDnloWkk
         lyKJrpi5lmX/Kah3M1XOFhqKII8WUonwFQin+NLxYVimX6x4uN+YbpVyfFN7Ql6Oet49
         748ghRT4MHDrIIarQxoC9xMKzcUpzAivy1/MZ4+8sELRzJbqMu1P92NjpXDatuntxFvK
         J1F5kACrItYFQ57oKVBdFHL3VVBOoCBDhB3l+MbzFi1rmE1/p/T+ZenTS2t+ZPSiAFjA
         E1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nOCsf3TvjDbLoHZ+E43Qbfo/UVnC7vzOmcssXnWKgIU=;
        b=cf1U3EK7VAYi8JvfJhsJAb5j6qPxCNn6xpwq0EhDw7+4uCLdFdF6ejdng8ND2lG1WL
         S9q3aR4siBbr8yjZ/xPJX1OpcXqFJEZUvp+LcFrkwoSF3OwuzlRDoQotPyar7jSW/X89
         z9H0uJqt4GiD1oRJfGDKdKy29fqhutoDnEVBXGMpipC/NWi2G9XoK71tz20bDgHtI9cd
         LB3MUPgvU4XKgSZSWbtxHJzqWbD0exqMhBEpcg4EHzZsd1SbFOmhim8lmDnp83QrRuHM
         U4ZEPj3E3ZmeOtbNstEeK+lmEzF9KOZL9tThzFWV3QHMd0mbYRZ8TM3gNY8uqpNY+/ts
         YzFA==
X-Gm-Message-State: AOAM532M1uLmYAMYSYXenQem0seZqmQI9hP/4NW8pj3xrA+A2gpF+RKl
        j0flyQA78Pn9iRLBtlT8o6wwlk27zRW/EB6R/cA=
X-Google-Smtp-Source: ABdhPJz/ZuEisxlN+tuZRbk7Og8zA8fu1pXglOH0z2zcwpxcguYinlZBr5fW7Jg4R3duRU2j8AIITCqEtJ9qf3EtaiY=
X-Received: by 2002:a2e:a0cf:: with SMTP id f15mr13920533ljm.29.1615188126421;
 Sun, 07 Mar 2021 23:22:06 -0800 (PST)
MIME-Version: 1.0
References: <CANS1P8H8sDGUzQEh_LEFVi=6tUZzVxAty9_OKWAs4CU67wdLeg@mail.gmail.com>
 <BY5PR12MB43226FF17791F6365812D028DC939@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43226FF17791F6365812D028DC939@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   ze wang <wangze712@gmail.com>
Date:   Mon, 8 Mar 2021 15:21:55 +0800
Message-ID: <CANS1P8E8uPpR+SN4Qs9so_3Lve3p2jxsRg_3Grg5JBK5m55=Tw@mail.gmail.com>
Subject: Re: mlx5 sub function issue
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Parav,

Thanks for the answer.
There are more than two hundred CPUs on our machine, we're planning to
put SFs into the containers, This may requires allocate one SF per
CPU,so we want to know the upper limit of creating SFs.

By the way, the latest version of the MFT download center is 4.16.1-9,
does this meet the 4.16.52 version requirements? If not satisfied,
where can I get mft-4.16.52?

Ze Wang


Parav Pandit <parav@nvidia.com> =E6=96=BC 2021=E5=B9=B43=E6=9C=888=E6=97=A5=
=E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=881:17=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Hi Ze Wang,
>
>
>
> How many SFs do you prefer to create?
> What applications would you like to run on more than 128 sfs?
> How many CPUs do you have in system which will use this many sfs?
>
>
>
> You need to use following.
>
> mlxconfig tool from mft tools version 4.16.52 or higher to set number of =
SF.
>
> mlxconfig -d b3:00.0  PF_BAR2_ENABLE=3D0 PER_PF_NUM_SF=3D1 PF_SF_BAR_SIZE=
=3D8
> mlxconfig -d b3:00.0  PER_PF_NUM_SF=3D1 PF_TOTAL_SF=3D192 PF_SF_BAR_SIZE=
=3D8
> mlxconfig -d b3:00.1  PER_PF_NUM_SF=3D1 PF_TOTAL_SF=3D192 PF_SF_BAR_SIZE=
=3D8
>
> Cold reboot power cycle of the system as this changes the BAR size in dev=
ice
>
>
>
> Parav
>
>
>
> From: ze wang <wangze712@gmail.com>
> Sent: Monday, March 8, 2021 7:22 AM
> To: Saeed Mahameed <saeedm@nvidia.com>; Parav Pandit <parav@nvidia.com>
> Subject: mlx5 sub function issue
>
>
>
> Hi all,
>       I have some confusion with mlx5 sub function feature. I tested it w=
ith Mellanox ConnectX-6 Dx recently, then I
>
> found the maximum amount of SF in each PF is just 128,I=E2=80=98m not sur=
e if there is a problem with my configuration,
>
> or there are some limits of SF in ConnectX-6.
> Here is the environment:
> system: CentOS Linux release 7.9.2009
> NIC:  Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
> firmware-version: 22.29.2002 (MT_0000000430)
> kernel: net-next master branch https://git.kernel.org/pub/scm/linux/kerne=
l/git/netdev/net-next.git/
> mlxconfig:
> PF_BAR2_ENABLE    True(1)
> PF_BAR2_SIZE      8
> PER_PF_NUM_SF     True(1)
> PF_TOTAL_SF       65535
> PF_SF_BAR_SIZE    0
>
> When I tried to create more SF:
>
> ~# devlink port add pci/0000:b3:00.0 flavour pcisf pfnum 0 sfnum 128
> devlink answers: No space left on device
>
> Is there anything missed in configuration? Can I create more sub function=
s in ConnectX-6?
>
> Trully yours,
> wangze
