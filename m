Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D149479ED7
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 03:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhLSCbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 21:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhLSCbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 21:31:22 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8305EC061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 18:31:22 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id be32so9996468oib.11
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 18:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=sMbnsRrPDBfNIlKxcT4/DAxF9Vuy/N30ZHTRcME+mwU=;
        b=m4y9nXAVu4rW7HLR/DFPC70WwILJYCnTNOXbJMRnwR/8Rmt1vbzW41W0+tDFmPSrJ0
         glniC6ScTSKf+iCGjzeQVqKfdXgXqig9Pye5ZV9u/LYvNdLwQx9xWmyIPipj0XYGN1dX
         +CKuaoYqaap0RNbJVoQqcUzQTDKNmfkzsvT5HPOsrA6ij78RXjOIqZMXUvvVHD5/yMCz
         2RttztGBs5R8njU9w1dYfhFApIQh9JLX82SXKUDFo+q9UoUeUldMUUzPfjIKfQdpp8VY
         lpw4r0xiROyEjEZLMgTtSL4ahBrm5CqMJP6HxC38RGozKQ/bgWRA4tGSKwm5OUL54oKv
         vsag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sMbnsRrPDBfNIlKxcT4/DAxF9Vuy/N30ZHTRcME+mwU=;
        b=bwzA3aeXz82XYtu4UXu98W/pf6HEDLtQCQXXL8xPXNvsxRA2P3VuLYiCsO4xXI8bHG
         TFqs36d0/6WKrR+W0eZAR+4P6le4RmwnSvv2ErWW46KdwcvZTICgjII3DxZf+tCY8Waj
         P/aZ2obY6QkeLId0QEGcDFaa2/bU5ARitLbDcHVT1Xmj1/scyvd9+7enapryfZM2PvYe
         HbSwS0ZRVxmO4UZ8aWl9yZdIIUWEGlKJLfor529zLxW20/fmagEDVTFPzF2ygEmHoNYL
         MkkbyYipCbwS07MPH2bGpGLjAECK6y71megP4aMLxZlMnqHxF4MssBZQjO3nPV968px4
         vELw==
X-Gm-Message-State: AOAM533lmm7qfuaxGv26gcZDaie15BBj/0kL/wddLeq4pWZzbFjcO1e9
        cX9MjtR5dPHKlsZwk0lFMMS7cefkvb0ZElkMsZxZdzZsQCpziMR4
X-Google-Smtp-Source: ABdhPJwsqQMXfURIdvlqzXRuVKhf6TIM5XAEhg3ZmfaGL/mbo2oiXxcMEKoAl5c3/LXaDVEXixJaclhez4zqpglOxLc=
X-Received: by 2002:a05:6808:10d0:: with SMTP id s16mr13675215ois.0.1639881081871;
 Sat, 18 Dec 2021 18:31:21 -0800 (PST)
MIME-Version: 1.0
From:   Nitin Hande <nitinlkns@gmail.com>
Date:   Sat, 18 Dec 2021 18:31:11 -0800
Message-ID: <CAMwZerkEz7vfQFaQQ0ZCgkrteBi0tN+DbicS_aOpX5YUBo9v_Q@mail.gmail.com>
Subject: 
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subscribe netdev
