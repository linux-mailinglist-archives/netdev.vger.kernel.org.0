Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA96719CA0E
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 21:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389297AbgDBTen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 15:34:43 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:34779 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgDBTem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 15:34:42 -0400
Received: by mail-pg1-f171.google.com with SMTP id l14so2326436pgb.1
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 12:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ZcdYcKuBeenscSEmNE8LHxP2C693m2s2u+d9jUGxZ5Y=;
        b=WMzPtSZ2ch0op51Gy8vmR0c73dqEJIzv1TXv9ijmJw4Zq7akibTNyQHyB3I46P6D4R
         hKRrXVY/XU4qcwxAgnfnmPJd8oobSnXRVtcI6piNTUB1pKnicpP3JVLKHUOW8YETf/45
         RAfudto0DU4PjBZtQu6XIarfWKeUZSImdOF6TzjPbxp+YEtQCDl3bvJXEcdaB5IQNO0W
         mPmSn8HodlXgy6n0x104eJf02HqgaNilSILdA0hQX0mJbMWyh3LyeyKxtwpycdVslf4G
         +vRlyO/2AfLjYsU8i0DoYISoLF4T5eshi3C8/bDe3HN6MWCYkYHQC3j5vd8m4eSDO2dr
         E8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ZcdYcKuBeenscSEmNE8LHxP2C693m2s2u+d9jUGxZ5Y=;
        b=bPXcqpL1snXsQ74+kwE+w4wj+qSdw5QmbgwWkIj7gqyXgWT4w6BcUqBeGU0T5iddoY
         L7U6r9FC132QBr3TTzSFI/ppbShkiE1389zEuFA4+SgXgAR6gDejfeRHW916/SqJD6Ph
         DlJRGDnDibyLGLiorxfUlSn6NrAcu1hlMsmIaD9rjPzZeJNRZ3U1H5kPw6/n33YWrCwb
         fWKovJfmGHhlwK0BXrC9Fp0kNzNjUcdl3Cndpi6686Wt5KykdAOroSEEq9O/hSqh0hNY
         Gn19y3OduysUJnflwQa7m/aIT1/mlUQgOpUlhQORFchiYirm73xp7+3X5bZ+xWyY2LXF
         DGxg==
X-Gm-Message-State: AGi0PubIyQBlD+JJtaiV/PUrxNlumYgkFV6WWxX+sIDIWg1FNVkthR53
        Mwjfcyf6UJoo+LPOK7T/NraZ5McaprMXpQ==
X-Google-Smtp-Source: APiQypKBX6jpEatEyEe7YjbmWdXn3uQgM+LgAIf+ezRwA+epO6mymt1URsS7pLB29l+W8jwFIhmepA==
X-Received: by 2002:aa7:8bdc:: with SMTP id s28mr4975179pfd.110.1585856080712;
        Thu, 02 Apr 2020 12:34:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q8sm4297450pfg.19.2020.04.02.12.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:34:40 -0700 (PDT)
Date:   Thu, 2 Apr 2020 12:34:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kerne@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.6
Message-ID: <20200402123432.4cbdaa59@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 5.6 kernel has been released, and the last patches have
been applied to iproute2.

Not a lot of changes in this release, most are related to fixing output
formatting and documentation.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.6.0.tar.gz

Repository for upcoming release:
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

---

Andrea Claudi (8):
      ip-xfrm: Fix help messages
      ip link: xstats: fix TX IGMP reports string
      nstat: print useful error messages in abort() cases
      man: ip.8: Add missing vrf subcommand description
      man: rdma.8: Add missing resource subcommand description
      man: rdma-statistic: Add filter description
      nexthop: fix error reporting in filter dump
      man: bridge.8: fix bridge link show description

Andy Roulin (1):
      iplink: bond: print lacp actor/partner oper states as strings

David Ahern (4):
      Update kernel headers
      Update kernel headers
      Update kernel headers
      Update kernel headers and import udp.h

Donald Sharp (1):
      ip route: Do not imply pref and ttl-propagate are per nexthop

Guillaume Nault (1):
      iproute2: fix MPLS label parsing

Ido Schimmel (1):
      ip route: Print "rt_offload" and "rt_trap" indication

Leslie Monis (1):
      tc: parse attributes with NLA_F_NESTED flag

Michal Kubecek (1):
      ip link: show permanent hardware address

Mohit P. Tahiliani (1):
      tc: add support for FQ-PIE packet scheduler

Paolo Lungaroni (1):
      add support for table name in SRv6 End.DT* behaviors

Peter Junos (2):
      ss: use compact output for undetected screen width
      ss: fix tests to reflect compact output

Petr Machata (2):
      libnetlink: parse_rtattr_nested should allow NLA_F_NESTED flag
      tc: Add support for ETS Qdisc

Sabrina Dubroca (1):
      ip: xfrm: add espintcp encapsulation

Stephen Hemminger (9):
      tc: do not output newline in oneline mode
      uapi: update bpf.h and btf.h
      uapi/pkt_sched: upstream changes from fq_pie
      uapi: updates to tcp.h, snmp.h and if_bridge.h
      devlink: fix warning from unchecked write
      uapi: update magic.h
      uapi: update bpf.h
      uapi: update linux/in.h
      v5.6.0

Vivien Didelot (1):
      iplink: add support for STP xstats

Xin Long (2):
      erspan: set erspan_ver to 1 by default
      xfrm: not try to delete ipcomp states when using deleteall

