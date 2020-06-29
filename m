Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3666220D526
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbgF2TO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731791AbgF2TOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:23 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02CAC08EE1B;
        Mon, 29 Jun 2020 00:15:19 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e64so11113401iof.12;
        Mon, 29 Jun 2020 00:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=adzyPkXTkp0sO71SdlU/u3i679+c3g+8gNM14op6Zh4=;
        b=ToSqHyMjXzY8sb/AduIlKKW2aCikkJnwsQnLXnOzOgUpsPkSmLq4YRImXGoTxRdOMb
         nJYIHujt1SoSirmLtO7VhNw1RwSkOCG4N+r3A5WQOSndtHbdHFjtJ6vfJuRLPl9sSEVV
         apqg2X1P+XkenHfT02bJGZgydkN000VqHIGuhOTeOaLU4aHSJzQnbUSfHKdJU6lx3jTu
         Ul17wnlM+sui0bqxR/iazioQTndlpoh88ptx8EVQJRz/PMBaq5uavlyne8EwM8dErhe0
         qt4D601OmS8z0+CrKMH+qxRfwM1z+TpbGak8y3WjIPrW2KgjFyA5uXHXfrprA9H4ZQHF
         94TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=adzyPkXTkp0sO71SdlU/u3i679+c3g+8gNM14op6Zh4=;
        b=XAETSz2Giiaqh5qzut20BwKAqTWdPmieoy5SGlMpI2SiTqEIwlzg4iJB3vaSgtexis
         CDtKW4w2+wJ2PYyk/mikEwTabZlMOKQvzc5qgpqeRc5VdUKHP1t9MwaH+AqVmZguSvBw
         w7zS11ssrfElWmqZZ9jU+iStt+YY0m+iTL5QG4bjyFM59YrREQwS+jaFkeW4P4r9uuc1
         VrzbwqcvIRGp1h4om06J82KxPZv7WF3vcQYUrkwm2LusGwu/sPAzXsJjLIBXVMJ6yk2n
         ZaKpWaEOpbCxy6JYo2yx8hTN51Ja7Bq7uWfZEvnHDqlCPKjCIT4gwnC9G48DFTL34VXD
         9Cgg==
X-Gm-Message-State: AOAM531iTVXnx5zqFbxo0CQMBEap9P9ZDv2eEVKbul94jtzWI8z/oaF7
        79HsIv8grhTZIObKsm0s7N+bt2nPB4WR+fLWMLk=
X-Google-Smtp-Source: ABdhPJwhWFrCSpeie7O8ZZc6ylWvzGqcD+nXDxE+VaCR9WC377uXctoAAbiNoe4UHdQG0mW0kIrxFXHMeyLKGcLDF/Q=
X-Received: by 2002:a6b:bc07:: with SMTP id m7mr15180805iof.107.1593414919316;
 Mon, 29 Jun 2020 00:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200629033226.160936-1-vaibhavgupta40@gmail.com> <87y2o6xvx5.fsf@codeaurora.org>
In-Reply-To: <87y2o6xvx5.fsf@codeaurora.org>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Mon, 29 Jun 2020 12:43:43 +0530
Message-ID: <CAPBsFfBW7B9+ef+RwBd6SsHokWc9DxCGz6hMczpO7Y6y=q1EyQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] ipw2x00: use generic power management
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 at 11:20, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Vaibhav Gupta <vaibhavgupta40@gmail.com> writes:
>
> > Linux Kernel Mentee: Remove Legacy Power Management.
> >
> > The purpose of this patch series is to remove legacy power management callbacks
> > from amd ethernet drivers.
> >
> > The callbacks performing suspend() and resume() operations are still calling
> > pci_save_state(), pci_set_power_state(), etc. and handling the power management
> > themselves, which is not recommended.
> >
> > The conversion requires the removal of the those function calls and change the
> > callback definition accordingly and make use of dev_pm_ops structure.
> >
> > All patches are compile-tested only.
> >
> > Vaibhav Gupta (2):
> >   ipw2100: use generic power management
> >   ipw2200: use generic power management
> >
> >  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 31 +++++---------------
> >  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 30 +++++--------------
> >  2 files changed, 14 insertions(+), 47 deletions(-)
>
> For wireless patches you should CC linux-wireless, otherwise they will
> not be in radar.
Oh yes, sorry! My mistake, I missed CCing them. Sending it again!
> See more from link below.
>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
