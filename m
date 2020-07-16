Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75F7221FFA
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 11:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGPJpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 05:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgGPJp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 05:45:29 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EABC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 02:45:29 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id j11so4581522oiw.12
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 02:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zfd4Pb3/bOxVbF/MRBRnpG4Djq/358uuVgKjcM7D0W0=;
        b=mfXVNntlh8eSjZ8x22ELvb7bQL7DY34Qo7Et/YPYdaTFP/lcGMON4nJRbbbCtpyt4J
         xKN56tVGyfMqbQ2t1nAM+DnFMqIDrMpy2hfPEqIctwEc57O1FRbKIwwyDySetJ4DY3jS
         L1cYrVsU/37vwlSdo/UTItH02Gban/gkyuU498L6EgnZ9LzhhXoieu9F9LXAADSxArVP
         46CenBPLHWmi4lZqYC3TMotl5g8tZT9KhJpGgNTjcsgklYXbFOcR/Q9z44yQL07VNalx
         b1uS8d8iXSkQvuuGmtVdeEqvtgEQyhYsDfbxCX9ek139e1xefgVXUY37Zd6Vfq1P6KmG
         xayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zfd4Pb3/bOxVbF/MRBRnpG4Djq/358uuVgKjcM7D0W0=;
        b=U7gsqm+fhOef6VZqA9aFS4y73txQtEgvad11IaAlE3RMMutoZ/X6U6Z1Uwc66/TzYc
         32uw1U/Y4LgiamZ7UEaY3LJx2strJy+Ea5uRzfzZojljJeucP7XxKLrazFqwTatyLp6f
         YhfjjZjr8f4GvQ81wbA1BI7jbrlSJDo+Jjr7IQpNxB7njv7WALbdx0oUz8NmeG+CGyKt
         3JoEc6fYT4+nWGt9MyCv6O/7oniM+RT2PHuH53EiF2dL6uJM+9RvjZDcTSfhIPdlrJJs
         YY5yaoobjATun2KXrxn/hMRGD8Gz2lt48RDzoGuFxoGKyedfPMTNjr7s0g3sf0BhIHOc
         2aVQ==
X-Gm-Message-State: AOAM533ZaLUNzm6wsXN2vXcNyp3Mk3qiVdcIKscho/fzYHNLc2PhEy/O
        RsuMj/5RTi1G+kAEdrfB3ZCRHxtRbXnysXansOZOcp4DDSo=
X-Google-Smtp-Source: ABdhPJzx+36/jSAhFU9671kkyQ83RN6quln05dHmjOv8ezJp1ufEqacge/Qb43Kdmk4JMhVDzqj4OnpI10t4pMbQIJo=
X-Received: by 2002:aca:c70f:: with SMTP id x15mr3138806oif.163.1594892729000;
 Thu, 16 Jul 2020 02:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAD=hENeCRuFOYwB5kSNrLGeWFBzAZooQF9F+bNhBEn95eJ7xCQ@mail.gmail.com>
 <26cc-5f100b00-5d-201599c0@21882623>
In-Reply-To: <26cc-5f100b00-5d-201599c0@21882623>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Thu, 16 Jul 2020 17:45:17 +0800
Message-ID: <CAD=hENefWXPsvPSLsnRyM5bbjYpYkfg2JMQegxia90P_JN7f5A@mail.gmail.com>
Subject: Re: Bonding driver unexpected behaviour
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 4:08 PM Riccardo Paolo Bestetti <pbl@bestov.io> wrote:
>
> Hello Zhu Yanjun,
>
> On Thursday, July 16, 2020 09:45 CEST, Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> > You can use team to make tests.
> I'm not sure I understand what you mean. Could you point me to relevant documentation?

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/sec-comparison_of_network_teaming_to_bonding

Use team instead of bonding to make tests.

>
> Riccardo P. Bestetti
>
