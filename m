Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97161076F3
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 19:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKVSID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 13:08:03 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44316 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfKVSID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 13:08:03 -0500
Received: by mail-lf1-f66.google.com with SMTP id v201so5132049lfa.11;
        Fri, 22 Nov 2019 10:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T7/nfHWQBPlTCdPwZsbfc1JI4CJ6zRhYvBPNH/OaKDE=;
        b=gpePcEhkMiv/zogb3LXutIPpvN7zhiJB5FK3KMarQP8hVubbFEJVoU5bUQQs1z8syN
         ufFoOrdK04Ue5PlH4SSSnBwgMHJx9v+WC7pcEI3CmJu+nIj5MVt224kiCBVXLyRM/F24
         H0J4ma17nKYpLcTMXEH07E4ueB2ANLesvdj7VkgQO3vnDAG5wQabqsYgNsVwHfwrlZ4j
         fsgnyRQ/SkAeKRFLMDiWopZ2wxl2cEIkG752MMLcI10TgCaDTyHZFI0bgzZW0QQYLMiA
         3p1V4SWy/I1BqKptS95IX/NlRKT4vR5iUFu4CFqPPkpVkRUQcwYkDorMQYxHDtR3l64V
         JTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T7/nfHWQBPlTCdPwZsbfc1JI4CJ6zRhYvBPNH/OaKDE=;
        b=hoJ7TAzSvdZ81Z04QQtrwZpN490fd58IelId1qs9LunbJRUA72YYolOU+zPHFJdZBZ
         kgADgbkvbMsc6whiPIFxwcVnF/rJ0FQ1cQ6TYa13Ltg8WYjG9nW6CdDXawCY8TEhsQ4r
         yaB7lRsIxG/8tMUE1lNE9woAaNEpa86fwFfykaBHC67DdR5QCBX2zJJX1KGLPvengc/j
         o2NtElxgevWUdbuv4iwCbfVpxlNbk/c6vvu6AAKmenATllgpiUNtsSMSL5te8MTLtJQQ
         b8TuMt6plaDH0cPl6eu9rptZSHiaZexVIM4PatRsimb/cprnqrOGgfMqNRBnhR6Y7cbj
         kj4A==
X-Gm-Message-State: APjAAAXhRY0P+Y1fCd6CDddTzx03BpJeVjquJjwRe34Zlu4JZ1EZFUi6
        nRY+stKLCUl1CuY697ybGDxXGztJRKuQWHJcF1s=
X-Google-Smtp-Source: APXvYqz3ud5QamIZF2mlMJ/cfkLH57ksgQNb7htbHLw1W8fxPUPxWJPlANYEGFhW51mcnlE+P51wBk0UfKJfunfzBQs=
X-Received: by 2002:ac2:424d:: with SMTP id m13mr668264lfl.13.1574446079536;
 Fri, 22 Nov 2019 10:07:59 -0800 (PST)
MIME-Version: 1.0
References: <20191108152013.13418-1-ramonreisfontes@gmail.com>
 <fe198371577479c1e00a80e9cae6f577ab39ce8e.camel@sipsolutions.net>
 <CAK8U23amVqf-6YoiPoyk5_za3dhVb4FJmBDvmA2xv2sD43DhQA@mail.gmail.com>
 <7d43bbc0dfeb040d3e0468155858c4cbe50c0de2.camel@sipsolutions.net>
 <CAK8U23aL7UDgko4Z2EkQ9r4muBTjNOCq-Erb9h2TFRnxdOmtWg@mail.gmail.com> <175edd72f0cd3bc4d2c0dbd42a4570c7fb47b8fd.camel@sipsolutions.net>
In-Reply-To: <175edd72f0cd3bc4d2c0dbd42a4570c7fb47b8fd.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Fri, 22 Nov 2019 15:07:48 -0300
Message-ID: <CAK8U23bLht3d9B==aZKOxhgP=nhCZqQ0zwcYRevgwof7+MsTdw@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: set the maximum EIRP output power for 5GHz
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If there's some other (physical?) restriction in the driver, sure, maybe
> it should have one there, but for pure regulatory I'm not sure I see it.
> That's why the pointer here to ETSI feels so strange to me.

Ok. I see. You can change the commit msg then.

> Note that I just sent my final pull request for the current kernel, so
> this'll probably have to wait some time.

Ok. No problem.

--
Ramon
