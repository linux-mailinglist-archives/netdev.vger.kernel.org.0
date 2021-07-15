Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4F03C9DDE
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 13:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhGOLlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 07:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhGOLlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 07:41:01 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BDAC06175F;
        Thu, 15 Jul 2021 04:38:07 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id e11so3156993oii.9;
        Thu, 15 Jul 2021 04:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agY1HwRnMHAig7PeNe20SoCKyT5WNEwyxgAwAoLb3QQ=;
        b=NABaBwPqWmw7vAa7GjwmjC+2AMfj+xtGASQRmbh8DzirvLEWRNmIwQHNVlfT9pnc61
         nWlEhN+DflZaK+CY0hIlA4hYse4aK+usEd19H2srfIfb7hKu4x1/lFczSWPTYYoZLPr1
         P3dDv0cP8klkcppsEEkiLt/6JOm6HO9HgYLkUs7lboG8rZrQtXeejAMwakC9U4vqVu6d
         S7Ww9sgueXccLhgsT4GrLTTcpu5tnwjGr1SPDiiy8dRbMgA8P0gvtp+XWLlFNqmUZ1up
         xPtUeafqyT2atAfx+elOXQnClEJY0jnbxObfY9clsFnt2sZmjb77hGSdBUQeXSLrDeMJ
         roWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agY1HwRnMHAig7PeNe20SoCKyT5WNEwyxgAwAoLb3QQ=;
        b=jOoirp+N9KdDoqM7IrLwubM8YhQlrivUfPeeRiujCw4Qj8JodVhCTKhs2wYVXsoXFs
         cmrjaR2kucMFCMhsqbBMO9RQl1iIesxpQsdrshXFk/+JsCbrJiZsCQaExGIEqYpDsUuQ
         yfzeuh2SRmVZxzcC0dnypIKCa6SMxz+Oyh8keA6QDyeCdKNkhC/DzwFTBciNgZAm60FZ
         0M3BSTgmbeLgi2IZxFAwKjhD6awqcdDesGBpLgCJ5H+5JBwv0gqExrem3BQuAeUQRQ4d
         b9daY9Xfjmbw6Hn6anrkw7RyiRiWzRivjRw72AU9ZNv9ec+UKoiKpyZkDo23grAizZ4y
         gESQ==
X-Gm-Message-State: AOAM530B/+4z6dsT21H+5M03fcJtaTr5bvE0ppAFP9vef3vZpkzT6Vad
        TElp16VwNI3ca7BPFMOI+edOBgh4MSqJ1EYJhOs=
X-Google-Smtp-Source: ABdhPJwF9M2jwTDvH9GNtyUxR2THR7ySGoyGFJljMBjfd3OmppEaFb5osibrM3HmMhUQXSRqwLFuB9wSx0KzvNbU+34=
X-Received: by 2002:aca:f54e:: with SMTP id t75mr3281770oih.142.1626349087317;
 Thu, 15 Jul 2021 04:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com> <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
 <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
 <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210715110706.ysktvpzzaqaiimpl@pengutronix.de>
In-Reply-To: <20210715110706.ysktvpzzaqaiimpl@pengutronix.de>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Thu, 15 Jul 2021 19:36:06 +0800
Message-ID: <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
Subject: Re: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        devicetree <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 7:07 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 15.07.2021 11:00:07, Joakim Zhang wrote:
> > > I checked with Joakim that the flexcan on MX8MP is derived from MX6Q with
> > > extra ECC added. Maybe we should still keep it from HW point of view?
> >
> > Sorry, Aisheng, I double check the history, and get the below results:
> >
> > 8MP reuses 8QXP(8QM), except ECC_EN
> > (ipv_flexcan3_syn_006/D_IP_FlexCAN3_SYN_057 which corresponds to
> > version d_ip_flexcan3_syn.03.00.17.01)
>
> Also see commit message of:
>
> https://lore.kernel.org/linux-can/20200929211557.14153-2-qiangqing.zhang@nxp.com/
>
> > I prefer to change the dtsi as Mac suggested if possible, shall I send
> > a fix patch?
>
> Make it so!

Then should it be "fsl,imx8mp-flexcan", "fsl,imx8qxp-flexcan" rather than only
drop "fsl,imx6q-flexcan"?

Regards
Aisheng

>
> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
