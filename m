Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0366C718B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjCWUHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCWUHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:07:03 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0465E28E8B;
        Thu, 23 Mar 2023 13:07:02 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id y20so29350527lfj.2;
        Thu, 23 Mar 2023 13:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679602020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dx0LNrSnDNSxghRtdZKIgvcKSai0Xv19sa2pKVBtm0=;
        b=PtHSPpgV3RWyesi9nMsqNsp5f+gP7vlw/NInZXvqLdqOaCrTUhSRqXJHuw0a+h6np4
         XsmOlw0hcSSclkJme5yM1+36sK2kpfa/Ig2R0yN/21fSwVHfpgTf0rZmONLEANeWXoXu
         B63lmGeK3K5a3Pd8H+DwbQxT47zg8gfVIZ8JOEMcELj+9D9bvMK+yqmaHDEIy/xm/T9H
         8LuyCyR8rPdTHJKc4KpTP3NFc4tU7XTwItQjnHuHPc3gYwvPNE50ordCIgXQlftScW5V
         J9CgGhccQOBbrpio7S68rBjk0PvsJkNz36fxIrYQz27LMQaInhfkqxP/n7zSq6YispzI
         gx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679602020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dx0LNrSnDNSxghRtdZKIgvcKSai0Xv19sa2pKVBtm0=;
        b=VYNnKwW22Gxk6BJhoh47f01BEmQvk2WEHCnerdABnB2+pKI1GJjkyNokM7JTfjyNs4
         QXWhKJojg/rER5AoO9Y0IwfDMWEvd+q5kFCKJCLap0kmu7yWYpcKu1CsuhMIYsveK/up
         HRWA6Jaw5UTH9v7c/h4MNyHXdVSRK3uAo5jH38m6OJUM7lXociqRPHIRuiCU/cdJOF1G
         FyylU7gmr/wIci0Fv14oq6ZsBH11UKSLtn8uF8cElwmRU7zhX/0rpQ7zdlbLs/LAdFxP
         geHGu0hWzwPLrp91jVF0EdX9M49da36ShStHRCx50ncZLaCAenmSB3c2H6++Ebso3SIi
         STAA==
X-Gm-Message-State: AO0yUKU4WBI5Y/VnL4I3Dt4drOL5lhWW727T5G2UNol/li/a1PpRTt3Y
        Nx0g/adhSenVHHRsWD0uUGpN4YynXMoEHhW44scZ3i2X
X-Google-Smtp-Source: AK7set/o3pCVnKMNC2+I4YvRtdLo7f8opwJWz17r7RNwCnow/FuynAlZYxD2/SaMUr99oy4jTP4B16qAluL/zbly8o0=
X-Received: by 2002:ac2:5ddb:0:b0:4d5:ca32:6aea with SMTP id
 x27-20020ac25ddb000000b004d5ca326aeamr3450794lfq.10.1679602019726; Thu, 23
 Mar 2023 13:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230322232543.3079578-1-luiz.dentz@gmail.com>
 <20230322214614.0e70a4a0@kernel.org> <20230323104639.05b3674b@kernel.org>
In-Reply-To: <20230323104639.05b3674b@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 23 Mar 2023 13:06:48 -0700
Message-ID: <CABBYNZKwhUnNQ9nz0kUbUS5auAjriyfQia36p_kYM2=mCq50gQ@mail.gmail.com>
Subject: Re: pull-request: bluetooth 2023-03-22
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Mar 23, 2023 at 10:46=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Wed, 22 Mar 2023 21:46:14 -0700 Jakub Kicinski wrote:
> > On Wed, 22 Mar 2023 16:25:43 -0700 Luiz Augusto von Dentz wrote:
> > > The following changes since commit bb765a743377d46d8da8e7f7e512802250=
4741b9:
> > >
> > >   mlxsw: spectrum_fid: Fix incorrect local port type (2023-03-22 15:5=
0:32 +0100)
> >
> > Did you rebase? Do you still have the old head?
> > Because this fixes tag is now incorrect:
> >
> > Fixes: ee9b749cb9ad ("Bluetooth: btintel: Iterate only bluetooth device=
 ACPI entries")
> > Has these problem(s):
> >       - Target SHA1 does not exist
>
> Hi, any chance of getting fix fixed in the next hour or so?
> It can still make today's PR..

Sorry about the delay, Im on it should be able to send an update shortly.

--=20
Luiz Augusto von Dentz
