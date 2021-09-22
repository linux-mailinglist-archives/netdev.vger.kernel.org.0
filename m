Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB010415018
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbhIVSrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhIVSrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 14:47:41 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C01C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:46:10 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id t186so1591118vkd.3
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=DFfC8uZYlFBWW1UWZ2UiC/X/t9KDJzyVw9sPCj3Xpck=;
        b=MsEntPMEAw5NTIKH8pophERntgBKkGDzfIP4z/C/02Hc6m8yMunlT5GMLyYQKwMQUd
         uqZWAdSY29wMW1yBtp4vwwuRFx1EYUxGIanZIKaxHM0zS3DNJlK+RVGBRk3GOmlpR5G3
         jpabhwUuTWRyJda6uv/yPbCGF/vtc/Wm4mcM+vVlSxlFBxxmb0whZuVJQTot3LGHqgUp
         689s6QKDIevldMBYlUKFllzeXg0EBT+CD2e1FHYEJvTTrZ4vPcfKTrj4JckBgnESxPFa
         mLbEOZs0eKjcWdCzzvZR7ooP8D2msErxVK0+MrlNt/LVOj/su+w52jQEMlCLilIrvOHz
         ADTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=DFfC8uZYlFBWW1UWZ2UiC/X/t9KDJzyVw9sPCj3Xpck=;
        b=I8gB2oN/MtlfSrJvB18Z27UX632EWa8plJN74cmhc0xxmpYXXPOEx8hb1yfsjKQS1o
         PntV2ZaaR8OMGDjV/oKJN6y4t21ojyqrJEwy8KOS/5RX/WNBK92y3tHrz9ynDyzHXzvH
         bYgDRYn+0lKyIGHx7XDJ5ZHjk5g3oQlyxMWctxfvvtN7snhPpO4TrS3iVWNEIRVV14fg
         yG2o+fWc3ZELgQ3oOdRhccDoguXke5AJdHN/qi7bkVB6dsNES8UJh3QUwLlqEo4ZsaeN
         Eb3mgqocRUOwARnJSjqkIJoq8samlRfrpSVdkf+e2wqhiujYYa6iBn57dHux3ANbOgm+
         Jh5w==
X-Gm-Message-State: AOAM531xuJzjJf8A8ce6BFxfNJNKID4n4+lH0RGhUZyUhmktBrFNzdQT
        KKeqlGweJI1rF+2KDaSur/tQ5DaAMMD9grbwh7E=
X-Google-Smtp-Source: ABdhPJxajcbYBx8tk3Bx64nyQJCs4ShbYe+K8BoN1y1TtFk3bbbDw1byJvbC7mp95pF3DvNoR24QNuKnsEi+HLGO2HI=
X-Received: by 2002:a1f:ae8a:: with SMTP id x132mr300403vke.23.1632336369855;
 Wed, 22 Sep 2021 11:46:09 -0700 (PDT)
MIME-Version: 1.0
Reply-To: bfkabiruwahid@gmail.com
Sender: ballaw100@gmail.com
Received: by 2002:a67:c101:0:0:0:0:0 with HTTP; Wed, 22 Sep 2021 11:46:09
 -0700 (PDT)
From:   MR KABIRU WAHID <bfkabiruwahid@gmail.com>
Date:   Wed, 22 Sep 2021 11:46:09 -0700
X-Google-Sender-Auth: EiSFuFBgLx83DrMHyLQRlZbc2A4
Message-ID: <CAJfVvULFf7QQODvk9q_aB2LoDDciRhEoEkv90QzSUmgypbb9TQ@mail.gmail.com>
Subject: REPLY ME IMMEDIATELY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sir, I know this email might come to you as a surprise coming
from one you haven=E2=80=99t meant before. I am Mr.Kabiru Wahid, a bank
manager with ADB BANK and a personal banker to Mr. Salla Khatif an
Egyptian who happened to be a Food supply contractor attached to the
former Afghanistan government before they were overthrown by the
Taliban government.Mr.Salla Khatif have a deposit of huge sum with our
bank but passed away with all his family on the 16th of May 2017
trying to escape from Kandahar Afghanistan.


The said sum can be used for an investment if you are interested, all
details relating to the funds are in my position, I will present you
as his Next-of-Kin because there is none, and will furnish you with
more details upon your response to this email:kabiruwahidy47@gmail.com
Regards,
Mr.Kabiru Wahid.
