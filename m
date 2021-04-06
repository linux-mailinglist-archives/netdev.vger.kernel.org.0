Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924D2354E1E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 09:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbhDFHpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 03:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhDFHpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 03:45:01 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EF9C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 00:44:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w23so4083322edx.7
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 00:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HKnf1ynLeGSMbju98Hc0LWmOiOvEb9aDCabA865nDh8=;
        b=Zq2iMYivUbR7vBLHG5bMoIZzOAF5mZAMcawEGjRM9+dvMpj4XUn+ZMMkoqL4T9GbiE
         K82TcnzfofHur83wzVkxUkkdzuIjlvgoW12FLvRaMCIBHhm5rbXu8rHdin9v0tVkVnlQ
         fyWevjiltjh73RoVQ2yYhrENes7qtQkxednEFLHINGnHHHa9dkfQsJgzUJzy+f+cZfbQ
         4sBiQIXep69XQhXyqrGLbm1gPDbDp6gNI8srNUjcwLYOelW5NQAjQLWe3CcW9+JpQIOa
         /ZZ6Nn/00jGfY+diJ/6L3+ZczRjGO83CteIZ1yGZrOmsB39RTpb8En4nPpX7esBFTkIp
         VF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HKnf1ynLeGSMbju98Hc0LWmOiOvEb9aDCabA865nDh8=;
        b=XLe7bMnWWa6dSwmTMh+ug5jqtyI26ZfjNUh1N7wFSKvJ0ROs3Hg6fSuTXu8rBAolTM
         H4AwnOfCyCo5OMbSl0weraC7LbtKh8IobKGtS7jE3JLY1PicqJl6UDqxpQeCAPx72AuJ
         Vk1IDUIckpqEG5mVIyoM+beMxrVlcrWBaor9Q22mU1LYSqbxU4RW0Ca0768Tw58tDOCw
         RGJ95umL5ulwyw3V1OBkl/FdfJFGE3qzhOJm5LgmvH6jObnyHAVMpKqqsX6TzvvtIkBF
         dOsQjjFnsb9vjRF6eQygn77waRVzl+/YHWbnFuTCFfVleYT5JcuI1p+2vg+URB/nj1Xz
         3d0g==
X-Gm-Message-State: AOAM5334Jt0/gYcFK6yT98l9YMR1FeF5kGT32+YMJ6x3nL1l8YO4EkNi
        Wof1323KkYk+ijTSPAnICabkcYEm+zztAJtEJRBmA0sT
X-Google-Smtp-Source: ABdhPJyLDb+F6oE5OyZJOvZ5pzorERGYfQLA3kxqSr+Zs4DI8oeW9zWT0x+xHohyeOtJD/8lMqpTgTvovDMAAM5KOag=
X-Received: by 2002:a05:6402:145a:: with SMTP id d26mr35993605edx.182.1617695092232;
 Tue, 06 Apr 2021 00:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAOJPZgkLvkhN4+_OCLPyWBiXPRc=qLYa3b5jyz63dkn7GQA2Uw@mail.gmail.com>
 <026c789b7d3b6f81698803cc9ef86c3467d878d5.camel@kernel.org>
In-Reply-To: <026c789b7d3b6f81698803cc9ef86c3467d878d5.camel@kernel.org>
From:   =?UTF-8?B?6auY6ZKn5rWp?= <gaojunhao0504@gmail.com>
Date:   Tue, 6 Apr 2021 15:44:42 +0800
Message-ID: <CAOJPZgmfjXkgCqgS4JQ_phtXEpDRpmjE6HJnF6MXoisN7RnpZQ@mail.gmail.com>
Subject: Re: esp-hw-offload support for VF of NVIDIA Mellanox ConnectX-6
 Ethernet Adapter Cards
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     borisp@nvidia.com, Huy Nguyen <huyn@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, netdev@vger.kernel.org,
        seven.wen@ucloud.cn, junhao.gao@ucloud.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping ...

Saeed Mahameed <saeed@kernel.org> =E4=BA=8E2021=E5=B9=B43=E6=9C=8830=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=885:05=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 2021-03-29 at 16:42 +0800, =E9=AB=98=E9=92=A7=E6=B5=A9 wrote:
> > Hi Boris,Saeed
> >
> >      I'm enabling esp-hw-offload for VF of NVIDIA Mellanox ConnectX-6
> > Ethernet Adapter Cards, but it doesn't work.
> >      Before I created VF, the esp-hw-offload function of CX-6 is on,
> > after I created VF, the esp-hw-offload function of VF doesn't inherit
> > the esp-hw-offload function of CX-6.
> >      Enable esp-hw-offload could refer to
> > https://docs.mellanox.com/display/OFEDv522200/IPsec+Crypto+Offload.
> >
> >      Create VF steps as follows:
> >      modprobe mlx5_core
> >      echo 2 > /sys/class/net/net2/device/sriov_numvfs
> >      # lspci to get pci bdf number(example:0000:07:00.0)
> >      lspci -nn | grep Mellanox
> >      echo 0000:07:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
> >      echo 0000:07:00.3 > /sys/bus/pci/drivers/mlx5_core/unbind
> >      /etc/init.d/mst start
> >      mcra /dev/mst/mt4119_pciconf0  0x31500.17  0
> >      devlink dev eswitch set pci/0000:07:00.0  mode switchdev encap
> > enable
> >      echo 0000:07:00.2 > /sys/bus/pci/drivers/mlx5_core/bind
> >      echo 0000:07:00.3 > /sys/bus/pci/drivers/mlx5_core/bind
> >
> >      Then query the esp-hw-offload of VF:
> >      #firstly need to find the created VF(has the properties:
> >      bus-info: 0000:07:00.2, driver: mlx5_core)
> >      ethtool -i eth0 | grep esp-hw-offload
> >      esp-hw-offload: off [fixed]
> >
>
> Huy, Raed, Do you know if we support IPsec inline offload on VFs ?
>
>
