Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F7848A71F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 06:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245292AbiAKFVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 00:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241556AbiAKFVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 00:21:45 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17C1C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 21:21:44 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso699018wmj.2
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 21:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zOHJbgxEeKcTUS1M3dbg/CCHL8zxNc7o7Y1pwSiNVNQ=;
        b=dGXpiNqXJsaL2BENIkbXrUqN85leKVDC0ZxObxjP+LEMrKDsK8k3n6VbWoTeVJpuAP
         aL6tIy1elkTHNjujWea7h8/flcSLIqvJ2XLBwx+HO3ZilT9lekWtxLNFKFEsDt4xRFsy
         IwIKFIWZgffbzOLy1kuaZQ1GNrcVR5JVfOimxiC+Sc1KPB7nure+WBYPnzTa7c0e+sbv
         2Jqo9ZG6+vHLFdnlmdu4Fz2Imre80wuI8hEF8BUYS6dgVRwia900BMVmJB+aVYBaXH1q
         fY0wlKZtoRt/pQNij4RCPThRC9xzFoJHKHMhONwhtIE4rGY6NEae3FgZfnM6qowprs39
         lXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=zOHJbgxEeKcTUS1M3dbg/CCHL8zxNc7o7Y1pwSiNVNQ=;
        b=Xv9GbmapuTjzVxaLKYaI5S5kVU2DiE2CcUrVERXhJ8ldizQDphT3dYZeyHNMRs4ofj
         5xNQytvImR0/MxdbBfuN4qBZKgQ/pPbRX7sqxgxLpRscVZXm7H5ATyueFHerpRtDDkv2
         4rwLiqEk/QEeP9iClLTrm2yb+6c25NLfZWcRxImi/++H0UyubKOeF99zCzZhIOUx/V94
         RgZrjuhcREeEK6Hp5xA7wlDKV2VRz+6e7SGOIKt5YB3PUcT4R4bsgb85HYTZrZxMZe0y
         LB+AVDaED1d/WnpcmvJtDUgnfPUDN+kswuo0YaGTi6poQe0U9eCsFeDDUpLWa70yquis
         UiPw==
X-Gm-Message-State: AOAM532Whq4WqqdJIHTq8ZkOr6x7GUhDkHv+rJ3bQtE1HZ1c60RM1jAa
        bxuAemQgymss371HOgKlAPO2Jr192jMxCwbXpsU=
X-Google-Smtp-Source: ABdhPJxazH/TDo9B/vSx5/1vEESMs61XJ3bXcIbTi7qgvROlo0OSjWaF7RR8vtQPjg6DHRkF5SE3ysnJE9NNjfpP44E=
X-Received: by 2002:a7b:c94f:: with SMTP id i15mr881345wml.162.1641878503205;
 Mon, 10 Jan 2022 21:21:43 -0800 (PST)
MIME-Version: 1.0
Sender: donnalouisemchince@gmail.com
Received: by 2002:adf:e3c8:0:0:0:0:0 with HTTP; Mon, 10 Jan 2022 21:21:42
 -0800 (PST)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Tue, 11 Jan 2022 05:21:42 +0000
X-Google-Sender-Auth: Yek2CYeDsthCl9s0_Er4aXWDZGY
Message-ID: <CA+4RuvvkTWC0oCRyam+CKR7bZgv7XimXCdjoenp1YBJJPfd7Gw@mail.gmail.com>
Subject: Calvary greetings.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina. Howley Mckenna, a widow. I am
suffering from a long time brain tumor, It has defiled all forms of
medical treatment, and right now I have about a few months to leave,
according to medical experts. The situation has gotten complicated
recently with my inability to hear proper, am communicating with you
with the help of the chief nurse herein the hospital, from all
indication my conditions is really deteriorating and it is quite
obvious that, according to my doctors they have advised me that I may
not live too long, Because this illness has gotten to a very bad
stage. I plead that you will not expose or betray this trust and
confidence that I am about to repose on you for the mutual benefit of
the orphans and the less privilege. I have some funds I inherited from
my late husband, the sum of ($ 11,000,000.00, Eleven Million Dollars).
Having known my condition, I decided to donate this fund to you
believing that you will utilize it the way i am going to instruct
herein. I need you to assist me and reclaim this money and use it for
Charity works therein your country  for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die.. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply..

May God Bless you,
Mrs. Dina. Howley Mckenna.
