Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0B823F00D
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 17:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHGPew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 11:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgHGPev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 11:34:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FE5C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 08:34:51 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d4so1062333pjx.5
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 08:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=eUpvaTqUYrMyWZbq7tEdgtH3MVmHdB0HgoG8WDALDBM=;
        b=SFUMdHPuxJWzqAFnhlqsMHXUfSjOjAs0uo5jOVUMuZ6bOjgcWWObFA+yRtDH2fAMp4
         O63YLoyUtrPBWII4L9a0V+lzqmMN+ID/BxxjTo9HY1tN3s5Gsvc5HI45knDs2SGOiWwK
         b0U3bzMM6e7l0K8zsRcpTKqfu2ckWLunoZ0ArZ8Ex5lgJehpDOhWieCPFr8Gu3csA8pX
         PFxWdkMF8fCvBQqHTTGkKvWgzl5foCpMIy0udSV35C4+KSL/eqHmNH2RBJVNXM3w5L3S
         Zuf4TnzTQ+3I5a17oeTZ1CfBbPEujNN7gR9cSsEjcpH49AWtr3Zwc5ghJ2HqYZhT+vKB
         meoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=eUpvaTqUYrMyWZbq7tEdgtH3MVmHdB0HgoG8WDALDBM=;
        b=GXYlScI+LK6rZsgD5YxZJU9ImCiOFNm+gjvLEHiq1xChInz81mPuP36LtOQNrMheRX
         eMhk8f40LZptLA3qEoUt6tb9182sbiHigNyOWRgBqcC5rJNQ58PlTvx/2uJ06Z1QnBj4
         Mu8eKeMSFlBCJ9om4qgWQ12c1QSB/mPA2V0Wdhnk19z35li/0/OCp+/q3djR+pev4id1
         G7N3lDXXQK8RJqAwPjl05sar9HcitChQXBXGlsHPK8Ny+cjHKfLyH62rYIypljAX8WAf
         y+FvzsjDm4gVHBTYCFu+rl6bnnA8tIRdCDzow61PjhYZvsZkYC0C7swLjwg69xoM7mXM
         HULw==
X-Gm-Message-State: AOAM532+tp7BEc9mlv0aLa7EcKpbPJviYt3xc9yJIyE+QLDm9mme6Sno
        e9HGcgyzHdHsVdjluOAYndTx+ZpS3KI=
X-Google-Smtp-Source: ABdhPJxuhMk1GWnhaUoesqQtXG9y60lpvzi5KSPBrQfMJ/gqRvn0CVhuxPuhzH4uCZGbehdZgeJzhg==
X-Received: by 2002:a17:90a:ff07:: with SMTP id ce7mr14158985pjb.192.1596814488852;
        Fri, 07 Aug 2020 08:34:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m23sm10951416pgv.43.2020.08.07.08.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 08:34:48 -0700 (PDT)
Date:   Fri, 7 Aug 2020 08:34:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org, linux-kernel@vg
Subject: [ANNOUNCE] iproute2 5.8
Message-ID: <20200807083440.55f5deb2@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Time for a new version of iproute2 to go with the 5.8 kernel.
There are couple of administrative changes that long term downloaders
will notice. First it that iproute2 is now maintained on the "main"
branch. There are parallel copies (both updated) on kernel.org
and github.

If you use github, you will get the right default branch;
if you use kernel.org you will get the WRONG default branch.
Kernel.org still does not have an way to change the name of the
default branch. The "master" branch is dead and will be
removed once kernel.org is fixed. If you have an existing
iproute2 git repo either or clone a new copy or
see one of many tutorials on renaming the master branch.

The other change is that the former date based internal
versioning (snapshot) is replaced by the regular version numbering
which corresponds to the kernel version. Iproute2
carries its own sanitized version of the kernel headers so the
current code will build and run on older kernel releases.

It is recommended to always use the latest iproute2.
Do not treat iproute2 like perf and require matching packages.
The latest code will always run on older kernels (and vice versa);
this is possible because of the kernel API/ABI guarantees.
Except for rare cases, iproute2 does not do maintenance releases
and there is no long term stable version.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.8.0.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.


Alexander Aring (1):
      lwtunnel: add support for rpl segment routing

