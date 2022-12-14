Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B4664CDF7
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238875AbiLNQ1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbiLNQ1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:27:09 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7EF266E
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:27:08 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id f3so2333260pgc.2
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Abhxxtrazx8t79POlX/XuT1uef+M32bWHgZLumYxB9w=;
        b=XTmle19Atof4rYAU2OKjTMELJOLpx7S7BMTFtf45fvKP1W1Tem3D5KG21YwDilUX9C
         geucGAUbDX/RX/a9kRB/fRD87ihyYBKkwUZguRJnbI7iiSKElrqj9hqI5htX1duwC2BR
         Oof3wTRePEy8S/eZzcr5UGIgLd6n5BXdrOWTEnIxYsB/3loFNIDbbpwoploDqXg1Tjvl
         uiRRO897IIt7m7l/a9rUOd6i+H/w2kV9RLci/vEWxe6N+etRcNwiTifovAyXckv6dtJI
         +O84bngOVHDOZZyl6oDi8Z9hRUqoW4dAUm+WEAOEhgg17DieDmjvYH+jMeZxCuwT8d0E
         aqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Abhxxtrazx8t79POlX/XuT1uef+M32bWHgZLumYxB9w=;
        b=hHgrTp2uAOnVsxxeYDRgc3nFhpmVnNhwZdb024Iv5nlMZ8hE2VXujODjh4tYZf1mbb
         MXkpLJutfDNRUUgUYvqYhd6hZMD7mjY/T24DdW8abZiAWgpz6ZTUVFytLP+dLbp6PhXc
         g4eJ3RzSfwxQxu/Kpp9cFmIJEg96iwpOQQrMjkrpc1+mYcRZoLw7aQ5q7bf4tdXED36K
         Zs7XuBAMwV0LiZ3sMLLFWtelGyvUThQ3F+rFZylcWCb2eqyBcdbNbb7+FVQLdLefMtsB
         3zluBPQEaRqT05hVD62IKsfTsC7xI1aZkE6NhK5P7KWT6wuHPCRG817HHD4FtOfVwqF1
         bN1A==
X-Gm-Message-State: ANoB5pnhXxIIwvouwqQlUGP3zgg3V13gRqd1OE3tSRfnhX2hCkd+tf8C
        vLIE98hY7ld5emH8la0aGQvv/GnZEBem3D1S9g4=
X-Google-Smtp-Source: AA0mqf4+v2YEr+z6WBu8+QDMqUwcOiN70b9owIhqIRP+CVDypoCK7LB01Pogaql83GM8kBBxFYicWw==
X-Received: by 2002:a05:6a00:7ca:b0:577:3944:aa78 with SMTP id n10-20020a056a0007ca00b005773944aa78mr22597795pfu.0.1671035227793;
        Wed, 14 Dec 2022 08:27:07 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id v6-20020aa799c6000000b00574ee8d8779sm92323pfi.65.2022.12.14.08.27.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:27:07 -0800 (PST)
Date:   Wed, 14 Dec 2022 08:27:05 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: [ANNOUNCE] iproute2 6.1 release
Message-ID: <20221214082705.5d2c2e7f@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the release of iproute2 corresponding to the 6.1 kernel.
Nothing major; lots of usual set of small fixes.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.1.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Andrea Claudi (4):
      man: ss.8: fix a typo
      testsuite: fix build failure
      genl: remove unused vars in Makefile
      json: do not escape single quotes

Benjamin Poirier (1):
      ip-monitor: Do not error out when RTNLGRP_STATS is not available

Daniel Xu (1):
      ip-link: man: Document existence of netns argument in add command

David Ahern (4):
      Update kernel headers
      Update kernel headers
      Update kernel headers
      Update kernel headers

Emeel Hakim (2):
      macsec: add Extended Packet Number support
      macsec: add user manual description for extended packet number feature

Eyal Birger (2):
      ip: xfrm: support "external" (`collect_md`) mode in xfrm interfaces
      ip: xfrm: support adding xfrm metadata as lwtunnel info in routes

Hangbin Liu (5):
      ip: add NLM_F_ECHO support
      libnetlink: add offset for nl_dump_ext_ack_done
      tc/tc_monitor: print netlink extack message
      rtnetlink: add new function rtnl_echo_talk()
      ip: fix return value for rtnl_talk failures

Ido Schimmel (1):
      iplink_bridge: Add no_linklocal_learn option support

Jacob Keller (4):
      devlink: use dl_no_arg instead of checking dl_argc == 0
      devlink: remove dl_argv_parse_put
      mnlg: remove unnused mnlg_socket structure
      utils: extract CTRL_ATTR_MAXATTR and save it

Jiri Pirko (6):
      devlink: expose nested devlink for a line card object
      devlink: load port-ifname map on demand
      devlink: fix parallel flash notifications processing
      devlink: move use_iec into struct dl
      devlink: fix typo in variable name in ifname_map_cb()
      devlink: load ifname map on demand from ifname_map_rev_lookup() as well

Junxin Chen (1):
      dcb: unblock mnl_socket_recvfrom if not message received

Lahav Schlesinger (1):
      libnetlink: Fix memory leak in __rtnl_talk_iov()

Lai Peter Jun Ann (2):
      tc_util: Fix no error return when large parent id used
      tc_util: Change datatype for maj to avoid overflow issue

Matthieu Baerts (4):
      ss: man: add missing entries for MPTCP
      ss: man: add missing entries for TIPC
      ss: usage: add missing parameters
      ss: re-add TIPC query support

Michal Wilczynski (1):
      devlink: Fix setting parent for 'rate add'

Nicolas Dichtel (1):
      link: display 'allmulti' counter

Paolo Lungaroni (1):
      seg6: add support for flavors in SRv6 End* behaviors

Roi Dayan (1):
      tc: ct: Fix invalid pointer dereference

Stephen Hemminger (14):
      uapi: update from 6.1 pre rc1
      u32: fix json formatting of flowid
      tc_stab: remove dead code
      uapi: update for in.h and ip.h
      remove #if 0 code
      tc: add json support to size table
      tc: put size table options in json object
      tc/basic: fix json output filter
      iplink: support JSON in MPLS output
      tc: print errors on stderr
      ip: print mpls errors on stderr
      tc: make prefix const
      man: add missing tc class show
      6.1.0

Vincent Mailhol (1):
      iplink_can: add missing `]' of the bitrate, dbitrate and termination arrays

Vladimir Oltean (1):
      ip link: add sub-command to view and change DSA conduit interface

