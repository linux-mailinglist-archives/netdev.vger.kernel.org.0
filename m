Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDCD51E3B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfFXW2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:28:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54676 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfFXW2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:28:36 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hfXRz-0000cq-53
        for netdev@vger.kernel.org; Mon, 24 Jun 2019 22:28:35 +0000
Received: by mail-wr1-f72.google.com with SMTP id s4so6970847wrn.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:28:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yPJB4c+Ck9v5vdZjARgmD1N3GeNH4kKzxFhNqyT1DHA=;
        b=Ui92uFQQA1GdyqizZDlULA9mrsidUH79JFJu31gtccetTJQwDs+0DMrZQ5Z96Ir+u6
         GIRrnoLpUsJtryY8FRwUVP5e89J/4GvMbXnH2d1gnHQcj5KzGRAB7YWUuAqlKI3kq2t5
         K8SXEUEWb0OHhL/q48T+6m5pvdtLFweX+M02CPlFeYjLNOCGAfUL3P3JvbvCuidPg4Ha
         yP2K6eMMyISO7EDziwsk3Cnir4ifa/khDSsipdcydjXaa9yyCp5x139I9if+wpuJmDoV
         QEM9IXnN97kqrOX9FVe6l1EhOYOqk52icRrbQSYKgAC1re7R4cYlepw4a6k9k8cbvLob
         w0Yw==
X-Gm-Message-State: APjAAAVc383W/AD2tfIGxx+Cpz+slg4PxetU8TUdPPrdro0ofXhgfni+
        NI4GOJjFpLMBJJT0vEtF6Jf+N30EOv/1ilsQhzK7Ew/7KdCpiJ1sPlsKUh02UKXRJJEe9pffuni
        gxeYo6MBbYidEMu3Z5J+bV0wZDpHj4RgEDKZOb0RswcAncDS4Ow==
X-Received: by 2002:a5d:61cd:: with SMTP id q13mr39284991wrv.114.1561415314306;
        Mon, 24 Jun 2019 15:28:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzF+NR3nrc56abrmjWRmtGvg/1GXdRN3dIeBiOJPHJfgB+FmpkMsLU79z/1AkL1bSo79IKS73g7R990K21l5FQ=
X-Received: by 2002:a5d:61cd:: with SMTP id q13mr39284982wrv.114.1561415314207;
 Mon, 24 Jun 2019 15:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190621212634.25441-1-gpiccoli@canonical.com>
 <MN2PR18MB2528C51C0A23D9FA7744D883D3E10@MN2PR18MB2528.namprd18.prod.outlook.com>
 <CAHD1Q_xJrVeZXHCpBprErkUXrxFMJ-SPSZ-w1deENcOjcT3tZA@mail.gmail.com>
In-Reply-To: <CAHD1Q_xJrVeZXHCpBprErkUXrxFMJ-SPSZ-w1deENcOjcT3tZA@mail.gmail.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Mon, 24 Jun 2019 19:27:57 -0300
Message-ID: <CAHD1Q_yLiV8HhcVUi7NawfcNNkMVFvB0UfUqfebO3O-02F-GRA@mail.gmail.com>
Subject: Re: [EXT] [PATCH] bnx2x: Prevent ptp_task to be rescheduled indefinitely
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2 submitted here: https://marc.info/?l=linux-netdev&m=156141504615972

Cheers,


Guilherme
