Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A74561F9C4
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiKGQaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiKGQaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:30:09 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C342201A2;
        Mon,  7 Nov 2022 08:28:21 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x2so18453108edd.2;
        Mon, 07 Nov 2022 08:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HwXaliEEVKH0MdJ6ecTgcVLSTfjMI6wnbCqix/s3ces=;
        b=Fv9Rem11FO40mKELGJq8C/bhdHfwqBaqFq9GHyGanXaZiorTmSbPN+spoKLugaxZl/
         psVpRv9W3is41LlL/CZxAXEmJRR9efNtxfvEXYrFBmpCJ0yj1VzSMTs25pmIq0GQT/tw
         ubkPNOztuMZjamNf2dR0jaRXa4T2pRaWiV/dPBrQSXb713fBI87InQ/Xq3ljc5riZWit
         ykTAe0mLKrSACOqjWoeS90/hrCW2M3IIx0eGziJxZK7pCRPEhFOf3/XU0qLw0H/NH2tx
         2jsutpwG9iaVye+jbfZ81o6dx/NU6mZS6zHJoTypSKN7vhwpAuCmnxCy0CYbSz1+yYfp
         BilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HwXaliEEVKH0MdJ6ecTgcVLSTfjMI6wnbCqix/s3ces=;
        b=G11WGGENmvLayWbmocvK6m0zHxlycEtRrqMY/gTNnMT4vozmgsbjQaQb+Ca/3aziSP
         HA7lCicuZL+l2hB+plq7KCZxvKZ0g7mEQZFazVFPCsCe6NFXfzirKXafrSBIRz0V3QL2
         FN1pZHRB+rjCztNewFlnlv4A8f2tHK6YWyqcZxURqDpsoRhqZel/7pUVH5UCz5xwN1Tq
         Tdnttx/SxarM43BLRzJkl1KW19LEbF4JuzLFBCbSq5NE6ACg6g8O+fgdT68gbiQPGNS5
         Ox8Q/RLIuQ2n7T8tOqEIFxN4UYkkjOOaXwpUfBlM+mDpFFUuSqhItEc6A9NL3YFqHAfb
         nciw==
X-Gm-Message-State: ACrzQf1ZXfvxuebENccOivz1eLjYuZ55yZAIkRPoOeyk2Q8e7/QfF5mq
        7ZBvseIZ7e2+Q+bSFBv9UiMcP4hhoXJreK6joTjXOtuHouI=
X-Google-Smtp-Source: AMsMyM5iq5fp05dyvDndCDK7KtNxhJCliMAt9xCZc0WtGyYnc62dBroocmMeL3tG4zyceauU/UJJlomNfdu+R4X3CAI=
X-Received: by 2002:a05:6402:1cca:b0:460:7d72:8f2 with SMTP id
 ds10-20020a0564021cca00b004607d7208f2mr51781141edb.205.1667838499569; Mon, 07
 Nov 2022 08:28:19 -0800 (PST)
MIME-Version: 1.0
References: <CAGRyCJGWQagceLhnECBcpPfG5jMPZrjbsHrio1BvgpZJhk0pbA@mail.gmail.com>
 <20221107115856.GE2220@thinkpad> <CAMZdPi-=AkfKnyPRBgV-7RxczePnB4shLq2bdj+q3kh+7Web3w@mail.gmail.com>
In-Reply-To: <CAMZdPi-=AkfKnyPRBgV-7RxczePnB4shLq2bdj+q3kh+7Web3w@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 7 Nov 2022 17:28:08 +0100
Message-ID: <CAGRyCJG_FzzjEWtpc=FQX=gO1s=DM2cV3XFB4Y0vq4UM_MP1KQ@mail.gmail.com>
Subject: Re: MHI DTR client implementation
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Manivannan Sadhasivam <mani@kernel.org>, mhi@lists.linux.dev,
        linux-arm-msm@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

Il giorno lun 7 nov 2022 alle ore 14:47 Loic Poulain
<loic.poulain@linaro.org> ha scritto:
>
> On Mon, 7 Nov 2022 at 12:59, Manivannan Sadhasivam <mani@kernel.org> wrote:
> >
> > + Loic
> >
> > On Tue, Sep 20, 2022 at 04:23:25PM +0200, Daniele Palmas wrote:
> > > Hello all,
> > >
> > > I'm looking for some guidance related to  a possible MHI client for
> > > serial ports signals management implementation.
> > >
> > > Testing the AT channels with Telit modems I noted that unsolicited
> > > indications do not show: the root cause for this is DTR not set for
> > > those ports through MHI channels 18/19, something that with current
> > > upstream code can't be done due to the missing DTR client driver.
> > >
> > > I currently have an hack, based on the very first mhi stack submission
> > > (see https://lore.kernel.org/lkml/1524795811-21399-2-git-send-email-sdias@codeaurora.org/#Z31drivers:bus:mhi:core:mhi_dtr.c),
> > > solving my issue, but I would like to understand which would be the
> > > correct way, so maybe I can contribute some code.
> > >
> > > Should the MHI DTR client be part of the WWAN subsystem?
> >
> > Yes, since WWAN is going to be the consumer of this channel, it makes sense to
> > host the client driver there.
>
> Agree.
>
> >
> > > If yes, does it make sense to have an associated port exposed as a char
> > > device?
> >
> > If the goal is to control the DTR settings from userspace, then you can use
> > the "AT" chardev node and handle the DTR settings in this client driver.
> > Because at the end of the day, user is going to read/write from AT port only.
> > Adding one more ctrl port and have it configured before using AT port is going
> > to be a pain.
> >
> > Thanks,
> > Mani
> >
> > > I guess the answer is no, since it should be used just by the AT ports
> > > created by mhi_wwan_ctrl, but I'm not sure if that's possible.
> > >
> > > Or should the DTR management be somehow part of the MHI stack and
> > > mhi_wwan_ctrl interacts with that through exported functions?
>
> Is this DTR thing Telit specific?
>

I'm still not 100% sure, but I believe it is Telit specific.

> Noticed you're using the IP_CTRL channel for this, do you have more
> information about the protocol to use?
>

No, Qualcomm documents I have about mhi does not telly anything about
this protocol: all I know is coming from previously sent patches and
code available at
https://git.codelinaro.org/clo/le/platform/mhi-host/-/commit/17a10f4c879c9f504a0d279f03e924553bcf2420

> At first glance, I would say you can create a simple driver for
> IP_CTRL channel (that could be part of mhi_wwan_ctrl), but instead of
> exposing it rawly to the user, simply enable DTR unconditionally at
> probe time?
>

Yes, this is what I'm currently doing in custom patches and it's
working fine since I just need to "turn on" indications. Not sure,
however, if this works fine for other use cases (e.g. dial-up, as
mentioned in commit description at
https://git.codelinaro.org/clo/le/platform/mhi-host/-/commit/17a10f4c879c9f504a0d279f03e924553bcf2420
though I'm not sure how much having a dial-up connection with this
kind of modems makes sense...)

Thanks,
Daniele

> Regards,
> Loic