Andrea Claudi (1):
      ip address: remove useless include

Anton Danilov (3):
      tc: improve the qdisc show command
      misc: make the pattern matching case-insensitive
      bridge: fdb: the 'dynamic' option in the show/get commands

Bjarni Ingi Gislason (5):
      libnetlink.3: display section numbers in roman font, not boldface
      man8/bridge.8: fix misuse of two-fonts macros
      devlink.8: Use a single-font macro for a single argument
      devlink-dev.8: use a single-font macro for one argument
      devlint-health.8: use a single-font macro for a single argument

David Ahern (4):
      Update kernel headers and import mptcp.h
      Update kernel headers
      Import rpl.h and rpl_iptunnel.h uapi headers
      Update kernel headers and import tc_gate.h

Davide Caratti (2):
      ss: allow dumping MPTCP subflow information
      tc: full JSON support for 'bpf' filter

Dmitry Yakunin (4):
      ss: introduce cgroup2 cache and helper functions
      ss: add support for cgroup v2 information and filtering
      ss: add checks for bc filter support
      lib: fix checking of returned file handle size for cgroup

Eran Ben Elisha (1):
      devlink: Add devlink health auto_dump command support

Eyal Birger (2):
      ip xfrm: update man page on setting/printing XFRMA_IF_ID in states/policies
      ip xfrm: policy: support policies with IF_ID in get/delete/deleteall

Guillaume Nault (3):
      ip link: initial support for bareudp devices
      tc: flower: support multiple MPLS LSE match
      testsuite: Add tests for bareudp tunnels

Hoang Huu Le (1):
      tipc: fixed a compile warning in tipc/link.c

Ian K. Coolidge (2):
      iproute2: ip addr: Organize flag properties structurally
      iproute2: ip addr: Add support for setting 'optimistic'

Ido Schimmel (3):
      devlink: Add 'control' trap type
      devlink: Add 'mirror' trap action
      devlink: Document zero policer identifier

Jakub Kicinski (1):
      devlink: support kernel-side snapshot id allocation

Jamie Gloudon (1):
      tc/m_estimator: Print proper value for estimator interval in raw.

Julien Fortin (2):
      bridge: fdb get: add missing json init (new_json_obj)
      bridge: fdb show: fix fdb entry state output for json context

Louis Peens (1):
      devlink: add 'disk' to 'fw_load_policy' string validation

Maciej Fijalkowski (1):
      tc: mqprio: reject queues count/offset pair count higher than num_tc

Mark Starovoytov (2):
      macsec: add support for MAC offload
      macsec: add support for specifying offload at link add time

Matthieu Baerts (1):
      mptcp: show all endpoints when no ID is specified

Paolo Abeni (3):
      add support for mptcp netlink interface
      man: mptcp man page
      man: ip.8: add reference to mptcp man-page

Petr Machata (1):
      tc: pedit: Support JSON dumping

Po Liu (2):
      iproute2-next:tc:action: add a gate control action
      iproute2-next: add gate action man page

Roi Dayan (1):
      ip address: Fix loop initial declarations are only allowed in C99

Roman Mashak (1):
      tc: report time an action was first used

Sorah Fukumori (1):
      ip fou: respect preferred_family for IPv6

Stephen Hemminger (11):
      uapi: update headers
      devlink: update include files
      uapi: update to magic.h
      man/tc: remove obsolete reference to ipchains
      uapi: update bpf.h
      iplink_bareudp: use common include syntax
      rtacct: drop unused header
      genl: use <> for system includes
      uapi: update bpf.h
      replace SNAPSHOT with auto-generated version string
      lnstat: use same version as iproute2

Tony Ambardar (1):
      configure: support ipset version 7 with kernel version 5

Tuong Lien (1):
      tipc: enable printing of broadcast rcv link stats

William Tu (1):
      erspan: Add type I version 0 support.

Xin Long (7):
      iproute_lwtunnel: add options support for geneve metadata
      iproute_lwtunnel: add options support for vxlan metadata
      iproute_lwtunnel: add options support for erspan metadata
      tc: m_tunnel_key: add options support for vxlan
      tc: m_tunnel_key: add options support for erpsan
      tc: f_flower: add options support for vxlan
      tc: f_flower: add options support for erspan

