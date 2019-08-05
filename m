Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC728273D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbfHEV7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:59:43 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38855 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfHEV7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 17:59:43 -0400
Received: by mail-yw1-f67.google.com with SMTP id f187so30152530ywa.5
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 14:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fd7ZnrQMa7ZTXSUJY+OfZXB5pnyekIxx1tLCZQSFfD8=;
        b=BXpsRxvoHH04OvpOdGBmJ0QXuITzxTFNIOhcG8XhG68lEmgWGHmQpovE4y46CpWyjc
         R+0EgMtLT0PosjnnLZP4MRfzn1hWkCCax6cJfwwO1GbSf9Ygr23rpiArWWZzI+ZSzpl5
         LAYdh1hRBWJVmiRFx/4IG1ymxnTXEMXisV/EsiA6Pa7CynTstAeiqSQxTwByYZLI2dKk
         xhfKZ9vfUJeRQNPDagpEcXb83oSHNgtnewiVmL0HDiR7iB2FuFUau/DhZNHN3tVcFwKV
         iBeFdB64VN0xpHekrmqXg5Vyo1L8Q09X+ZB+KhVwMW73JwQRCRWpHHNfTEswU7pM5F+M
         Umjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fd7ZnrQMa7ZTXSUJY+OfZXB5pnyekIxx1tLCZQSFfD8=;
        b=f5Mhd/TOq2a3NxEGNGwgl6IOe43cOBFHWHaPxADa6j6dU04ivCanxkCx6j+P9KaKKE
         YRnEOLwszFx4h6LUbdh8RfnGbyTj3N154+oFdX261TQVZd0QsDT0xl8x7zUJz69wKpGL
         A7h0smXonX0ylGgD4Fu2Mz4ZOG8IM101Hd5hII4DiLOMeBjNA8ZL/Ae3DWA0p+7OtdBg
         wYgimbMWbNb4V905MhcVzvdYXpPwdWLZtxl0V9CRz943te1FxipOdsRS7c5D3Br8FeS1
         FIgdR8Ho0NaKU8PkT8mh8pQuLwaLBDSjZrJt6pPNUBJO2FmqjvVTigY3Ee18EegnB7RK
         Bokg==
X-Gm-Message-State: APjAAAWB5XqxZ3dKe0ablpCR3mJ2aUHZKKvxDcXAaahcJF/h7vtfMOW8
        biSmNL2OmUu3UWiz6GRDgthxcYUo
X-Google-Smtp-Source: APXvYqyBEv36j39DrEwS1qV1+SibkFIhiROmTcIywUlAd0PAynbR4AwC3DENzVBaF4FPhsyEUvOJ2g==
X-Received: by 2002:a81:3a55:: with SMTP id h82mr252319ywa.27.1565042381938;
        Mon, 05 Aug 2019 14:59:41 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id a4sm17245259ywe.28.2019.08.05.14.59.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 14:59:41 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id s41so7745302ybe.12
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 14:59:40 -0700 (PDT)
X-Received: by 2002:a25:2516:: with SMTP id l22mr241544ybl.441.1565042380444;
 Mon, 05 Aug 2019 14:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190802105507.16650-1-hslester96@gmail.com> <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40F174@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40F174@ORSMSX104.amr.corp.intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 5 Aug 2019 17:59:03 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf5vWxBxCBEzCGmUg+BMUS=JOk1nzcG7X9Kt-evAxmeiw@mail.gmail.com>
Message-ID: <CA+FuTSf5vWxBxCBEzCGmUg+BMUS=JOk1nzcG7X9Kt-evAxmeiw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH 2/2] ixgbe: Use refcount_t for refcount
To:     "Bowers, AndrewX" <andrewx.bowers@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 5:43 PM Bowers, AndrewX <andrewx.bowers@intel.com> wrote:
>
> > -----Original Message-----
> > From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> > Behalf Of Chuhong Yuan
> > Sent: Friday, August 2, 2019 3:55 AM
> > Cc: netdev@vger.kernel.org; Chuhong Yuan <hslester96@gmail.com>; linux-
> > kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org; David S . Miller
> > <davem@davemloft.net>
> > Subject: [Intel-wired-lan] [PATCH 2/2] ixgbe: Use refcount_t for refcount
> >
> > refcount_t is better for reference counters since its implementation can
> > prevent overflows.
> > So convert atomic_t ref counters to refcount_t.
> >
> > Also convert refcount from 0-based to 1-based.
> >
> > This patch depends on PATCH 1/2.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 6 +++---
> > drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h | 2 +-
> >  2 files changed, 4 insertions(+), 4 deletions(-)
>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>

To reiterate, this patchset should not be applied as is. It is not
correct to simply change the initial refcount.
