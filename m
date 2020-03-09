Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1046617EBA5
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgCIWDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:03:32 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:35218 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgCIWDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:03:30 -0400
Received: by mail-vk1-f195.google.com with SMTP id a1so1686667vko.2
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 15:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ClLEMAmgetJxXdQd0ir1n4N2JLLEEwIIgLb8pYjrFs=;
        b=Z5y/6JA/8On9tHJd+eVK0csGW+/rNGuWN845725WoqTZLD5d3CyhFTE9ZvVR+ERVnH
         b70y1+eqAS722ITwHeAL/CsYUimbosf4OI99T8iv2wAylro4niBrKNK3E2nLKysT+38C
         X2nBlufhZKksqXwuJEMVn4oJhwmWZfJKjgHEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ClLEMAmgetJxXdQd0ir1n4N2JLLEEwIIgLb8pYjrFs=;
        b=lkw12orJRiJeh1b8xRwBEtqSIrtEG/SdECGwk8RtsYD2ZE8vRnZNppNxHenb00GO8s
         EPTxu7HRA+jB1FSriNcbrRD9QbWmWjOPoYBUtG9HOGt5QNrQhEpgSFA04gh7gQsk+l0O
         ut/xvaf9tX47Kc3o4CNUgVb3rd/CxLw7KlQhyAo09J+MecvTjnHIX6J0VXBL/wuxdw4E
         tI86W3sXx1/P+KeTgp5fASCVKCBX3IQQ7F0Ynu9O9qrEw2oXUPX6klVaYpjTamgolo1X
         duyeNAFqID8GWgPUjoVx4qpq8QFxGywVMg3NFYFArcapFp1Xn1iSEn7wguSsruc3wmE3
         2bjQ==
X-Gm-Message-State: ANhLgQ3IJ3VER0BkOWM8tQtesao+pUF099VMTujdNmoh8srNdp3b3WKI
        /DyeVakGJ1S5mm4HtKDR3ACXBXAJW+N31sNn7qF0AQ==
X-Google-Smtp-Source: ADFU+vtRSC56yqPhVngdmy5IhfrdvXYu5SgRvQSPpj+QTOGWNC2znS7px/H3He40jNCpzYG6qWjfKVwuR94d0+1QX/c=
X-Received: by 2002:a1f:99d6:: with SMTP id b205mr10459024vke.88.1583791409656;
 Mon, 09 Mar 2020 15:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200308212334.213841-1-abhishekpandit@chromium.org>
 <20200308142005.RFC.v5.1.I62f17edc39370044c75ad43a55a7382b4b8a5ceb@changeid> <A815D112-7B0B-47A2-9CD5-C0D2E2115F19@holtmann.org>
In-Reply-To: <A815D112-7B0B-47A2-9CD5-C0D2E2115F19@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Mon, 9 Mar 2020 15:03:19 -0700
Message-ID: <CANFp7mWJ06OHYit-sL7hvJhCNuYNmaH0N1DCww2wzReyi27Ygg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 1/5] Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No -- the kernel test robot is complaining about Patch v3 which has a
known problem (not taking into powered state into account). That was
fixed in v4.

Thanks,
Abhishek

On Mon, Mar 9, 2020 at 2:39 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > Register for PM_SUSPEND_PREPARE and PM_POST_SUSPEND to make sure the
> > Bluetooth controller is prepared correctly for suspend/resume. Implement
> > the registration, scheduling and task handling portions only in this
> > patch.
>
> is the kernel test robot bug report that just has been posted still valid?
>
> Regards
>
> Marcel
>
