Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8419E588215
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 20:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiHBSuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 14:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiHBSuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 14:50:16 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54913DB1
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 11:50:15 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso19343130pjr.2
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 11:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=aac9j45GR9uYAD1SGPgfBYWslDXmHEZ8DMgeT1dj72U=;
        b=E/WmHTST9dqFho7a9hm5NF8dd4RJxy7cuU+v9uQleca9KM34azKlJ7tdsit4xH0RG7
         RqPlMQxu3IpEoHn8rEecaV/ZpLhXK1rMWZEOXI1lPEApJQ9Z6Vx2DFxDxT51OBh291jM
         gj8W6mG7XO+ROT0qodm0atypYijWsppOoL1AIJC46OG3YtRFZBq6TigKddJlBdLdjVsZ
         1PzggMWeQNdS09FYOiPMSLZdbedIUHH3hEQ1UdqPCE/VszU7RZ0mfLWx3QYQcq6hv+eL
         vMy0J3pD/S+EvvXCmayy06Ap1FKL2CL1Y0HCNYQAdpqi45GrfQalcnLMM9r8sd3lyyne
         6qiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=aac9j45GR9uYAD1SGPgfBYWslDXmHEZ8DMgeT1dj72U=;
        b=N+NaAJoBxc4QdHZW40gvW8U1Taaq2K1Un6u9XrAiy9PuLnFLY69jIkydfVrppabmqh
         AFDD3azuPt2Vk+i8cVp9vcbZZKp71PxzOPhkMaKPMPOdQfHbbx5C0ndIaqYTCzqhnVTQ
         695LNjPGko9Fwj31Q7PnwCeBIChGY3nWn8XwOEmWMToQa0UAgMl3YTo5KI8W4XBw2NH2
         qsFkvkDbKYto0sdZYKexToHOFm7vFZueyK4SP764AhRRdF+XaIy9Mz9e6ZgNhngfu9wN
         bJy0ajCv85Uo7IqyXOO3tlzPFOe66OyH6daSRhsQon7IoApiSFgPVM7kQ08QQRaCw6Hp
         XVRQ==
X-Gm-Message-State: ACgBeo3+12g5xy92qN6JixPeSY3YN/qvd38wWVlht8lrxx13R9H7B+1C
        iaF7fO7QqGzTcSGEJUbi1F6wUIYNsrRpVg==
X-Google-Smtp-Source: AA6agR50+x+jIQpYViQyO37tZ3e1vGDwPIFhzOCLjWqId1yEjs7KamDvjKRgn3nH+YNGw1ATDkUIGg==
X-Received: by 2002:a17:90b:4b89:b0:1f5:68b:b14e with SMTP id lr9-20020a17090b4b8900b001f5068bb14emr923360pjb.30.1659466214391;
        Tue, 02 Aug 2022 11:50:14 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id o15-20020a17090a55cf00b001f333fab3d6sm9815232pjm.18.2022.08.02.11.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 11:50:14 -0700 (PDT)
Date:   Tue, 2 Aug 2022 11:50:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.19 release
Message-ID: <20220802115010.22c11d14@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the release of iproute2 corresponding to the 5.19 kernel.
Usual array of small fixes.

There are still some warnings with gcc-12 that are caused by kernel
header issues that need to be fixed upstream. Looks like they may
make it into next release (6.0!).

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.19.0.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Andrea Claudi (2):
      l2tp: fix typo in AF_INET6 checksum JSON print
      man: tc-ct.8: fix example

Baligh Gasmi (1):
      ip/iplink_virt_wifi: add support for virt_wifi

Benjamin Poirier (5):
      ip address: Fix memory leak when specifying device
      bridge: Fix memory leak when doing 'fdb get'
      mptcp: Fix memory leak when doing 'endpoint show'
      mptcp: Fix memory leak when getting limits
      ip neigh: Fix memory leak when doing 'get'

Boris Sukholitko (3):
      f_flower: Add num of vlans parameter
      f_flower: Check args with num_of_vlans
      f_flower: add number of vlans man entry

David Ahern (5):
      Update kernel headers
      libbpf: Use bpf_object__load instead of bpf_object__load_xattr
      libbpf: Remove use of bpf_program__set_priv and bpf_program__priv
      libbpf: Remove use of bpf_map_is_offload_neutral
      Update kernel headers

Jiri Pirko (1):
      devlink: introduce -[he]x cmdline option to allow dumping numbers in hex format

Juhee Kang (1):
      bpf_glue: include errno.h

Nikolay Aleksandrov (1):
      bridge: vni: add support for stats dumping

Petr Machata (25):
      libnetlink: Add filtering to rtnl_statsdump_req_filter()
      ip: Publish functions for stats formatting
      ip: Add a new family of commands, "stats"
      ipstats: Add a "set" command
      ipstats: Add a shell of "show" command
      ipstats: Add a group "link"
      ipstats: Add a group "offload", subgroup "cpu_hit"
      ipstats: Add offload subgroup "hw_stats_info"
      ipstats: Add offload subgroup "l3_stats"
      ipmonitor: Add monitoring support for stats events
      man: Add man pages for the "stats" functions
      ip: ipstats: Do not assume length of response attribute payload
      iplink: Fix formatting of MPLS stats
      iplink: Publish a function to format MPLS stats
      ipstats: Add a group "afstats", subgroup "mpls"
      iplink: Add JSON support to MPLS stats formatter
      ipstats: Add a third level of stats hierarchy, a "suite"
      ipstats: Add groups "xstats", "xstats_slave"
      iplink_bridge: Split bridge_print_stats_attr()
      ipstats: Expose bridge stats in ipstats
      ipstats: Expose bond stats in ipstats
      man: ip-stats.8: Describe groups xstats, xstats_slave and afstats
      ip: Convert non-constant initializers to macros
      ip: Fix size_columns() for very large values
      ip: Fix size_columns() invocation that passes a 32-bit quantity

Roopa Prabhu (2):
      bridge: vxlan device vnifilter support
      ip: iplink_vxlan: add support to set vnifiltering flag on vxlan device

Stephen Hemminger (13):
      ip-link: put types on man page in alphabetic order
      uapi: update socket.h
      uapi: change name for zerocopy sendfile in tls
      genl: fix duplicate include guard
      tc: declaration hides parameter
      uapi: update mptcp.h
      uapi: update bpf.h
      uapi: add vdpa.h
      uapi: add virtio_ring.h
      Revert "uapi: add vdpa.h"
      vdpa: update uapi headers from 5.19-rc7
      rdma: update uapi/ib_user_verbs.h
      v5.19.0

Yuki Inoguchi (2):
      man: tc-fq_codel: Fix a typo.
      man: tc-fq_codel: add drop_batch

