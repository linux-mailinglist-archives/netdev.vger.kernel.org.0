Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212BA301317
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbhAWEyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbhAWEyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 23:54:09 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B87C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:28 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id p18so5206126pgm.11
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=V/IQLdGVNKOhFlkJ7y6qwsXf4DTwRjGP0jAl6GlQ9+0=;
        b=FpUnmMaqvTr1oKTl4GiEW6KrFfYs9WCfDkokK442bDt3Vibjr8/9YX21xqk0N89vjY
         EjLLljU1CdOUHdWQ4da8clzC25uD9/bP7wdD/O2OJO89HuzVxsnTKyFqTLY8g944zM8c
         V/dmlfoKjyfmAxKqZy9l8kkT0K57qVgupLy5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=V/IQLdGVNKOhFlkJ7y6qwsXf4DTwRjGP0jAl6GlQ9+0=;
        b=PUbzBHg7uBmZQU0j1uYgTwmrewszELNqvxkHsWYmjx3BhHqfpigrYAS5RU4dzo+60z
         nkeL4ckCCzlndD8CrTiH/vyBZ94+ywn7f/CqmK8JMET1CrdgZCJcLdAhNIysjQHkn3wk
         KoSVo0U9svaAF7qm3Z2Jb5/nNAyogPcJRCKxpbi2+22wiDPZqfLNWXsJUVNS3J5kPRu3
         P31c56JnsJGyevDcZY1H2QIrNMk3vr5e2JWBk4rygl4gvVm2IUtxJJg2wAEadNdqfcx2
         fAcCfsevlISJgVTw4p6ctOtm4VVO38VrmHfogG2EaoZXdukg4kX1tmtIiU6shug5YllY
         QZog==
X-Gm-Message-State: AOAM533803qNHiVhrCD8uJIZLxFl6fJn3XPEFwuYwIhmox45hDu3ogHe
        +ZhyIqyqldrtC2/z/nRyeHszBqkk8/6EKu0r4Syvsj4VZ+GxHtMZPplW5+O7jHvPCbfR/7yFFEo
        n2NHfeqguEJK4miJe1sUcddLlOrnbgJQnesH1R7RAVybaOjnwxdjbB7WJviCXMMBPHmQElJT+
X-Google-Smtp-Source: ABdhPJxz2DlwR/Vm3s2byAKpB0nzcWcC7mxLyv5J7iPKH3Qoxi0FMeU7RfsIXmTAPBFMyMWVSHhB0Q==
X-Received: by 2002:a62:4d03:0:b029:1ac:6159:4572 with SMTP id a3-20020a624d030000b02901ac61594572mr8574230pfb.10.1611377607491;
        Fri, 22 Jan 2021 20:53:27 -0800 (PST)
Received: from hex.swdvt.lab.broadcom.net ([2600:8802:d04:de02::77c])
        by smtp.gmail.com with ESMTPSA id d2sm10725832pjd.29.2021.01.22.20.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:53:25 -0800 (PST)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 0/4] support for 256 VFs in RTM_GETLINK 
Date:   Fri, 22 Jan 2021 20:53:17 -0800
Message-Id: <20210123045321.2797360-1-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000edea4c05b98a15bc"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000edea4c05b98a15bc
Content-Transfer-Encoding: 8bit

RTM_GETLINK for greater than about 220 VFs truncates IFLA_VFINFO_LIST
due to the maximum reach of nlattr's nla_len being exceeded. There is
not a lot of enthusiasm for extensive fixes to the deprecated netlink
ABI for VF config, but there appears to be even less appetite for the
kinds of work arounds that would be necessitated in order to truly
keep it frozen [1].

This series first addresses nla_nest_end()'s propensity to generate
malformed netlink messages. The balance of the series comprises very
minor ABI updates intended to be low impact, in order to address the
remaining issues. First, the existing RTEXT_FILTER_SKIP_STATS is
called upon to alleviate the problem when user space does not want
statistics and then a minor tweak is introduced in two steps in order
to promote the stats one level up in the hierarchy with the minimum
of code churn.

Finally, the kernel series is followed by an iproute2 series to take
advantage of the changes.

[1] https://lore.kernel.org/netdev/20210115225950.18762-1-edwin.peer@broadcom.com/

Edwin Peer (4):
  netlink: truncate overlength attribute list in nla_nest_end()
  rtnetlink: extend RTEXT_FILTER_SKIP_STATS to IFLA_VF_INFO
  rtnetlink: refactor IFLA_VF_INFO stats into rtnl_fill_vfstats()
  rtnetlink: promote IFLA_VF_STATS to same level as IFLA_VF_INFO

 include/net/netlink.h          |  11 ++-
 include/uapi/linux/if_link.h   |   1 +
 include/uapi/linux/netlink.h   |   1 +
 include/uapi/linux/rtnetlink.h |   1 +
 lib/nlattr.c                   |  27 +++++++
 net/core/rtnetlink.c           | 132 +++++++++++++++++++++------------
 6 files changed, 122 insertions(+), 51 deletions(-)

-- 
2.30.0


--000000000000edea4c05b98a15bc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
mbo++PCnVfHaIk6rK1M0CPodEV0uUttmi6Mp/Ha7XmNgWQeQE3qkFIwAlb/kPNmJAMECAwEAAaOC
Ac4wggHKMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUHMAKGQWh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNoYTJnM29j
c3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25h
bHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1UdHwQ9MDsw
OaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hhMmczLmNy
bDAiBgNVHREEGzAZgRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcD
BDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU9IOrXBkaTFAmOmjl
0nu9X2Lzo+0wDQYJKoZIhvcNAQELBQADggEBADL+5FenxoguXoMm8ZG+bsMvN0LibFO75wee8cJI
3K8dcJ8y6rPc6yvMRqI7CNwjWV5kBT3aQPZCdqOlNLl/HnKJxBt3WJRWGePcE1s/ljK4Kg1rUQAo
e3Fx6cKh9/q3gqElSPU5pBOsCEy8cbi6UGA+IVifQ2Mrm5tsvYqWSaZ1mKTGz8/z8vxG2kGJZI6W
wL3owFiCmLmw5R8OH22wqf/7sQFMRpH5IQFLRYdU9uCUy5FlUAgiCEXegph8ytxvo8MgYyQcCOeg
BMfFgFEHuM2IgsDQyFC6XUViX6BQny67nlrO8pqwNRJ9Bdd7ykLCzCLOuR1znBAc2wAL9OKQe0cx
ggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMw
MQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDCXgDAeB
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg1PUDNs2bbrO/7qWje0ru
lD3oHDPZKu+yb/8GeXb9apAwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTIzMDQ1MzI4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABVdXraIYvuUihWJdEJcZiO2yTHuxSGzCgBwrWHb
5tQgDR0MZrAlBkyJIU6hUwQ9eOkiX5+TlezEzP3/4QYScuiB/N5r1NgLfgCCjkuNJ9BY569ZEMFY
8aNDvD3p2wM6QOJQeVmmYl5p6i6dbFaev+rr0McQUpylsGPZnKfINzfMspIorgkpx+3Bw5YkByAp
71BivHY6s+6YhFitrUDfk9SUstMXJf3wRGnr84A/Cg63gzKrNUqidUnAm3MPI9+8+5htDio0V3Ie
Cgp0Bl3MDEQgg6ZxLcPD2ve5+sCkLN5Dy7tbd1j3Kuh+YNZ8hyJJKth5P1GReEcsFbxqJV592Bw=
--000000000000edea4c05b98a15bc--
