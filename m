Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3548620793D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405184AbgFXQcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405088AbgFXQcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:32:41 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BE2C061573;
        Wed, 24 Jun 2020 09:32:41 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t8so2642069ilm.7;
        Wed, 24 Jun 2020 09:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUIZQhqDp4lzMh1CnS2pEovhw0eG8uBYHqVBDBe2+2A=;
        b=BTHZP8c7EWgHrJF0/6w1zOJdvOS+S0FTXntU472Hy58QRKcqMUTCvjAtw1dT0WOWVn
         vVd53nd8ZLAPUC2e7wWcprGNNlzzxswaEfNR5ZVYFjN4i73A8HWgpeUJ/kBOfyMF5azF
         EvoO8Ig9sR2ugXlan5QPb11NFgivc/vgaNISZ5j8mrH6x5zEs4VEpisgER5cCv19WoJY
         yrqVbVdW/0wZQrqjYQEIa/J6lhfvq0er9dIOHFnJms/RuNXO4eM6VB5A31IJuxLZ5BFc
         gf1sQSBkkDaXm8myp9Tm9rrelCkHEvqoyevE8z04DHMYO3V1aZeBZFZ46lklqWJDHWXR
         Ni5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUIZQhqDp4lzMh1CnS2pEovhw0eG8uBYHqVBDBe2+2A=;
        b=MwawYDdigu+85ThvNewfPCdRv+WQuqynSihUs/yV1dMQLGlzVu8IZG40ZtNcGGeOsh
         oOuEdGb+gRIjBftv2Gw8vELeJgxa4nmuMmkyzq6jFKI5o9GEsTRbG1T4XquU9v5PLc8K
         qUev/YnKTzWUnS3yuBQZxDdf1TYh7yn1hk64HcboFoJ+fR0jP6vHAQUZxUlPz1AVkiQu
         S3jHUbGnXo1ufK4Gd5PGWyIlVQr+QPNzOHMFTcz7BAmH1jFqRTeRQjd40pGUckaSRKZ2
         zeAhDhtvATrbbzTR9C3nBqxks5lxpj9EulPEnK4tP+j5u9LwuKirvrmd0m/Mkin2t/9U
         d7Cg==
X-Gm-Message-State: AOAM532nJyQuS40GsGDvcgW7LgAuyBV+1y+EKRn7n5IXiepw/hG9RcXD
        C+vOYUIH2vH79ll2g7+FV8rDP1ipuMsWQLqzbyo=
X-Google-Smtp-Source: ABdhPJwEwuCaeT0KQT8T6bGY+TLDIqijMwDykgVQEODBnMvMPlvN+4M2jDSUIKwguCt1ADHbR3aP4faN01hP5+mg4XE=
X-Received: by 2002:a05:6e02:48e:: with SMTP id b14mr9395963ils.143.1593016360414;
 Wed, 24 Jun 2020 09:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200518150214.100491-1-vaibhavgupta40@gmail.com> <20200519.153239.1577517664546707472.davem@davemloft.net>
In-Reply-To: <20200519.153239.1577517664546707472.davem@davemloft.net>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Wed, 24 Jun 2020 22:01:06 +0530
Message-ID: <CAPBsFfBhWAYCuxWxP=DnD1Ja5cQ44i5guRC+49gAHsTxJV25qw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/2] realtek ethernet : use generic power management.
To:     David Miller <davem@davemloft.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 at 04:02, David Miller <davem@davemloft.net> wrote:
>
> From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> Date: Mon, 18 May 2020 20:32:12 +0530
>
> > The purpose of this patch series is to remove legacy power management callbacks
> > from realtek ethernet drivers.
> >
> > The callbacks performing suspend() and resume() operations are still calling
> > pci_save_state(), pci_set_power_state(), etc. and handling the powermanagement
> > themselves, which is not recommended.
> >
> > The conversion requires the removal of the those function calls and change the
> > callback definition accordingly.
> >
> > All Changes are compile-tested only.
>
> Series applied
Thanks !
-- Vaibhav Gupta
> , thanks.
