Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12DF1C4AE8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgEEAQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgEEAQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 20:16:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B642C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 17:16:22 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b8so191037pgi.11
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 17:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r7CvUjYeDUC7mWj2yED8c1P8EBv/h1lzCk81rXUR7Yk=;
        b=JAVylyNkqPWJTwYgsKy57SA7PkZJWwdAOeNqZqnk/EsVQCL0sC5Zp/sm4wY4ZLVa6W
         xsXD4niiaR7G9TX6IPLAN4lQ08sMAe+Y8tdEWsH76VJ0X4kLy88/02etj7XhxOtVKQoL
         Pef+DgIdIH5HSFnc0uDWf+93rhHyd5vMQ4lzoSwrRzxHh+IeulQQKLAjKSkqRQ2+ngCP
         WmYI9kUbmxDVBB4xmGiu4JsVcAC2xDduvl9a1c+M8q4FG7BmaE9+4aOnhfjoEzX/FVo2
         NxKujunKWwI2hbb6oXw44DnlW1z+RWX1Jp90GpR4lFnzqsT1LNUUYdFHm+E5rbG5V4u1
         ax4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r7CvUjYeDUC7mWj2yED8c1P8EBv/h1lzCk81rXUR7Yk=;
        b=l0wXoD7CtQut/aIxasR5YYVkHnqwjj6FPpqjd0yezaAvrAbJB8xXBpSiJqr5LH+okB
         ibCkhK1WmH7d2BSEbJBA/uFzlohb6K00n8kjxOwrbv+r3Fsg9o76YxOQzZhVdX+pgPpP
         ZyktyQps9Nex7dUQIwiITRc9wBgTj/FdchLEQOXaDC9pgQjWdKaYp6KDowltiO6OlRu5
         6SeOr4hRYIxJ5iy4laOAOiIaROunSF+sYDbakWjV4EyOirwv6YWn3ltwZgPemCEGssoV
         GqgDibRPA8M131Nnr4rbV93QxrJk4sdj3xhoOb03OkiHQu88c2Q99QNRN0ex0vvU4TXl
         Sftg==
X-Gm-Message-State: AGi0PuZo4FxubkyNtmIeJA90fenVUIkrY/Vc6Q78Nzajc9sw0YXg50aq
        UrCYSRG/jRZ4OxQ6WpNml/mD7w==
X-Google-Smtp-Source: APiQypJdD5GVZ+Y/LNBIYcOThQM5v89+s3NUmVcGWXOXgBuDOkevYzGbocbPjiIdi+V+E4cTPsQTjw==
X-Received: by 2002:aa7:9d84:: with SMTP id f4mr516644pfq.290.1588637781420;
        Mon, 04 May 2020 17:16:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o11sm176236pgp.62.2020.05.04.17.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 17:16:21 -0700 (PDT)
Date:   Mon, 4 May 2020 17:16:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: Re: [PATCH iproute2 v2 0/6] bridge vlan output fixes
Message-ID: <20200504171613.68bf90a0@hermes.lan>
In-Reply-To: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
References: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 May 2020 17:47:14 +0900
Benjamin Poirier <bpoirier@cumulusnetworks.com> wrote:

