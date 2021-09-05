Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE5C401221
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 01:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbhIEXj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 19:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbhIEXj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 19:39:28 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92ECC061575;
        Sun,  5 Sep 2021 16:38:24 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id f2so8308224ljn.1;
        Sun, 05 Sep 2021 16:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nsax2rDUTiQyof9NbrTb6O4dsdu98uSbFRqYitM/x4s=;
        b=S3FWTOKhb1nEfX3pb8BuZ7hQx8KVAjUUmt44UXgdlbtoB/jLHSQ2Jv7S84GttZPbfx
         7KU50dH22aJDJYMlUfB/8VzX0S5HVa3u5EtbASZbPQyTrwQUTcd5y1Ek593TOpA509//
         8jfPN3ecTUuVP/Cx1iGUOtrgzptnKEC08IiKF7i21puLWu/yZ/urBsIovVkLK6jHq0bf
         K8SjMOkyRUTnoJbRamYeO2inw/okx74rRgzYEOsatgwu33vqsNurVjfbzeWsqbl/1Vxl
         SSzo4v22kNlPGrXLJF0OvBh1BsvIaUj0AUc5oIVTVUu8r+gN1R/LU0Jf3s9oWErGba5z
         6dOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nsax2rDUTiQyof9NbrTb6O4dsdu98uSbFRqYitM/x4s=;
        b=TF6IwEhB7nTR2Xxj1bezbCYL3vGcI3ptepCpexoQuUq0HC27ZC16sTV7kjZIbwWE/R
         qVi0HumNgM5cnduUsEBIwd22WrT597n9kCEgx2R74/Svs/yrsRiUcH9cetBiTjrt7zwi
         k67AwgnltcWCD6ss6T8CCfKz8Efy/8CIWkedpZpIxMocGp52sw4SuTbpGA/8JDS/sP8V
         TUOBsXlizsrQ2sNpxiXD69RIJtMoKq5bPLS3bdYJgcdzcn91bEnujL777m/6yPWbHm1V
         aaZk3UomCNt/56UfyhzdS6lqjvzjA9j9Ar51Ti1amK7tdWLsl6CbvqhSC+TfaRW86AHN
         TdnQ==
X-Gm-Message-State: AOAM533T548ONmt8ADgV3otgFufYg5OxxDAxpOYneIQ9QAUls7EZEEqB
        k8BhkBMRp+Uacgea9Z6fEKX/SP/hA3Ge0IppeM8=
X-Google-Smtp-Source: ABdhPJw2S1D58BMsX4Sb3AdihE5h2NhM77ZVb1PcP2XSoMRs+TIYU12tGoawlJPGvcmkDBtK2QQvOnBuKGtaNAyNep8=
X-Received: by 2002:a2e:7c10:: with SMTP id x16mr8214225ljc.398.1630885102214;
 Sun, 05 Sep 2021 16:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <9ce530f5-cfe7-b1d4-ede6-d88801a769ba@novek.ru> <20210905140931.345774-1-ericcurtin17@gmail.com>
In-Reply-To: <20210905140931.345774-1-ericcurtin17@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 5 Sep 2021 18:38:11 -0500
Message-ID: <CAH2r5msLcLV-Mbk14ABW28BKwH9524=VKBNV278qQqJGKT6PAA@mail.gmail.com>
Subject: Re: quic in-kernel implementation?
To:     Eric Curtin <ericcurtin17@gmail.com>
Cc:     vfedorenko@novek.ru,
        Alexander Ahring Oder Aring <aahringo@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am interested in this as well (encrypted and non-encrypted QUIC
cases in kernel)

Short term given that Windows is the only server than currently
support it - testing probably needs to be done via upcall with
SMB3.1.1 Linux mounts to Windows, and once that is verified to work
(as a baseline for comparison) - start work on the kernel QUIC driver

But for the initial point of comparison - would be helpful to have
example code that exposes a kernel "socket like" ("sock_sendmsg") API
for upcall ... and once we verify that that works start the work on
the kernel driver

On Sun, Sep 5, 2021 at 9:10 AM Eric Curtin <ericcurtin17@gmail.com> wrote:
>
> Hi Guys,
>
> Great idea, something I have been hoping to see in the kernel for a
> while. How has your implementation been going @Vadim? I'd be interested
> in a non-encrypted version of QUIC also in the kernel (may not be
> supported in the spec but possible and I think worth having), would be
> useful for cases where you don't care about network ossification
> protection or data-in-transit encryption, say a trusted local network
> where you would prefer the performance and reliability advantages of
> going plaintext and you don't want to figure out how to deploy
> certififcates. Something that could be used as a straight swap for a
> TCP socket.
>


-- 
Thanks,

Steve
