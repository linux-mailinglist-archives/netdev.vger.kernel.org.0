Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D30E39B561
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFDI7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhFDI6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 04:58:40 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349F1C061763
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 01:56:38 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p17so12200719lfc.6
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 01:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L/jcUN5Pr1n6HTlXvEq++SAZmvv+rGmd9f5h/IEw88E=;
        b=tCOn0KeYbBXVsEvHdiNoxR3vT/eDT1koFBDlRNjoFv2QoycJwCTN7+WRx2EULW/4R1
         NTgbY3pRxS/EUriSBGmbX4FfLi/zryMPFH6+32FQVKCnKbP2Vy1T12B1Zsa9kHQakT4N
         p5Mgqp10AmtrJdhEQLxeDCAN8Qzq85GlM7JIzYwbtBhe6QsJR9KlnZzgfP6oxPLLIqNY
         It8XLEqaHg/j9DHFOXhGvPes4BrdedLdr5fyfP+VnBsFFFgb0wOvW9gcdk3ObqeFWI9P
         LxTqNsLtd5rCWkw5O8mXbn2n8OrIVZDRrTmsG9VYr8OUgGFeKj0e7xdiSGz81e54lSaw
         4Uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L/jcUN5Pr1n6HTlXvEq++SAZmvv+rGmd9f5h/IEw88E=;
        b=B0gH6S69pQj7DruEkX0x3OlNcmRtETApk0owUK5WJkXF3jAMfs5yFIdK20jYMMKIkl
         ammucCogrHr+UdNPGVs96m0oJPJR+9fp+hv/8xvuzJlTX2xwqn5x7nZLIufW74aUO4ea
         61vfCjCL9s652WzHd5PSR7N1rkNV4MyAxO2TWbqn4FibvmEMPZpOq3A8DkIZPvCiavQD
         LULqA6oiyWeCdqn4W/o0EwoypAsuO9GcxSMxDrVmn+EiBAsINEq2zDFDLn+xr3ORQinH
         kDAmdCRyreHP8G0r51beox6cqw98FsVpmYVL9kn2oPH9WSx1iT3wh4jO3GD7puAcCnx6
         EN1w==
X-Gm-Message-State: AOAM532NVB18a7QaAFtDVWwOlibRZCtly6aHDYD+J/ViX2JeggVFOJXG
        KJNSybtsbqheFQRNusMZ7VijorPNDxuHRqQM3sM0pw==
X-Google-Smtp-Source: ABdhPJxbd+oPaahs3Qal3C/S0gS8W9AkP69zut0KB0EoETyRMpK52iyGNSe6iE0v6qs6gj5V2LOgl5SfvJgA3+rMPEk=
X-Received: by 2002:a19:4cd7:: with SMTP id z206mr2063492lfa.414.1622796996237;
 Fri, 04 Jun 2021 01:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210604162616.v3.1.I444f42473f263fed77f2586eb4b01d6752df0de4@changeid>
 <fc36d07a8f148a45c61225fefdd440313ee723d0.camel@hadess.net>
In-Reply-To: <fc36d07a8f148a45c61225fefdd440313ee723d0.camel@hadess.net>
From:   Archie Pusaka <apusaka@google.com>
Date:   Fri, 4 Jun 2021 16:56:08 +0800
Message-ID: <CAJQfnxHtgsCTS5GCTj-p4iqaR=jZVPho1ELgFQ6-UngZcBECig@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] Bluetooth: use inclusive language in HCI role comments
To:     Bastien Nocera <hadess@hadess.net>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bastien,

Thanks! That was a great input.
I'm not sure though, do we have a standard, proper way to deprecate macros?
Or does a simple /* deprecated */ comment works for now?

Cheers,
Archie


On Fri, 4 Jun 2021 at 16:39, Bastien Nocera <hadess@hadess.net> wrote:
>
> On Fri, 2021-06-04 at 16:26 +0800, Archie Pusaka wrote:
> >
> > The #define preprocessor terms are unchanged for now to not disturb
> > dependent APIs.
>
> Could we add new defines, and deprecate the old ones? Something akin
> to that would help migrate the constants, over time:
> https://gitlab.gnome.org/GNOME/glib/blob/master/glib/gmacros.h#L686-716
>
