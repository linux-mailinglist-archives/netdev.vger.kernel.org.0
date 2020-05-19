Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8481D90C0
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgESHOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgESHOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:14:24 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14615C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:14:24 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id f18so6232503otq.11
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cmiZhpA6ehL7myiUJ7Wjy+8XrGRPbg6Kz3BXj1JXsqQ=;
        b=Sh5HIj6Ft5ZGPyXk4le2g9GYXbR/FFCTOdVz0EIR9XFcCeSAhue9hlN8LJ3aNfZSh9
         4kMIKSN3zAN8LCTNchC7mjBgmKP3cBEb20EmQ3Bsb4w4iTWXRvO5VwGxv1AA493dLjsG
         uciMPnO0sTQBHcsdj5R2nEylm10ClBl21pOvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cmiZhpA6ehL7myiUJ7Wjy+8XrGRPbg6Kz3BXj1JXsqQ=;
        b=otZUxpmCxVzVhHtfia/eM3oh9n4U0fSvxsV5WKYKUQenY7xEll18CT9K4Adjdo8KPw
         K7NRTqNrK98UhDnqhpE47G5+75ZDLl0KZbRdX3dKBIltsm00GIWZncpm1oiRLbOnKpBq
         TGgKNh0B6gRnWR1Ee18PAdkHFFw2jXzpdJo8IH+zwvThFaALC0ryr5ZPr56OJSc7cVf2
         cpiy4kWXWuJ+RfXY1u8jQTNaRRJjmBd4/VJX3tzn2VyXD+kKQ8ap5QR9f9XcMziP7N7r
         JO8WZ/CFrpUKC/dGnzBO/k/ErGeateWJf2x5o3fTSa6CgzweYB/2nJsJjIT6CtDAZniK
         n2HA==
X-Gm-Message-State: AOAM531fSTbXidtX7YZ7OBlzsvGg/sC8XIxWoxqVpsB00EXB97yePQYq
        BdfcYcjRvJzz5Nq83V1O6ckjhTQWqSZ4Brs3tPipQw==
X-Google-Smtp-Source: ABdhPJxa3c486KdZszDd/u802iRwvl5u617uQhNbqv00FDxvHia23+tBH7EK9R/jGK4FdqrsErsUF7NFIwSIsKPyM6U=
X-Received: by 2002:a9d:39e2:: with SMTP id y89mr3394776otb.109.1589872463378;
 Tue, 19 May 2020 00:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho> <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
 <20200519052745.GC4655@nanopsycho>
In-Reply-To: <20200519052745.GC4655@nanopsycho>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Tue, 19 May 2020 00:13:46 -0700
Message-ID: <CAKOOJTxVbJ0QUCUz8JKDSJKoiQ8FecifbRRo9gcM8ijhDkA9HA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 10:27 PM Jiri Pirko <jiri@resnulli.us> wrote:

> >I am adding this param to control the fw hot reset capability of the device.
>
> I don't follow, sorry. Could you be more verbose about what you are
> trying to achieve here?

Hi Jiri,

Vasundhara is not adding a mechanism to trigger the actual reset here.
This is a parameter to enable or disable the hot reset functionality.
It's configuration, not an action.

Regards,
Edwin Peer
