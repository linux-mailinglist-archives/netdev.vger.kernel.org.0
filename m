Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A77C332078
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCIIZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhCIIYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:24:48 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C198AC061760
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 00:24:48 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id l7so9001681pfd.3
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 00:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=133xFANkNnvXsS/Gcj7xoFzGV1TFyuCxTpiSDGedfLQ=;
        b=bhBxe3eGIKx2n1tXLkj/kt4qLfcPr8e+Lh8ddardt+U/dQY5KOMT8UpMHyARVTVGVQ
         LglQLDxlJ5WsCIFQaFAG91rp3avAZmYwSdUUkR+fLHZZq5yAAUbpZ0u1Cpw7zFaGKcNA
         D+FFmgFHhFpSTMrGZF9Lnds6DZmQzzH47WZWlyXUREM54sWxViJrSwUYJQyF77NTHje2
         cQibfnUUzWGV6tiABIkOOFoJ+Oc3WS1yudZSKYK8Xa0haQw5SkVawB+zovGSAMtX5Yac
         ziNW0VBuXttb3kwimxU3fQ2bQStF8hVgXGHfGOcL9jXi50bfrPiNO3/22Vonolaz3qxd
         P85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=133xFANkNnvXsS/Gcj7xoFzGV1TFyuCxTpiSDGedfLQ=;
        b=PKMgMOXKgvNIXIWuGPyVdJz2V45y/QJp4gwLWhZ9gC3PVwcp8btOVurOj1uISnswEP
         o9iynVlHTtfiL8j1u0jfm6xRruX8bGN6HyAkeaWcG5ovfi5eZrxKMS2AFKC3azN6WZA4
         TyCwyTI0tfeCmj2fhY8Ll6MDAcIK+vVnwChOWUePTHFgzJs2oceaxSDSz9ouZak+W4F4
         bMw52EUSMKZ8QFLOg3Sd6COUYFlI80Xrr9U0jFbPPltfIP48cVRuDPNMi9tlW2woK2ff
         6LW4TByupeJlssTFfPr4Dn3FmLdD2kXrHN5Tz7GsuJo99DGXK6UtNuBRARtUYqtruS7/
         qXqA==
X-Gm-Message-State: AOAM533O0fk0z6Azmo8q3RwRT0SFpVWQnFBBEc9Z3IkF+W5j9Nd+FX1X
        W9tVFZwrTfpjQnG2L8qCCqHFfZFAMpaQqHvJrQLk7w==
X-Google-Smtp-Source: ABdhPJxJZT+QQX3Qi/RyHF/HLj4uXQeq8a86sg9PH5SuEdoEnUxOLdvvEGc83GXcAwk/DmN5njH1BgFqqX0gNRJO9cA=
X-Received: by 2002:a63:2262:: with SMTP id t34mr24607341pgm.303.1615278288204;
 Tue, 09 Mar 2021 00:24:48 -0800 (PST)
MIME-Version: 1.0
References: <1615237167-19969-1-git-send-email-loic.poulain@linaro.org> <YEcvksXq1Rt0wCxb@kroah.com>
In-Reply-To: <YEcvksXq1Rt0wCxb@kroah.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 9 Mar 2021 09:32:39 +0100
Message-ID: <CAMZdPi-oYpSjFAP+_7bbK96Zv=otVSYHYBY2ePKjX0W5-n5uOw@mail.gmail.com>
Subject: Re: [PATCH v2] bus: mhi: Add Qcom WWAN control driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Mar 2021 at 09:19, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 08, 2021 at 09:59:27PM +0100, Loic Poulain wrote:
> > The MHI WWWAN control driver allows MHI Qcom based modems to expose
> > different modem control protocols to userspace, so that userspace
> > modem tools or daemon (e.g. ModemManager) can control WWAN config
> > and state (APN config, SMS, provider selection...). A Qcom based
> > modem can expose one or several of the following protocols:
> > - AT: Well known AT commands interactive protocol (microcom, minicom...)
> > - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> > - QMI: Qcom MSM/Modem Interface (libqmi, qmicli)
> > - QCDM: Qcom Modem diagnostic interface (libqcdm)
> > - FIREHOSE: XML-based protocol for Modem firmware management
> >           (qmi-firmware-update)
> >
> > The different interfaces are exposed as character devices, in the same
> > way as for USB modem variants.
> >
> > Note that this patch is mostly a rework of the earlier MHI UCI
> > tentative that was a generic interface for accessing MHI bus from
> > userspace. As suggested, this new version is WWAN specific and is
> > dedicated to only expose channels used for controlling a modem, and
> > for which related opensource user support exist. Other MHI channels
> > not fitting the requirements will request either to be plugged to
> > the right Linux subsystem (when available) or to be discussed as a
> > new MHI driver (e.g AI accelerator, WiFi debug channels, etc...).
> >
> > Co-developed-by: Hemant Kumar <hemantk@codeaurora.org>
> > Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  v2: update copyright (2021)
> >
> >  drivers/bus/mhi/Kconfig     |  12 +
> >  drivers/bus/mhi/Makefile    |   3 +
> >  drivers/bus/mhi/wwan_ctrl.c | 559 ++++++++++++++++++++++++++++++++++++++++++++
>
> As Jakub said, why is this file in this directory?
>
> Flat out ignoring review comments is a sure way to always get pushed to
> the bottom of the list of things anyone wants to ever look at...

Yes, it's a legacy of the previous driver that was kind of a generic a
mhi bus accessor.
I'm going to move it inside network since it's about WWAN.

Thanks,
Loic


>
> greg k-h
