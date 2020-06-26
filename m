Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEADF20B085
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgFZLai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:30:38 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36370 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbgFZLah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 07:30:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1A0FE20569;
        Fri, 26 Jun 2020 13:30:35 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zl5wSdZ6nArH; Fri, 26 Jun 2020 13:30:34 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8DABA20270;
        Fri, 26 Jun 2020 13:30:34 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 26 Jun 2020 13:30:34 +0200
Received: from [172.18.16.185] (172.18.16.185) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 26 Jun
 2020 13:30:33 +0200
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>
From:   Torsten Hilbrich <torsten.hilbrich@secunet.com>
Autocrypt: addr=torsten.hilbrich@secunet.com; prefer-encrypt=mutual; keydata=
 xsBNBFs5uIIBCAD4qbEieyT7sBmcro1VrCE1sSnV29a9ub8c0Xj0yw0Cz2N7LalBn4a+YeJN
 OMfL1MQvEiTxZNIzb1I0bRYcfhkhjN4+vAoPJ3q1OpSY+WUgphUbzseUk/Bq3gwvfa6/U+Hm
 o2lvEfN2dewBGptQ+DrWz+SPM1TQiwShKjowY/avaVgrABBGen3LgB0XZXEH8Q720kjP7htK
 tCGRt1T+qNIj3tZDZfPkqEVb8lTRcyn1hI3/FbDTysletRrCmkHSVbnxNzO6lw2G1H61wQhw
 YVbIVNohY61ieSJFhNLL6/UTGHtUE2IAicnsUAUKR8GiI1+3cTf233O5HaWYeOjBmTCLABEB
 AAHNL1RvcnN0ZW4gSGlsYnJpY2ggPHRvcnN0ZW4uaGlsYnJpY2hAc2VjdW5ldC5jb20+wsB3
 BBMBCAAhBQJbObiCAhsDBQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEJ7rXZh78/h8+tIH
 +QFYRQH4qh3WagcmjbG/zCe2RmZZePO8bmut2fAxY04aqJZGYUBxb5lfaWaHkstqM5sFD8Jo
 k1j5E7f1cnfwB21azdUO8fzYL889kdVOzatdT/uTjR7OjR59gpJMd4lx7fwFuZUg8z6rfWJ3
 ImjxxBgaJRL6pqaZ9lOst82O0qJKEFBR+HDUVvgh4n8TTOfKNv/dGPQhaed+2or98asdYRWo
 S/zc4ltTh4SxZjLd98pDxjlUyOJoMJeWdlMmLgWV3h1qjy4DxgQzvgATEaKjOuwtkCOcwHn7
 Unf0F2V9p4O7NFOuoVyqTBRX+5xKgzSM7VP1RlTT4FA9/7wkhhG+FELOwE0EWzm4ggEIAL9F
 IIPQYMx5x+zMjm8lDsmh12zoqCtMfn9QWrERd2gDS3GsORbe/i6DhYvzsulH8vsviPle4ocU
 +PaTwadfnEqm0FS7xCONYookDGfAiPS4cHWX7WrTNBP7mK3Gl1KaAOJJsMbCVAA9q4d8WL+A
 e+XrfOAetZq5gxLxDMYySNI1pIMJVrGECiboLa/LPPh2yw4jieAedW96CPuZs7rUY/5uIVt0
 Dn4/aSzV+Ixr52Z2McvNmH/VxDt59Z6jBztZIJBXpX3BC/UyH7rJOJTaqEF+EVWEpOmSoZ6u
 i1DWyqOBKnQrbUa0fpNd3aaOl2KnlgTH9upm70XZGpeJik/pQGcAEQEAAcLAXwQYAQgACQUC
 Wzm4ggIbDAAKCRCe612Ye/P4fEzqB/9gcM/bODO8o9YR86BLp0S8bF73lwIJyDHg5brjqAnz
 CtCdb4I+evI4iyU9zuN1x4V+Te5ej+mUu5CbIte8gQbo4cc9sbe/AEDoOh0lGoXKZiwtHqoh
 RZ4jOFrZJsEjOSUCLE8E8VR1afPf0SkFXLXWZfZDU28K80JWeV1BCtxutZ39bz6ybMbcCvMS
 UfwCTY0IJOiDga1K4H2HzHAqlvfzCurqe616S4S1ax+erg3KTEXylxmzcFjJU8AUZURy/lQt
 VElzs4Km1p3v6GUciCAb+Uhd12sQG2mL05jmEems9uRe3Wfke/RKp8A+Yq+p6E0A0ZOP+Okm
 LXB2q+ckPvZG
