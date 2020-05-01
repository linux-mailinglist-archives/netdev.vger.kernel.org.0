Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB591C105E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 11:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgEAJcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 05:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728236AbgEAJcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 05:32:08 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F14CC035495
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 02:32:07 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id f18so2072734lja.13
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 02:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l4VUzp5KC03VH6gy0M9XP/QukbREalbR/O4IyAslFpg=;
        b=JKTApq1IUP9/N3bg/cvPJ5Jy5fG2SE+gJlY01zmFFBicEP7D31vUOPKkKLav2sUUwh
         Y850fANFDfJ3z3K9VdG1+dLDPTniHK2eHmEddRPIFG5mfg5HjnhYssZbrTYmz3wpcsTE
         1L4GVqcIii7iEv0Ihr1TY76nTl9YZy5K03rRs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l4VUzp5KC03VH6gy0M9XP/QukbREalbR/O4IyAslFpg=;
        b=I/N18CrSNk2zCSV2Sfz3atffL/EguntCW/BFn0P5KqPruYCMoeUsGN8rFVxLsTwijr
         Od7GHkVF8V1QT8H96Yq7jDYswEYZu+tbzE+YhsRqGtUvDJksHfQsvWkY85Av6riBLrj/
         THrCaQJkm51FLZ0y+Le/kz6GJUR5So4Hnqx2fHr2xnnMSqosSpRLV2UtZWbXg2NXyxaa
         EHCb42LP2ZIcttiejmVO0YvuJkWyUCbiUxBOaL4YIg3/jgzqGxWQwVx1onSoyi2IX8Ur
         OKpzTz56fpPg0lO+HdotXZbxTViQC9KiZY4uQBktVXZ0v+DL2qEeLc/z78C7NJXnQlhO
         s6Ig==
X-Gm-Message-State: AGi0PuYstR2e6UlzD9WbCfOQfHz+hlRUK+nUS20VY11irdJsxDW6arQ8
        birbgZHz/F45Yn+RdUTWZ+yZnQ==
X-Google-Smtp-Source: APiQypL8kD3FB+T6zgjPk6q83TJphW8DgwaJHjVyk5GBM9CoWhl4S4f76ERwiD/otoImwg5QX3mezQ==
X-Received: by 2002:a2e:7e0b:: with SMTP id z11mr1877583ljc.284.1588325525456;
        Fri, 01 May 2020 02:32:05 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y25sm1811450lfy.59.2020.05.01.02.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 02:32:04 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2 0/6] bridge vlan output fixes
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
References: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <903da83e-2c53-c95e-ad9e-c9f8242d4d55@cumulusnetworks.com>
Date:   Fri, 1 May 2020 12:32:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/05/2020 11:47, Benjamin Poirier wrote:
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

Looks good, thanks!
For the whole set:
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
