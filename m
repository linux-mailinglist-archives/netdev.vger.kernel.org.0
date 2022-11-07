Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39A261F8ED
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiKGQTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiKGQTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:19:01 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CE02099F;
        Mon,  7 Nov 2022 08:18:13 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id u24so18331385edd.13;
        Mon, 07 Nov 2022 08:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Obh3So++S0fpgr60eFX+LcdWNZ85UuWk3LNhFvn6Ric=;
        b=aZyvP3vyQq7FjjM5qE8gq/ZSNDgYJL2so29zcraAB6Ttr5+wRHNTa5vMzZ8YA87Fkf
         9EsURtvv5ouHYlPh7pyDmlctj4BkWdBfRphCBSRCdxjW3US3UVgmReBCvwP2PVS/SPiv
         jjymQsN468vq67SyHQ+l/mXnTl449TEZHCjDk6Bm6ugHkUCYFQW1Qc182+95TSIU26tl
         23pQ18Lt57o40AfHgMY60KAZjazYLUmWSrk8Mnms6NGMngBBilTBnaoIImrWPpHFIjVo
         JhKcXM0Zf7alD4oAKrSB1f5pKeUb+PfDJqekBkzY/tatx497SKjYQjmtK751D1CfKvAK
         LFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Obh3So++S0fpgr60eFX+LcdWNZ85UuWk3LNhFvn6Ric=;
        b=ILLM3a22Tbch3P8ATS3p9keqlpfkUeFV0lDpOE4WRHTkc4T8dntFBZRZAKeFQnlpfV
         NY6yu3rIuc+nt6CwKaVRzQ1D8JaMk7qKFoRqrgNSxAnh3AnoRHptO2mnOCCfWMDfkzTb
         A0rduob1amUgZuDSv+MfNF/ENp42e9REMj7K+Ybj8Cfb2NqUW9QZXDpeoA9Hv5paWQOU
         wYOgG7zmtDW39kig6irgcjUDO5at6QN9/GFQB11QFBw56jtO3PIse7KOjrtzSWcJjYWD
         K1y0+8orR74orskeZgHMYO40jGUoDXtGpzQHMwh1UahKe99uzpYu8eedx0GTQ79g21B4
         H7RQ==
X-Gm-Message-State: ACrzQf3BvLcsj3WloT5O6ZKN3cZ8WY7bEKog3Shp2Op4c0LNwKxlDir9
        ILH6+wzLM171W3PtpUSA07DobIO/XkitH+f/ZCI=
X-Google-Smtp-Source: AMsMyM7nfUtm1fP+3JtrVzafVqmqKFeuCBrpVsLmHiKVUSAJcyhqTY7pkLP6krC6L/RH3xW0HIHHVTSZXjyMXloDn5w=
X-Received: by 2002:aa7:cad5:0:b0:454:88dc:2c22 with SMTP id
 l21-20020aa7cad5000000b0045488dc2c22mr51406050edt.352.1667837891699; Mon, 07
 Nov 2022 08:18:11 -0800 (PST)
MIME-Version: 1.0
References: <CAGRyCJGWQagceLhnECBcpPfG5jMPZrjbsHrio1BvgpZJhk0pbA@mail.gmail.com>
 <20221107115856.GE2220@thinkpad>
In-Reply-To: <20221107115856.GE2220@thinkpad>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 7 Nov 2022 17:18:00 +0100
Message-ID: <CAGRyCJF+EodvRNK6T7KrBP_WKyETPYmz537M6hF6ZDD0RQVvkA@mail.gmail.com>
Subject: Re: MHI DTR client implementation
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        loic.poulain@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mani,

Il giorno lun 7 nov 2022 alle ore 12:59 Manivannan Sadhasivam
<mani@kernel.org> ha scritto:
>
> + Loic
>
> On Tue, Sep 20, 2022 at 04:23:25PM +0200, Daniele Palmas wrote:
> > Hello all,
> >
> > I'm looking for some guidance related to  a possible MHI client for
> > serial ports signals management implementation.
> >
> > Testing the AT channels with Telit modems I noted that unsolicited
> > indications do not show: the root cause for this is DTR not set for
> > those ports through MHI channels 18/19, something that with current
> > upstream code can't be done due to the missing DTR client driver.
> >
> > I currently have an hack, based on the very first mhi stack submission
> > (see https://lore.kernel.org/lkml/1524795811-21399-2-git-send-email-sdi=
as@codeaurora.org/#Z31drivers:bus:mhi:core:mhi_dtr.c),
> > solving my issue, but I would like to understand which would be the
> > correct way, so maybe I can contribute some code.
> >
> > Should the MHI DTR client be part of the WWAN subsystem?
>
> Yes, since WWAN is going to be the consumer of this channel, it makes sen=
se to
> host the client driver there.
>
> > If yes, does it make sense to have an associated port exposed as a char
> > device?
>
> If the goal is to control the DTR settings from userspace, then you can u=
se
> the "AT" chardev node and handle the DTR settings in this client driver.
> Because at the end of the day, user is going to read/write from AT port o=
nly.
> Adding one more ctrl port and have it configured before using AT port is =
going
> to be a pain.
>

ok.

Meanwhile, I've found the following
https://git.codelinaro.org/clo/le/platform/mhi-host/-/commit/17a10f4c879c9f=
504a0d279f03e924553bcf2420
and https://git.codelinaro.org/clo/le/platform/mhi-host/-/commit/8a87038021=
d4f39e435e035124acade1eb168749
that is very similar to the approach I was thinking about.

I guess this could be probably the best starting point for mainline integra=
tion.

Thanks,
Daniele

> Thanks,
> Mani
>
> > I guess the answer is no, since it should be used just by the AT ports
> > created by mhi_wwan_ctrl, but I'm not sure if that's possible.
> >
> > Or should the DTR management be somehow part of the MHI stack and
> > mhi_wwan_ctrl interacts with that through exported functions?
> >
> > Thanks a lot in advance,
> > Daniele
> >
>
> --
> =E0=AE=AE=E0=AE=A3=E0=AE=BF=E0=AE=B5=E0=AE=A3=E0=AF=8D=E0=AE=A3=E0=AE=A9=
=E0=AF=8D =E0=AE=9A=E0=AE=A4=E0=AE=BE=E0=AE=9A=E0=AE=BF=E0=AE=B5=E0=AE=AE=
=E0=AF=8D
