Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC866F0901
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 18:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243499AbjD0QDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 12:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243659AbjD0QDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 12:03:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7740D468F
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:03:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a920d4842bso64470315ad.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682611390; x=1685203390;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b+iJuxsGHp+Ca5nZ5lxj+yHS3NjcJpjqzjqK9quJ2Dw=;
        b=M7M2tiU6d+K185001l9IW9XT6xLrUOeowA2jQfFIWd1DwGfOeP10EuZzUbRqEbjjq5
         2ZEq9mtDbGjSb7d1xbQqqIWpFML8IFo3pU99RbesIAbMzbrFdp9eTrV5NqiEYNMXC4fw
         m7QGbNL2oyuJ1SEA7WgiskZVFRMdQ1lIN1whfSo9nIvmj4+Ux8DLDbBPRv7tk2z8Gf2p
         ZNYj2TuC0f/mTeYwDDadZ5M2wi/UfJ/f3Q2eEtNeJss6Cn3Fz9dP6Fere2Yz97FyBQtm
         kvEZSSyzNratUh6TAi+Y6zEmDORLgbeRsdo6WI2wM+5oRuladbFMk+Bu4LMiTu9/+Qn0
         IkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682611390; x=1685203390;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+iJuxsGHp+Ca5nZ5lxj+yHS3NjcJpjqzjqK9quJ2Dw=;
        b=HHyBkzF23o5pf2bEQyArG8c6zudn+/Q97W0oJkwaAaWbUWYSKKvKr9y1p0bpgMzW/C
         gImrNSums5yM4MAoyg00ky/jieJv6dceDRrhv5S7WOy6G/msq9YV+tueg1YZ/g0FeJcN
         gxKB7ltvWa4BmeWMlxi5Au4eqelCtZfp/Jc91W7bdes7uFL+OmUz9MMrpMoqPz9JyUEj
         1xvEI49TZauZOY6jzEGiOSPtRR1TWRUJHEd2XgWpaSQZat1jzIsuZXsKn2j7DGCGwCKN
         3dxWy+PqPLgjmZVoZojpWvj0EVG48Pfhjv29tO6jF/KIClLcQw89bL/3DGaheusIVPi/
         G3zA==
X-Gm-Message-State: AC+VfDzgiVeP6hs8WSuGxSsEWu4A1iRQ4bsPy62v9m1mwjdjABtDTV91
        MjhDJWbxAvyIevOwnc3WKQaUVyWGyp4zzvCdRXVi5g==
X-Google-Smtp-Source: ACHHUZ6aYtszzPwWyNotSOC+ru0elzMVb41dAYUY8klXwNVRyhU9rBAmR3MImMCSXVrMEpdPTQqdvQ==
X-Received: by 2002:a17:902:c712:b0:1a5:2621:34cd with SMTP id p18-20020a170902c71200b001a5262134cdmr1633329plp.39.1682611389662;
        Thu, 27 Apr 2023 09:03:09 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x14-20020a1709027c0e00b0019a70a85e8fsm11872448pll.220.2023.04.27.09.02.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 09:03:02 -0700 (PDT)
Date:   Thu, 27 Apr 2023 09:02:53 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: [ANNOUNCE] iproute2 6.3 release
Message-ID: <20230427090253.7a92616b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New release of iproute2 corresponding to the 6.3 kernel.
No large feature improvements only incremental improvements to
the bridge mdb support, mostly just bug fixes.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.3.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Christian Hesse (1):
      tc: add missing separator

David Ahern (2):
      Update kernel headers
      Update kernel headers

Hangbin Liu (6):
      Revert "tc/tc_monitor: print netlink extack message"
      tc: add new attr TCA_EXT_WARN_MSG
      u32: fix TC_U32_TERMINAL printing
      tc: f_u32: fix json object leak
      Revert "tc: m_action: fix parsing of TCA_EXT_WARN_MSG"
      tc: m_action: fix parsing of TCA_EXT_WARN_MSG by using different enum

Ido Schimmel (8):
      bridge: mdb: Use a boolean to indicate nest is required
      bridge: mdb: Split source parsing to a separate function
      bridge: mdb: Add filter mode support
      bridge: mdb: Add source list support
      bridge: mdb: Add routing protocol support
      bridge: mdb: Add replace support
      ip: bridge_slave: Fix help message indentation
      devlink: Fix dumps where interface map is used

Jakub Kicinski (1):
      genl: print caps for all families

Nicolas Dichtel (2):
      iplink: use the same token NETNSNAME everywhere
      iplink: fix help of 'netns' arg

Paolo Lungaroni (1):
      seg6: man: ip-link.8: add SRv6 End PSP flavor description

Pedro Tammela (4):
      tc: m_action: fix parsing of TCA_EXT_WARN_MSG
      tc: m_csum: parse index argument correctly
      tc: m_mpls: parse index argument correctly
      tc: m_nat: parse index argument correctly

Petr Machata (2):
      bridge: Add support for mcast_n_groups, mcast_max_groups
      man: man8: bridge: Describe mcast_max_groups

P=C3=A9ter Antal (1):
      man: tc-mqprio: extend prio-tc-queue mapping with examples

Sabrina Dubroca (1):
      ip-xfrm: accept "allow" as action in ip xfrm policy setdefault

Stephen Hemminger (11):
      uapi: update bpf.h from upstream
      man/netem: rework man page
      uapi: update license of fou.h
      uapi: update headers from 6.3-rc2
      iptunnel: detect protocol mismatch on tunnel change
      iproute_tunnel: use uint16 for tunnel encap type
      iproute_lwtunnel: fix JSON output
      lwtunnel: fix warning from strncpy
      lwtunnel: use sizeof() on segbuf
      whitespace cleanup
      v6.3.0

Vladimir Oltean (6):
      tc/taprio: add max-sdu to the man page SYNOPSIS section
      tc/taprio: add a size table to the examples from the man page
      tc/mqprio: fix stray ] in man page synopsis
      tc/mqprio: use words in man page to express min_rate/max_rate depende=
ncy on bw_rlimit
      tc/mqprio: break up synopsis into multiple lines
      tc/taprio: break up help text into multiple lines

Xin Long (2):
      iplink: add gso and gro max_size attributes for ipv4
      tc: m_ct: add support for helper

