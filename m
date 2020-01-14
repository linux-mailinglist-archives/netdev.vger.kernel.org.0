Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9776713A760
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgANK3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:29:14 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33494 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANK3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 05:29:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id d139so1958246wmd.0
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 02:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hd+/4OrCTqFjoxlmIruzP6eKZ3F2sB9cvgc09AUdVek=;
        b=rGPRir5bQEzS9a8sNIlcCppKI+remGYtlgX/XGPgvEnB1OxzPy/1oFUEA6KSD04Lt7
         WiK0JoiDK29JNAtT+oYd/Fv8xaHZeRzdDyLaKZJYSq68Cf0vNHfIhloc9OCY3vOW+Xod
         XXhahRaRsto3vjhAmts1rtRbmmEZuritZJ3rztkDTfJFnh1aNe/ONZOuhukRuwHnSwg5
         sD97aWG7HlJ3NE/pDjaEz2zROIWDmbw7PUXAZhcs1s2dRrC398Jr/zhq0y5cyQ+1kjRt
         FYQRa7ANDzNXh9EeniuV5D4y3GIRb5qREvMGNad3LI+v4+G3rlDC7i/X1b3nsoPtIamm
         VBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hd+/4OrCTqFjoxlmIruzP6eKZ3F2sB9cvgc09AUdVek=;
        b=eS2HSZquE7X8Ge/KncrrI837+iZeOvduv3ovA57FMsOnEImvQDaB4NoY/i4mbuyaBI
         dD3w01MTuzbd8zpp+h8kVSdGbGGpg/gQfHxaiBE/oYLwF7/41NRRRhnrAuPhegkJO+X7
         uwacnxEuMlri2joL3VTkX+ESTy9l/KQCTF5vH7+nHGUVOqDOMhtJ3buXkXZPfQzyeGAl
         Q1Qd9FizFruYKaI3fBhCkcqxjCLlJlZKz/VAhMo2cJriO2/RK5Xlwh5dD30eswngSD08
         geX5sHSgZKMNXlPJg5tkwgVwC89+6nmAXiW41KFL+GrT7+Gs5VA3zt7GLNYBIO3KQptq
         3W8A==
X-Gm-Message-State: APjAAAUCM10Q0xd0XUOrTKFJ/sZK6lTicdBZpvkn9eTKcdeEKqb5qVJj
        Vjie6Duy2qkhqNSWGTCpyLDgmgnyYOo1M+ToIh8=
X-Google-Smtp-Source: APXvYqwAlKW2e2ZPg4lqPb8rBjyYE56V8GmnR/P5mtrf6Wyj7mI3KmblqdgBpVDQOxNBs0WtuXlUzReey08K6+m5Rn8=
X-Received: by 2002:a1c:9e15:: with SMTP id h21mr24797149wme.95.1578997752004;
 Tue, 14 Jan 2020 02:29:12 -0800 (PST)
MIME-Version: 1.0
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
 <1578985340-28775-16-git-send-email-sunil.kovvuri@gmail.com> <20200114101949.GB22304@unicorn.suse.cz>
In-Reply-To: <20200114101949.GB22304@unicorn.suse.cz>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Tue, 14 Jan 2020 15:59:00 +0530
Message-ID: <CA+sq2Cdjn1n5WF4=JMahTcWSPaKiVB4kP9st1X7fFWJMTHX9TA@mail.gmail.com>
Subject: Re: [PATCH v2 15/17] octeontx2-pf: ethtool RSS config support
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>,
        Sunil Goutham <sgoutham@marvell.com>,
        Prakash Brahmajyosyula <bprakash@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 3:49 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, Jan 14, 2020 at 12:32:18PM +0530, sunil.kovvuri@gmail.com wrote:
> > From: Sunil Goutham <sgoutham@marvell.com>
> >
> > Added support to show or configure RSS hash key, indirection table,
> > 2,4 tuple via ethtool. Also added debug msg_level support
> > to dump messages when HW reports errors in packet received
> > or transmitted.
> >
> > Signed-off-by: Prakash Brahmajyosyula <bprakash@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > ---
> [...]
> > +static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
> > +                               struct ethtool_rxnfc *nfc)
> > +{
> > +     struct otx2_rss_info *rss = &pfvf->hw.rss_info;
> > +     u32 rxh_l4 = RXH_L4_B_0_1 | RXH_L4_B_2_3;
> > +     u32 rss_cfg = rss->flowkey_cfg;
> > +
> > +     if (!rss->enable)
> > +             netdev_err(pfvf->netdev, "RSS is disabled, cmd ignored\n");
> > +
> > +     /* Mimimum is IPv4 and IPv6, SIP/DIP */
> > +     if (!(nfc->data & RXH_IP_SRC) || !(nfc->data & RXH_IP_DST))
> > +             return -EINVAL;
> > +
> > +     switch (nfc->flow_type) {
> > +     case TCP_V4_FLOW:
> > +     case TCP_V6_FLOW:
> > +             /* Different config for v4 and v6 is not supported.
> > +              * Both of them have to be either 4-tuple or 2-tuple.
> > +              */
> > +             if ((nfc->data & rxh_l4) == rxh_l4)
> > +                     rss_cfg |= NIX_FLOW_KEY_TYPE_TCP;
> > +             else
> > +                     rss_cfg &= ~NIX_FLOW_KEY_TYPE_TCP;
> > +             break;
>
> IMHO it would be cleaner to reject requests with only one bit set than
> to silently clear the bit (same for UDP and SCTP). You also shouldn't
> silently ignore unsupported bits.
>
> Michal Kubecek
>

Okay, will check this.

Thanks,
Sunil.
