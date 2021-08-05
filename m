Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7C13E1D9F
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbhHEUyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhHEUyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 16:54:08 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCF6C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 13:53:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id x14so10194183edr.12
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 13:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=NBk4v7YJbgRux5qvAIwvi4IbfCS0FzKP8BULNvVbo8k=;
        b=chEEneEuTkdmPpPwDKs+6gKVJ8L5edK6WPaYK0i6CBIAUwkdSbsYJhPcCu9I+MDe/a
         bNLgyMxzWx0nhwCBghFuDsbnfOkN7WilCDtZK7XSVAr/z4/GR0fRpwMiYF2wkexwQYO6
         LPulZmpb9DyHOIyilQjnXC41cEKINnz+HWNlb8tKloxU0RLGbN7M0I1ArTL1QwQZIKQD
         sCPpM0Hr/T6Pe+ibkhjv23DLVLw/ChMLUpo4rKrFJ2sKKABAKYyd3pFm52IvZoYiDEI+
         VBZGx0i/+IUQgvHpmb2WERdTvkS3Bdtntb+hzWtVxtfBqe7Ki0qkUVAhJmKmmxrEtLju
         xOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=NBk4v7YJbgRux5qvAIwvi4IbfCS0FzKP8BULNvVbo8k=;
        b=CkaIT0IIScN3XL4h01Y1bv1Wf/Ls3zxNUspTipuRkeQeXEAYDFCyCKZxWmi6y68wtS
         HIrRpSbCph0nUQqs5EA4VFdJ80Q6cJ8C6u8jT4rTzup35YeIO2Uf0W68SMWm2OZi85oB
         /1rCQuXA0o1OLOWjekqJMFkKdeF1zoJprFP6qrJHy1PLKNegET7jMPWrgAqkeblEC+Kg
         LXUDQZHVouivl6LR7Of632nSiwXk5smwk7HJauNl7d8sHdk3zPZ9AWLMWur34AmNR3lj
         YaEjZPjjsauRR2zjCz7HOnDlEl76KCj1qOcZ64qtP23EA6+dNWu6qNuCVqv5Nenna1/v
         tMtg==
X-Gm-Message-State: AOAM530dZjZ2ew6fQ7hmMbUXRStdh+wRJSf581amzfeEXVLSkbp6YjzM
        7kIxQZWoYMgBEXSRy0e74EWsB1pxIfzt/Q==
X-Google-Smtp-Source: ABdhPJx/UAaOLTZqEHqxay7bUTyDGw4e9zoy7uMUt8ixUMRD90kS/YPFVFfLWOGmbkwi0TyZhcHqFw==
X-Received: by 2002:a05:6402:60e:: with SMTP id n14mr8955741edv.142.1628196831821;
        Thu, 05 Aug 2021 13:53:51 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id mh10sm2088440ejb.32.2021.08.05.13.53.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Aug 2021 13:53:51 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport endpoint is
 not connected
Message-Id: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
Date:   Thu, 5 Aug 2021 23:53:50 +0300
To:     netdev <netdev@vger.kernel.org>, gregkh@linuxfoundation.org,
        Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Net dev team


Please check this error :
Last time I write for this problem : =
https://www.spinics.net/lists/netdev/msg707513.html

But not find any solution.

Config of server is : Bonding port channel (LACP)  > Accel PPP server > =
Huawei switch.

Server is work fine users is down/up 500+ users .
But in one moment server make spike and affect other vlans in same =
server .
And in accel I see many row with this error.

Is there options to find and fix this bug.

With accel team I discus this problem  and they claim it is kernel bug =
and need to find solution with Kernel dev team.


[2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:05.298] vlan912: 24b205903d097162: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:11.000] vlan912: 24b205903d097105: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:30.249] vlan496: 24b205903d097184: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:40.032] vlan912: 24b205903d097182: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:43.102] vlan912: 24b205903d097190: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:43.850] vlan479: 24b205903d097153: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:43.850] vlan479: 24b205903d097141: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:43.852] vlan912: 24b205903d097198: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:43.977] vlan637: 24b205903d097148: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected


Martin=
