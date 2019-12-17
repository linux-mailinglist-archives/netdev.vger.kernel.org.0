Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFEA122F16
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfLQOop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:44:45 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:36969 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfLQOoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 09:44:44 -0500
Received: from [192.168.1.155] ([95.114.21.161]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MuUvS-1hqm5e2k0Q-00rXXn; Tue, 17 Dec 2019 15:44:28 +0100
Subject: Re: [PATCH] RFC: platform driver registering via initcall tables
To:     Greg KH <greg@kroah.com>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, dmitry.torokhov@gmail.com,
        jacek.anaszewski@gmail.com, pavel@ucw.cz, dmurphy@ti.com,
        arnd@arndb.de, masahiroy@kernel.org, michal.lkml@markovi.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20191217102219.29223-1-info@metux.net>
 <20191217103152.GB2914497@kroah.com>
 <6422bc88-6d0a-7b51-aaa7-640c6961b177@metux.net>
 <20191217140646.GC3489463@kroah.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <d938b8e1-d9ce-9ad6-4178-86219e99d4df@metux.net>
Date:   Tue, 17 Dec 2019 15:43:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191217140646.GC3489463@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: tl
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:w0io69mBkaf+1h5xS2clNhiKVEe0x4xPMiO1d6eDOgUuj5grIk6
 So0gw1+GpivSUVTFQR/DDSbg+QPfwUh7WmxUQSwRGfkUPGn5UuLFc7ZXrVgMiGCWcvV7EnZ
 YcouJJBHv4s14A2UoTWwsoWv1v7AXM1bV8eKUMEFutfAUA0OO6kYs7L0qW0jC11eMqimXtO
 a6XJNpIUDfbJJ14c1ttfw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sYdPWCf9KOc=:0AdzDPaTOQKhydTgTxPD3i
 7vxT1r6DXk1q3sntultkN3yeyfwZO1L5/I1tey9mzWV4VA+QtLhy8j/GxOIkVoro6LseGlci6
 W12X0KPN6zHyzUFSEN+WudCDKhMSlfHeKZFry+8utzzVh6X9+igOSGELwhRWwdqQJiZOcu0oO
 QZ05ieWKgwvl2Uh/MTg3RL2rBdrdsEAyemNTcVIECVbSPuHPq8auHKLK93V7iegjvA0alhL1U
 /WaxrxT+hXtjLC5Y831LJC9pTnymxqwddhRor0yitiemCO20+Mt4kNnapMMvBDlgit3U9kCWQ
 ghGaWfk2sB8r7OhNMqgF4AcETtelNyx8ZQjuxDdhj3ikLhlIf4dSz/5U1KyusXwnJ7lk0EX8V
 dPLRb30N/xbIpSx44Lhd6/rgXBKpZ7FH12J/8gAAyWIKwO+w0pwFu8U8MTiUnCLlpDB7s67q8
 Tq14Jj4cBz5vzTEHK1X6ZMsayDQl4Lm9NCbf+JrbqipltyHENFei9Roxzr27MBzuTGO7qSiT+
 IDmX9O+smuMCUheOjOxXAWdsli6m+5yHIx4jWjyt9GNlGerF+YvMktccX/fSzS+5MhHH9zJqy
 DgtqxPSJhnAd5M/YSfD7Ivsjhoxx6G5V2BHwwGwEhVxZWIK6leQxc9x7ntbA+ploa4GgA/8Mv
 AOdgb5DGJbfqvDiIjJyE3Kq6vR97PhyIOT4HY9flUCSa1gKkPC5p/WvWC6mpXlfXCRgzt3IF+
 3oVArTRk9F1Kc+K0wuTuPBtt4Kgs+Un9XjZUDiZdMnIqH1J2Ed29wURCgNhD6S8guCL7jAL7I
 Z0z8+jHTBIU3qT6HA9SqRQtKynKLt5/00XkPx6phElHcm7JrtRgFPVAz1gTlfHSQr6qUSFbrz
 q03NkMAgx3EPRvOQwR7w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.12.19 15:06, Greg KH wrote:

> That's not needed, and you are going to break the implicit ordering we
> already have with link order.  

Ups, 10 points for you - I didn't consider that.

> You are going to have to figure out what
> bus type the driver is, to determine what segment it was in, to figure
> out what was loaded before what.

hmm, if it's just the ordering by bus type (but not within one bus
type), then it shouldn't be the big deal to fix, as I'll need one table
and register-loop per bus-type anyways.

By the way: how is there init order ensured with dynamically loaded
modules ? (for cases where there aren't explicit symbol dependencies)


--mtx

---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
