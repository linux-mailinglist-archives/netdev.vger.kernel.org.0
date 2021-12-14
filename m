Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A54743EE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhLNNyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhLNNyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:54:15 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9A2C061574;
        Tue, 14 Dec 2021 05:54:15 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso20853699otf.12;
        Tue, 14 Dec 2021 05:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cgTqtlANKYIU73+lyzmmWQUIm3CKi0FC0Wv6HvCfbsU=;
        b=LuNmbxwerVfT24HPUT0/qNe10EtrVOdZv2q42DIM2eMep9+4wpACv1iYc8oJwRhGpM
         AjPysi2YjgvJ/ChrpVf7Dt1rkgSjYfRZ9J/nZx9QCxoIsufryoasIAKH7qw6v/I1T6Hd
         rXIRopK3ecRn7po0Ffla6t2bUbZm13zW9wDLIQ2AUrBVRVt1icHkpuz4BKV/Ny8Ig+yY
         LpxUxmMUXXj+8sI1CPotwVq1Yyh5/NDYF7StCnbZ5cSHPwFS73ma5/aFlzRrIHo6xlaC
         g+gzGQanw+9MSuPWLDStqk2w5RHF56JS69ZBcHuZEcJ4iDXCfgF5eFhE0yj4pIFiYSL9
         vABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cgTqtlANKYIU73+lyzmmWQUIm3CKi0FC0Wv6HvCfbsU=;
        b=6+v2bP1lfvuLY0bgP+StzXjqr+PX+QhvbJp3dWI1PsuqW7I40B9xmm0+go2ydG7+nk
         H2DwxUGupan2RWUbjTjbLvOwym0mFaexJ/upROF7IOsf1AFRpoDuF2Q2B2CS2Xij5a00
         EGv+Z+cA9fK14iCQU2afEjbA/I46w2IVn2Pf2jQpKEgqO1BGWET4asVB+9kpaqoI4s5U
         EW5XF2u+FCyuRNhBWq01hIG8yOniGtgKEVjj+fkC+vsKImphWMHHLcOV8Wg7KJUUPgl3
         uXtYXzELIkQ5ZXzyJhncgIlE1mgO17rf7jBzyXOs3jp8HpzcOZOmY83jLFtyPid2Wbrx
         DW9g==
X-Gm-Message-State: AOAM530ELPPmd0kHGYNh8YYd7RSufoOp7SfX/1b4N9X05aJDFDPPhPH8
        Fr5Ln+IQggKb6Kc0nLUWSyBKTYKGvkR8ugOjP0O0mixv
X-Google-Smtp-Source: ABdhPJzeo8E+gTbgNDF22geVeVKUcDQp28Jiy2JpzrYBzONdL2M2Rk2onkVeZ03pRLbgSTrKbqZwE2qZr0JHK7bFtLY=
X-Received: by 2002:a05:6830:601:: with SMTP id w1mr4224213oti.267.1639490054806;
 Tue, 14 Dec 2021 05:54:14 -0800 (PST)
MIME-Version: 1.0
References: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
 <1638864419-17501-2-git-send-email-wellslutw@gmail.com> <YbPHxVf1vXZj9GOC@robh.at.kernel.org>
 <CAFnkrsmXu9ceSQ7rzOAFy_kP6JMa7GvY7HCbT=_wfskH6wXuSw@mail.gmail.com> <CAL_Jsq+5nM2L=p13CSq8FRZX0sMykbXdyBatDR7McUXkv5NXzA@mail.gmail.com>
In-Reply-To: <CAL_Jsq+5nM2L=p13CSq8FRZX0sMykbXdyBatDR7McUXkv5NXzA@mail.gmail.com>
From:   =?UTF-8?B?5ZGC6Iqz6aiw?= <wellslutw@gmail.com>
Date:   Tue, 14 Dec 2021 21:54:19 +0800
Message-ID: <CAFnkrsmiq9xk56MCd5nVx9yfsajMyqUA6W4e50B7PXpy-y3R9Q@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] devicetree: bindings: net: Add bindings
 doc for Sunplus SP7021.
To:     Rob Herring <robh@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Wells Lu <wells.lu@sunplus.com>,
        Vincent Shih <vincent.shih@sunplus.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thanks a lot for explanation.
I'll use default mdio node.

best regards,
Wells
