Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6240014A59A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgA0OAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:00:42 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:44067 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgA0OAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:00:40 -0500
Received: by mail-pg1-f176.google.com with SMTP id x7so5190863pgl.11
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 06:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=L7Swk08fDn0q02CuFDvWGnowF6kp/zWJM+jTeXKEQiI=;
        b=zs4EC9COzjnVg+/OOtvpnyHxs4mihszy8jyg9Q7yNLaNNZjA3x0sRz+cFD73bs0ali
         WYWj5XrWaQB2IrHiZF+9uaYC4m/h/JCTV511eSRFb97Sm5V4Xk1rir5SN9z+votqv4q5
         LiamPJQvH4bQ1pdIYDmlOSIcfN57XM9FFNYBCkTz7YBS9qJ30Zk62CvBNui1DKR5bvKe
         NlgrkzGH8gYs5rhoa2aOuqTcl34iM87q5HZINlLgKplgKuF0bi8XXv3PCdSXiw9jD5zl
         J0yA6BbllWLvCXntnEsRsSvJeabFVSO/eetsfmXmmPouyxk6fc2Nznsoeac9HzHo9AYq
         VLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=L7Swk08fDn0q02CuFDvWGnowF6kp/zWJM+jTeXKEQiI=;
        b=LEGGBQ3ebhn7NLSmXyc/RNxH7hUq+MU0o58fTcpmaEbRdNVw8zukmMV6Ju++Z6h3sE
         tICi9bfekyDebgh936HO16cKBPP0qXMc7mkp1ywY8Zn3xllzeWwQSmkKbBQnk3mBbqH7
         0tFydx8oymgpkSbgh1nmKDW7CHFdG4YJnWBpS6CFGEKKvu5E4ICOb6CVI9y/GMwtFEvc
         4rqWezco7g0qzzgn92LQ/WQwHdUKoaem7dF/XiGgszWMyLsiuK6Pgw9G8iOLUFZf9CRE
         Iwe5s09qaZGdha4+h46BikALnSQSWWl8nXH9+QJpo2jBBYXs6oKnNqv2PnhZ2H0EPjq9
         J51g==
X-Gm-Message-State: APjAAAUvJ/yk28d9fHEmZh1qduDNabwwzpQEuwIT1MJnpLKMVCR/isVN
        pUVlvAey3etcqTHqPqTI75b9sMy7I50=
X-Google-Smtp-Source: APXvYqzeiF0HhQ3LAzj7j95yOsA/7t58ZPXhUMYNnniaQZv0N6TBnGZg9Or+zPWKu2Au/wlcfviE3A==
X-Received: by 2002:a65:4b89:: with SMTP id t9mr5485900pgq.102.1580133638677;
        Mon, 27 Jan 2020 06:00:38 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v4sm15949428pff.174.2020.01.27.06.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 06:00:38 -0800 (PST)
Date:   Mon, 27 Jan 2020 06:00:30 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.5 release
Message-ID: <20200127060030.292e7626@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 5.5 kernel has been released, and the last patches have
been applied to iproute2. Most of the fixes have been related
to single (and json) formatting. Thank you to Aya, Jakub, Jiri, and Ron
for the work to get devlink improved.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.5.0.tar.gz

Repository for upcoming release:
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

---
Antony Antony (1):
      ip: xfrm if_id -ve value is error

Aya Levin (3):
      devlink: Print health reporter's dump time-stamp in a helper function
      devlink: Add a new time-stamp format for health reporter's dump
      devlink: Fix fmsg nesting in non JSON output

Benjamin Poirier (8):
      json_print: Remove declaration without implementation
      testsuite: Fix line count test
      bridge: Fix typo in error messages
      bridge: Fix src_vni argument in man page
      bridge: Fix BRIDGE_VLAN_TUNNEL attribute sizes
      bridge: Fix vni printing
      bridge: Deduplicate vlan show functions
      bridge: Fix tunnelshow json output

