Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B48331D4A
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 04:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCIDEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 22:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCIDEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 22:04:30 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA87C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 19:04:29 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id d3so24534876lfg.10
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 19:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jO15/awhroqxhgWC0DcldVkMjKJaQJqM/HacGSPP2jw=;
        b=XgVeaU/YSyr9G9TDCLJTjZDUZgTJ7BdkqrrxjCNGQc/8S6rB4C3z/XTwUw39SMbNMd
         12SXfztgxgap/4If0mZTENVkO6F82ZNyWeSJTSfNiBnIEVjhJ8vtXrvzIqRXy2MctUeT
         sQ4GUpd+k8vFZvq5gRzko/dgbpZ16q6IN7BBH3dn+JkRhwwfoM9u6rO/mx710lYVXHam
         D6ktTM28ZDA/JaS2vmloaRqjUIAUeWmKMoNFvwhMi+1M8oSaiAmEtaXl+CHzrpoOD0A8
         lKe8VuZjF8Kfuj+JXMYkCGZXHtWPwMUD/YBGZBjeB8/fhJA2+zIg6lVnOAhEc6MgqLT4
         +xuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jO15/awhroqxhgWC0DcldVkMjKJaQJqM/HacGSPP2jw=;
        b=mF5uKA/Dvx36pIyS8R0SbLLEZibShaiM3KtY+tSKXu2/tSFhfdOY9RoNylH/JZ+YOw
         6vbK+ULlzcSvJIw1HP/1/tvzoDVMJ6YzBV/Urb1QJiv9edX81TPTSGc4myWzQ3pNx476
         cgE8ryC6Diic6cvLyybaqY+RSyrnSqdeTTQK3QV00C360Bj7tuU9YtsEdJNJP6DNtq9v
         jWJ39zcO+BDRDJU/zosCASWIkMLYgbW/Lubd0t+uJ91ViETbLJIrsQStNjSmtJSj7Y1i
         IWLKCzLjb1+mmgt42qwYVRQzCLRcchhbl5M/9eJOnjTdGKikcFZ6a74zADBF1UYzuWkv
         JUYw==
X-Gm-Message-State: AOAM532R2jc9JeOK0qR6oLA6vnCbQSnX4aZU5dR4P4T38gdbyuD19ED+
        UDmnmzYC7zZTap+iDekBIXu63TZsYxTd77rvqqIAqBkauvd6/A==
X-Google-Smtp-Source: ABdhPJwk/5HMWRI0J8btLKzBfQ3ZTMBgzOCabpNSsbHys5/oGe01fQvslrGZuS79zziNnei9VoRhCAe8Lbwt766nbwo=
X-Received: by 2002:ac2:4292:: with SMTP id m18mr1502972lfh.430.1615259068418;
 Mon, 08 Mar 2021 19:04:28 -0800 (PST)
MIME-Version: 1.0
References: <CANS1P8H8sDGUzQEh_LEFVi=6tUZzVxAty9_OKWAs4CU67wdLeg@mail.gmail.com>
 <BY5PR12MB43226FF17791F6365812D028DC939@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CANS1P8E8uPpR+SN4Qs9so_3Lve3p2jxsRg_3Grg5JBK5m55=Tw@mail.gmail.com> <b026b2c8-fdd5-d0fc-f0a6-42aa7e9d26f8@gmail.com>
In-Reply-To: <b026b2c8-fdd5-d0fc-f0a6-42aa7e9d26f8@gmail.com>
From:   ze wang <wangze712@gmail.com>
Date:   Tue, 9 Mar 2021 11:04:17 +0800
Message-ID: <CANS1P8EHJ+ZSZT8MT43PzXH6bhZ6FVhrQ_sxxFWbWTvzyT+3rA@mail.gmail.com>
Subject: Re: mlx5 sub function issue
To:     David Ahern <dsahern@gmail.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
      I can see that the variable settings are in effect=EF=BC=9A
# mlxconfig -d b3:00.0 s PF_BAR2_ENABLE=3D0 PER_PF_NUM_SF=3D1 PF_SF_BAR_SIZ=
E=3D8
# mlxconfig -d b3:00.0 s PER_PF_NUM_SF=3D1 PF_TOTAL_SF=3D192 PF_SF_BAR_SIZE=
=3D8
# mlxconfig -d b3:00.1 s PER_PF_NUM_SF=3D1 PF_TOTAL_SF=3D192 PF_SF_BAR_SIZE=
=3D8

after cold reboot:
# mlxconfig -d b3:00.0 q|grep BAR
PF_BAR2_ENABLE                           False(0)
# mlxconfig -d b3:00.0 q|grep SF
Description:    ConnectX-6 Dx EN adapter card; 25GbE; Dual-port SFP28;
PCIe 4.0 x8; Crypto and Secure Boot
         PER_PF_NUM_SF                   True(1)
         PF_TOTAL_SF                         192
         PF_SF_BAR_SIZE                   8
# mlxconfig -d b3:00.1 q|grep SF
Description:    ConnectX-6 Dx EN adapter card; 25GbE; Dual-port SFP28;
PCIe 4.0 x8; Crypto and Secure Boot
         PER_PF_NUM_SF                  True(1)
         PF_TOTAL_SF                        192
         PF_SF_BAR_SIZE                  8

I tried to create as many SF as possible, then I found each PF can
create up to 132 SFs. I want to confirm the maximum number of SFs that
CX6 can create. If the mft version is correct, can I think that CX6
can create up to 132 SFs per PF?

David Ahern <dsahern@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=888=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=8811:48=E5=86=99=E9=81=93=EF=BC=9A
>
> On 3/8/21 12:21 AM, ze wang wrote:
> > mlxconfig tool from mft tools version 4.16.52 or higher to set number o=
f SF.
> >
> > mlxconfig -d b3:00.0  PF_BAR2_ENABLE=3D0 PER_PF_NUM_SF=3D1 PF_SF_BAR_SI=
ZE=3D8
> > mlxconfig -d b3:00.0  PER_PF_NUM_SF=3D1 PF_TOTAL_SF=3D192 PF_SF_BAR_SIZ=
E=3D8
> > mlxconfig -d b3:00.1  PER_PF_NUM_SF=3D1 PF_TOTAL_SF=3D192 PF_SF_BAR_SIZ=
E=3D8
> >
> > Cold reboot power cycle of the system as this changes the BAR size in d=
evice
> >
>
> Is that capability going to be added to devlink?
