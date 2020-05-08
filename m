Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1038F1CAD54
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgEHNAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730200AbgEHNAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 09:00:44 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267F4C05BD43;
        Fri,  8 May 2020 06:00:44 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w2so1221447edx.4;
        Fri, 08 May 2020 06:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UNr+F8apfDkpAFTpO6sFiBGjB6K7z8TvBITdy9tuPt8=;
        b=DKmcD7LfBgTggHbWeEZ2mMx9ocC4GWT2Jq2oInpgnjocOYyMKyO2Qe+a3N2wfcnyv/
         VbrJM0dXV1B/XTG6MrWuiqlDafHsw0Sv24765TJ9Cf2qJO0/YNzvxwPHJdyXW0dW0G1c
         djCucTwC0qPpQZgIHNiT3cnJy/uI0d9PvK5xPoR3kN4iAwieic5za5bG1Lj4uHOzq/Za
         UAhDon2ZUqawnDP/AouY2DvVCnq2Qh4HIoUc9NK0D7h5c+je/Y5H5UZrRBZ0tZRtQf/x
         DDQ0mGcuKcO/HRyDQ2Mudv3YUjAK++dXvYiCBtq/cTOoseLbZedG5T1Ue/D88z0cokeu
         t9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UNr+F8apfDkpAFTpO6sFiBGjB6K7z8TvBITdy9tuPt8=;
        b=hLrLgWsa6J1+xutzoQAKN5/XFhMEUbx5AQAwZZdFAvjk0G2dKMvGFpM7BtsOTGzlTg
         fYUe5V8T9gkAY7AOtraMizXzBl1oWmmM/VpKCQOirp+F1OSZcGdl/CvXHDcrksNgbcrE
         D18Xbkp0n37c/Sq3+T0pfod5GUkAnquB5rjmbNFqVKFjPAlhA6Qoy+D6iunTVHRis2lS
         QYmXBLMKXkn/S0IqiMHbwIm3C75qICJdtetWcqNLBaL2y00KaK+djPOosnIBg11m2ziQ
         vwihOJ7YoGZbxNdmFlsqnosroVkHcKBIPDtv59nFik1hn7m4BHmh2o3qXArubwj/j++U
         yQTw==
X-Gm-Message-State: AGi0PuabkXspaTGdpUn8pYL/9vpFVMVuerSjMc+HnKV2uSBhiKZm3JB8
        nZ/TEsSGBmyv9xbEw44x3WlhaKf/Y7fX1TVss+pvGfCo
X-Google-Smtp-Source: APiQypKno/Iywb79VTpCN3AA0UaOSPNgwwHas3Fsn84KPhzEmB1NfTgm9AhfEUxZaKRrx0Jii6MldZ8JuVpF38uL6LY=
X-Received: by 2002:a05:6402:6c4:: with SMTP id n4mr2101038edy.368.1588942842669;
 Fri, 08 May 2020 06:00:42 -0700 (PDT)
MIME-Version: 1.0
References: <1588939255-58038-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1588939255-58038-1-git-send-email-zou_wei@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 8 May 2020 16:00:31 +0300
Message-ID: <CA+h21hryj+b3wm8JNGW8V9gpF11D6AjdEmhq0FAdunQkPQFFcw@mail.gmail.com>
Subject: Re: [PATCH -next] net: dsa: sja1105: remove set but not used variable 'prev_time'
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Samuel,

On Fri, 8 May 2020 at 14:55, Samuel Zou <zou_wei@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/dsa/sja1105/sja1105_vl.c:468:6: warning: variable =E2=80=98pr=
ev_time=E2=80=99 set but not used [-Wunused-but-set-variable]
>   u32 prev_time =3D 0;
>       ^~~~~~~~~
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Samuel Zou <zou_wei@huawei.com>
> ---

Thank you for the patch!

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/dsa/sja1105/sja1105_vl.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja11=
05/sja1105_vl.c
> index b52f1af..aa9b0b9 100644
> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
> @@ -465,7 +465,6 @@ sja1105_gating_cfg_time_to_interval(struct sja1105_ga=
ting_config *gating_cfg,
>         struct sja1105_gate_entry *last_e;
>         struct sja1105_gate_entry *e;
>         struct list_head *prev;
> -       u32 prev_time =3D 0;
>
>         list_for_each_entry(e, &gating_cfg->entries, list) {
>                 struct sja1105_gate_entry *p;
> @@ -476,7 +475,6 @@ sja1105_gating_cfg_time_to_interval(struct sja1105_ga=
ting_config *gating_cfg,
>                         continue;
>
>                 p =3D list_entry(prev, struct sja1105_gate_entry, list);
> -               prev_time =3D e->interval;
>                 p->interval =3D e->interval - p->interval;
>         }
>         last_e =3D list_last_entry(&gating_cfg->entries,
> --
> 2.6.2
>
