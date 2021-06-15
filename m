Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C44B3A7B5B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhFOKFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhFOKFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:05:35 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26E8C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 03:03:30 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 66-20020a9d02c80000b02903615edf7c1aso13692782otl.13
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 03:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=2Gi/ft3KIkQADJ60aMFtPnho1zv2gKbmW3IR7CzFBZ4=;
        b=WhCy09dgkGTrQl6Ds/m38iqOy0PB/jipg16Z54fm5JhtksiL9voE947dX1AHFQYrz1
         Ihe5CVUcJZY4ah+DeOyTmcPCV0Y6blvxmiJamyrugX0CR/xX1eJWC++k/bKgmumTaX7l
         ROEfHaFkn10lUFst74pX0E7R4qGz4Hd8YSLT1J/agkcKnvnXnUqxrToaL4aBsbF8Wcey
         nUnsi1ggWDMMLy7pxlH2sryFOR7hqrPZZYgwpE+yl+UdZ+I5lF4/3k2x2xMKDPyKBSp1
         VhPuLpb5uCfk5m/RhjaOB49goymiYEG3VBI41XIHPGhwsWMzgRpyvZFmA2j0EpVRLJ35
         4iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=2Gi/ft3KIkQADJ60aMFtPnho1zv2gKbmW3IR7CzFBZ4=;
        b=qQ1SPX7FBM1L33AnIqh5npdKPTk4Inm7oM0dLOuDr7ACvfubxAguMhvWZuK77cZ5We
         4MPWQun3HPgt5QdE/fX50fSlIB5TjUb2ST+86FqBMzX2OPTtQp0gHgiQfRQkPJRsw2Ni
         qnHtnRXBwr0asg3JwrwGyjxZRPo94i6hNw5sKRX7fMjc5IuibjLD4IvQ15nX59EN2xZG
         H4mCaL6DOowDa/wp0lCk/fO9AztB5wktQChiEINH9AujANpZ4lvSPPa+ePIiQFKp/oVI
         +48jnAx2uJvbkdfweBFj/abbY1AnB3BFe/PjrU36z1kiGfFCv5xzoUS/1i/WQ52oBb6B
         BvIA==
X-Gm-Message-State: AOAM530iTSFFRx/p3yVwxdOCr1Jwd7CYeNhY0MsvFNFfbbDtw0BbeG+1
        1g22u/FohDEgCmEDwCSPQo8uPhWLBwtOnpn6eThJjzpQ
X-Google-Smtp-Source: ABdhPJwFGX/lUGnDe9PfLuueG8Hh2v/Pt7flTRLx7N9FrApfq6Y6GsIeXBz/UNzyxF1hqeZ/CbJIzm/dtn5oBhuUmls=
X-Received: by 2002:a05:6830:154b:: with SMTP id l11mr17560954otp.66.1623751409991;
 Tue, 15 Jun 2021 03:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210615100151.317004-1-kristian.evensen@gmail.com>
In-Reply-To: <20210615100151.317004-1-kristian.evensen@gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Tue, 15 Jun 2021 12:03:18 +0200
Message-ID: <CAKfDRXg-zy5Qnm1khRAWe00W=9-QmzVb+c2R7P1LCrp-hXvfFw@mail.gmail.com>
Subject: Re: [PATCH] qmi_wwan: Do not call netif_rx from rx_fixup
To:     Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I forgot to set the correct subject prefix. I intended for this patch
to target "net". Sorry about that.

Kristian
