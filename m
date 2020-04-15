Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF941AA8F9
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636237AbgDONqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636203AbgDONp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 09:45:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6BBC061A0C;
        Wed, 15 Apr 2020 06:45:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t14so6020706wrw.12;
        Wed, 15 Apr 2020 06:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=6Y+n501v60+M9qU9BaDXmrwTBhvvERDvpQrXPhdTjpk=;
        b=lxGxqGA/w4cma4aWMZOuekWkvzZjyQeK07gZxyiOlbOFOJdw/ty1G/gOjpJXkHhbtv
         oec/4EyegckUWHV5YfR6K1DjhbJYMlVEOGcFGvFzW2YYSjDREe77l0eEkSIddkqfonVv
         w/4pxZUN7S+iYpbqC2d6lFPe6j+JL6uXyjVl7JpZkS9c6nsZC7GzFqaRY9Aai665W2M0
         SmoyMcrt/DYkfW/blgJIVnvNEBintUPPRXYH/Dy0aUJc58VQFOEE9zG2ERbhBvyA7vSG
         8HV0nvpldH7tNH6MqDd5VCsdvTp4wvEKiB8XJpOI3WVE36xRezRwuu/xf/MIqHK2fuxh
         0F3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=6Y+n501v60+M9qU9BaDXmrwTBhvvERDvpQrXPhdTjpk=;
        b=MgtoPyCAkQngTCqQyQNKSSIFO87VuDKaiPQVMBUpLbGLA4lI/9SvgY1RypsdUk8HRZ
         hzt7B1zxdPGzoj+D/IRcwYRUesDQNlr19aN7Ak4z4+LKxOGlUO39i+YMnrNcNuc2rRd1
         KyVf7PvGifIv6vR1MJ80c7BerG2kB3Z/DO5J1fJK5l+igOLsQSjYf+9J8SdYJIC2KNBS
         dDlfQ87pOSY/K4cH3ah95V+kJSjJdVJsugG2R2F8kVw9ZBZZwZLiZOnIg8/7WFahR7x4
         7giB0ZVOH2trrJt5ol2YceKcpDDOLxVZBiqD7zCzT1SKyxutTW4uuc0Cxv6J5jkwQPVH
         XmOw==
X-Gm-Message-State: AGi0PublyIf55ETKAoQNSZnEhiC4cSZPo2N5+ycm9FvDsPKNLr0jyhTw
        H6319ZaX2LDZk+yQAcup91t21a2ciYTm24JNjTA=
X-Google-Smtp-Source: APiQypLUp621VYLuDBG2y+9wV8uTBWCc0dq1pqejCsr4K8b9rnKIceDL3XZnGAu/SSvcrhnulcagnXmoVKq+rXEtXf4=
X-Received: by 2002:a5d:5745:: with SMTP id q5mr22407388wrw.351.1586958357116;
 Wed, 15 Apr 2020 06:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <1586254255-28713-1-git-send-email-sumit.garg@linaro.org>
 <CABPxzY+hL=jD6Zy=netP3oqNXg69gDL2g0KiPe40eaXXgZBnxw@mail.gmail.com>
 <CAFA6WYMZAq6X5m++h33ySCa6jOQCq_tHL=8mUi-kPMcn4FH=jA@mail.gmail.com>
 <CAFA6WYOW9ne0iffwC1dc48a_aSaYkkxQzyHQXTV2Wkob9KOXQg@mail.gmail.com>
 <CA+icZUUDm=WPjmwh5ikp8t+xt7dqTgghCeB8F0+czaUh-sHXxA@mail.gmail.com> <CAFA6WYPdJMt-h=9HrV-DcHZnO7xCu74Dh9FuRMnp16qhotyo0g@mail.gmail.com>
In-Reply-To: <CAFA6WYPdJMt-h=9HrV-DcHZnO7xCu74Dh9FuRMnp16qhotyo0g@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 15 Apr 2020 15:45:44 +0200
Message-ID: <CA+icZUX9KqXbM822Qi_pKcBe8H7Fk1jUa-Vo1FVB4mnuJmZ+Qg@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: fix race in ieee80211_register_hw()
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 3:39 PM Sumit Garg <sumit.garg@linaro.org> wrote:

[ ... ]

> I didn't get this PR notification as currently I am not subscribed to
> linux-wireless ML. So apologies for the noise here.
>

There is/are a pr-tracker(s) and bots (for example tip tree) around
which inform people automatically.
But I have never dealt with that topic and thus do not know if there
exists something for net/wireless/mac80211 around.

- Sedat -