> More fixes for `bridge vlan` and `bridge vlan tunnelshow` normal and JSON
> mode output.
> 
> Some column titles are changed, empty lines removed from the output,
> interfaces with no vlans or tunnels are removed, columns are aligned.
> 
> Changes v2:
> * dropped patch 1, "bridge: Use the same flag names in input and output"
> 
> Sample outputs with this config:
> 
> ip link add br0 type bridge
> 
> ip link add vx0 type vxlan dstport 4789 external
> ip link set dev vx0 master br0
> bridge vlan del vid 1 dev vx0
> 
> ip link add vx1 type vxlan dstport 4790 external
> ip link set dev vx1 master br0
> 
> ip link add vx2 type vxlan dstport 4791 external
> ip link set dev vx2 master br0
> ip link set dev vx2 type bridge_slave vlan_tunnel on
> bridge vlan add dev vx2 vid 2
> bridge vlan add dev vx2 vid 2 tunnel_info id 2
> bridge vlan add dev vx2 vid 1010-1020
> bridge vlan add dev vx2 vid 1010-1020 tunnel_info id 1010-1020
> bridge vlan add dev vx2 vid 1030
> bridge vlan add dev vx2 vid 1030 tunnel_info id 65556
> 
> ip link add vx-longname type vxlan dstport 4792 external
> ip link set dev vx-longname master br0
> ip link set dev vx-longname type bridge_slave vlan_tunnel on
> bridge vlan add dev vx-longname vid 2
> bridge vlan add dev vx-longname vid 2 tunnel_info id 2
> 
> Before & after:
> 
> root@vsid:/src/iproute2# bridge -c vlan
> port    vlan ids
> br0      1 PVID Egress Untagged
> 
> vx0     None
> vx1      1 PVID Egress Untagged
> 
> vx2      1 PVID Egress Untagged
>          2
>          1010-1020
>          1030
> 
> vx-longname      1 PVID Egress Untagged
>          2
> 
> root@vsid:/src/iproute2# ./bridge/bridge -c vlan
> port              vlan-id
> br0               1 PVID Egress Untagged
> vx1               1 PVID Egress Untagged
> vx2               1 PVID Egress Untagged
>                   2
>                   1010-1020
>                   1030
> vx-longname       1 PVID Egress Untagged
>                   2
> root@vsid:/src/iproute2#
> 
> ===
> 
> root@vsid:/src/iproute2# bridge vlan tunnelshow
> port    vlan ids        tunnel id
> br0
> vx0     None
> vx1
> vx2      2       2
>          1010-1020       1010-1020
>          1030    65556
> 
> vx-longname      2       2
> 
> root@vsid:/src/iproute2# ./bridge/bridge vlan tunnelshow
> port              vlan-id    tunnel-id
> vx2               2          2
>                   1010-1020  1010-1020
>                   1030       65556
> vx-longname       2          2
> root@vsid:/src/iproute2#
> 
> ===
> 
> root@vsid:/src/iproute2# bridge -j -p vlan tunnelshow
> [ {
>         "ifname": "br0",
>         "tunnels": [ ]
>     },{
>         "ifname": "vx1",
>         "tunnels": [ ]
>     },{
>         "ifname": "vx2",
>         "tunnels": [ {
>                 "vlan": 2,
>                 "tunid": 2
>             },{
>                 "vlan": 1010,
>                 "vlanEnd": 1020,
>                 "tunid": 1010,
>                 "tunidEnd": 1020
>             },{
>                 "vlan": 1030,
>                 "tunid": 65556
>             } ]
>     },{
>         "ifname": "vx-longname",
>         "tunnels": [ {
>                 "vlan": 2,
>                 "tunid": 2
>             } ]
>     } ]
> root@vsid:/src/iproute2# ./bridge/bridge -j -p vlan tunnelshow
> [ {
>         "ifname": "vx2",
>         "tunnels": [ {
>                 "vlan": 2,
>                 "tunid": 2
>             },{
>                 "vlan": 1010,
>                 "vlanEnd": 1020,
>                 "tunid": 1010,
>                 "tunidEnd": 1020
>             },{
>                 "vlan": 1030,
>                 "tunid": 65556
>             } ]
>     },{
>         "ifname": "vx-longname",
>         "tunnels": [ {
>                 "vlan": 2,
>                 "tunid": 2
>             } ]
>     } ]
> root@vsid:/src/iproute2#
> 
> Benjamin Poirier (6):
>   bridge: Use consistent column names in vlan output
>   bridge: Fix typo
>   bridge: Fix output with empty vlan lists
>   json_print: Return number of characters printed
>   bridge: Align output columns
>   Replace open-coded instances of print_nl()
> 
>  bridge/vlan.c                            | 111 +++++++++++++++--------
>  include/json_print.h                     |  24 +++--
>  lib/json_print.c                         |  95 +++++++++++--------
>  tc/m_action.c                            |  14 +--
>  tc/m_connmark.c                          |   4 +-
>  tc/m_ctinfo.c                            |   4 +-
>  tc/m_ife.c                               |   4 +-
>  tc/m_mpls.c                              |   2 +-
>  tc/m_nat.c                               |   4 +-
>  tc/m_sample.c                            |   4 +-
>  tc/m_skbedit.c                           |   4 +-
>  tc/m_tunnel_key.c                        |  16 ++--
>  tc/q_taprio.c                            |   8 +-
>  tc/tc_util.c                             |   4 +-
>  testsuite/tests/bridge/vlan/show.t       |  30 ++++++
>  testsuite/tests/bridge/vlan/tunnelshow.t |   2 +-
>  16 files changed, 210 insertions(+), 120 deletions(-)
>  create mode 100755 testsuite/tests/bridge/vlan/show.t
> 

Looks good, applied.