Subject: Number IPv6 routing entries are growing without limit when processing
 routing advertisements
Message-ID: <7aebcea5-bf28-e31c-39b1-f3de45b8df41@secunet.com>
Date:   Fri, 26 Jun 2020 13:30:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please CC me on replies

Hello,

a colleague of mine detected that a kernel since version 4.17 does not limit the number of IPv6 routing entries when processing routing advertisements.

I checked it now with a kernel based on v5.4.42 and could confirm this behavior. The configuration setting are as the following:

- net.ipv6.route.max_size: default setting 4096
- net.ipv6.route.gc_thres: default setting 1024
- net.ipv6.conf.eth0.accept_ra: 2
- net.ipv6.conf.eth0.accept_redirect: 1
- net.ipv6.conf.eth0.disable_ipv6: 0

The test is running the tool atk6-flood_router26 (from debian package thc-ipv6) from another machine connected via LAN on eth0. This tool when sent about 16000 routing advertisement per second in my test setup. The lifetime of the resulting routing entries seems to be about 130,000s. The default routes added have a lifetime of 65,535s.

The test shows the following:

- for every routing advertisement a new default route entry is added by ndisc_router_discovery
- the limit set by net.ipv6.route.max_size is not honored, even after a single second I have these 16000 routing entries
- after a view minutes of testing I can easily have millions of routing entries
- the free memory is reduced with a speed of about 1.2 MByte/s

I assume that the code changes regarding dst entries and fib6 entries which has been completed with commits:

commit 8d1c802b2815edc97af8a58c5045ebaf3848621a
Author: David Ahern <dsahern@gmail.com>
Date:   Tue Apr 17 17:33:26 2018 -0700

    net/ipv6: Flip FIB entries to fib6_info
    
    Convert all code paths referencing a FIB entry from
    rt6_info to fib6_info.
    
    Signed-off-by: David Ahern <dsahern@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 93531c6743157d7e8c5792f8ed1a57641149d62c
Author: David Ahern <dsahern@gmail.com>
Date:   Tue Apr 17 17:33:25 2018 -0700

    net/ipv6: separate handling of FIB entries from dst based routes
    
    Last step before flipping the data type for FIB entries:
    - use fib6_info_alloc to create FIB entries in ip6_route_info_create
      and addrconf_dst_alloc
    - use fib6_info_release in place of dst_release, ip6_rt_put and
      rt6_release
    - remove the dst_hold before calling __ip6_ins_rt or ip6_del_rt
    - when purging routes, drop per-cpu routes
    - replace inc and dec of rt6i_ref with fib6_info_hold and fib6_info_release
    - use rt->from since it points to the FIB entry
    - drop references to exception bucket, fib6_metrics and per-cpu from
      dst entries (those are relevant for fib entries only)
    
    Signed-off-by: David Ahern <dsahern@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

might have changed the behavior here. Before these commits the max_size has been checked by ip6_dst_gc. It seems that this code path is gone now.

I already checked the gc support for fib6. It seems that this is regularly run (about every 30 seconds by default) and removes entries which lifetime has expired.  This is not sufficient for such an Denial of Service attack.

Any ideas on the problem?

Thanks,

	Torsten