Bjarni Ingi Gislason (1):
      man: Fix unequal number of .RS and .RE macros

Brian Vazquez (3):
      tc: fix warning in tc/m_ct.c
      tc: fix warning in tc/q_pie.c
      ss: fix end-of-line printing in misc/ss.c

Danit Goldberg (1):
      ip link: Add support to get SR-IOV VF node GUID and port GUID

David Ahern (5):
      ip vrf: Add json support for show command
      Update kernel headers
      Update kernel headers and import tls.h
      Update kernel headers
      Update kernel headers

Davide Caratti (1):
      ss: allow dumping kTLS info

Eli Britstein (3):
      tc: flower: add u16 big endian parse option
      tc_util: add functions for big endian masked numbers
      tc: flower: support masked port destination and source match

Erez Alfasi (2):
      rdma: Add "stat show mr" support
      rdma: Document MR statistics

Eric Dumazet (1):
      tc_util: support TCA_STATS_PKT64 attribute

Ethan Sommer (1):
      make yacc usage POSIX compatible

Gautam Ramakrishnan (1):
      tc: pie: add dq_rate_estimator option

Guillaume Nault (5):
      ipnetns: treat NETNSA_NSID and NETNSA_CURRENT_NSID as signed
      ipnetns: fix misleading comment about 'ip monitor nsid'
      ipnetns: harden helper functions wrt. negative netns ids
      ipnetns: don't print unassigned nsid in json export
      ipnetns: remove blank lines printed by invarg() messages

Ido Kalir (1):
      rdma: Rewrite custom JSON and prints logic to use common API

Jakub Kicinski (4):
      devlink: fix referencing namespace by PID
      devlink: catch missing strings in dl_args_required
      devlink: allow full range of resource sizes
      devlink: fix requiring either handle

Jan Engelhardt (1):
      build: fix build failure with -fno-common

Jiri Pirko (5):
      devlink: introduce cmdline option to switch to a different namespace
      devlink: extend reload command to add support for network namespace change
      lib/ll_map: cache alternative names
      ip: add support for alternative name addition/deletion/list
      ip: allow to use alternative names as handle

Julien Fortin (1):
      ip: fix ip route show json output for multipath nexthops

Leon Romanovsky (1):
      rdma: Relax requirement to have PID for HW objects

Leslie Monis (10):
      tc: cbs: add support for JSON output
      tc: choke: add support for JSON output
      tc: codel: add support for JSON output
      tc: fq: add support for JSON output
      tc: hhf: add support for JSON output
      tc: pie: add support for JSON output
      tc: sfb: add support for JSON output
      tc: sfq: add support for JSON output
      tc: tbf: add support for JSON output
      tc: fq_codel: fix missing statistic in JSON output

Moshe Shemesh (1):
      ip: fix oneline output

Roi Dayan (1):
      tc: flower: fix print with oneline option

Ron Diskin (6):
      json_print: Introduce print_#type_name_value
      json_print: Add new json object function not as array item
      devlink: Replace json prints by common library functions
      devlink: Replace pr_out_str wrapper function with common function
      devlink: Replace pr_#type_value wrapper functions with common functions
      devlink: Replace pr_out_bool/uint() wrappers with common print functions

Roopa Prabhu (2):
      bridge: fdb get support
      ipneigh: neigh get support

Stephen Hemminger (7):
      uapi: update to magic.h
      tc_util: break long lines
      utils: fix indentation
      tc: prio: fix space in JSON tag
      tc: skbprio: add support for JSON output
      ip: use print_nl() to handle one line mode
      v5.5.0

Tuong Lien (2):
      tipc: add new commands to set TIPC AEAD key
      tipc: fix clang warning in tipc/node.c

Vlad Buslov (1):
      tc: implement support for action flags

Vladis Dronov (1):
      ip: fix link type and vlan oneline output

