Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC88483AFD
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiADDdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiADDdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:33:07 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F63C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 19:33:07 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so1709463pjw.2
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 19:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=B3GY5pHxl40fgyTRDEfHUIewqx+99afdPdvQA2cgGa0=;
        b=jlyj5/1aRHFbgRmqRQPMFKCWGRD9KF/PID9jja/mWmapaMiPk5IEFbI3b+FJBCoQmG
         5fmRTmqYgzTijdVaM40JF5qGfWMgzj2Fqp7wwWQ1FcEzcMZT+GK0g4Qj7S2H+9TZGBPT
         ogy0lmLT1+HVrzJ7Is6tNbW7EAAlC8hw8qLDJ7j5tcPZ6j4a13kLKuxQifjND7pulR5P
         9ikwWhvDwwnnj1QxSpAdO/GU7ab2qxzg/jyWWDyYHzB9dvJWG61s9eL8NlvoxdnDio/v
         Jnjs8/uCcF1ZNLOFXspt3apMYrQSJz0VSGD6FLDQdRXbSJ9HFmy+YyM3yAxRR0YDFN7F
         Wjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=B3GY5pHxl40fgyTRDEfHUIewqx+99afdPdvQA2cgGa0=;
        b=GqVm5G0s52apy8bSgomM71NfCQDTTZL+sHTSYQc4PfJoIdbN5Eyf5ov9dZCQ+Mvemv
         /8YE+vwXbv3NLWrU6tS93jt0kq8NUaDtUFed5tRVwAm9Ef7jSw3F49VE2aZqp2Tj+qyT
         UdpqyCXDkVgXcDlWP5s+drOLHrcbkENq1+SRvK0ccPSd10LWyYBQHxF0Oco6OnA3QTls
         nBkyej+Bs0Z8CZdeuySOZ3ZVJY17MvmJU/wT+foQNmNYsc1L12K/5J4ssKiX8fR0vTnj
         o73Nyq2CT4/WHrGe39FYwlqMG6ZobSpFwfqqCHWalsyRipZmaxhc1OEYUGWyA5VVtMlv
         2Icw==
X-Gm-Message-State: AOAM53080aSZBtsB5qyAVE+wABwNw0Czrbb+KqWfvotwqRg+4R1tjcRl
        xzNdlcG15Qks1uNEHQgrDTyBCm47wWmT7dfV6is=
X-Google-Smtp-Source: ABdhPJxlbLp/PWr+Vqeqv2VtkhYPzrjZiX/pIVD31xfKJSMCd2sdv8fhAwHL2RIjK/LI2m7RXicoZwMtJljv/YnzvTI=
X-Received: by 2002:a17:90b:1c0b:: with SMTP id oc11mr58518761pjb.174.1641267186981;
 Mon, 03 Jan 2022 19:33:06 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a20:1025:b0:68:7681:6b51 with HTTP; Mon, 3 Jan 2022
 19:33:06 -0800 (PST)
Reply-To: sgtkaylam28@gmail.com
From:   ken manthey <manken827@gmail.com>
Date:   Mon, 3 Jan 2022 19:33:06 -0800
Message-ID: <CAHbNM4F1js+Sbiu9_-BMZntc17VdzJBCymKSHF4KFw0XcqcHXQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,
Please did you receive my previous message? Write me back
