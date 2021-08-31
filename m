Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7813FCD6E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 21:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhHaTF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 15:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239827AbhHaTFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 15:05:51 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E59FC061760
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:04:56 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x4so199869pgh.1
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=6YJBR9vYLhAu14mKGfz0PBgwyR5YLsGa/4dlPURQSIM=;
        b=1adpaxsa8GtEIeBSvyd/je9Qejeo4SzykQMDFh7ceuQwY8HiFhw7Rvc9Lslb4u1k7S
         patogBvUwv5V0U3Y+KHnuFLvud75z4jND1KIs11dETgGj/BTYz+K+Kp4y/iV75zKpRQD
         TEAaSQ3JX0J1oBtgi7zhC0OFFKbnlFG7/QftpHAkjJrdl8reeE+VVKPOVmGhewUOv+Dn
         Uo4kiAoT5IKQ0ejx8n0ucf/M/HkppJUZqBOJ8SqxgPjXphHSVZw+kNgt2CL1O89xl7+q
         4q2lN7ivKMnPh+1R+gQbhpBjGTd5kjjk9qIkPDvJ8j9ff83xaYscK9CLBtLDeZf2m8QT
         eLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=6YJBR9vYLhAu14mKGfz0PBgwyR5YLsGa/4dlPURQSIM=;
        b=cL50Wy13JdXG+zFfEujJxReKPSl29IcSStTF42jMFjSDZM1qm9pGJigrg8vu/zAKC6
         9H2JjMeaWk0YceeoIKMMwSxfxO8hSZ397nRTCTZavTZTeQUgihDoXa4wVqJQ8GTYy4pI
         vM86cANEW4wA53GfiaBGwI4mX8lLqPlD7j+vXLHKUxRvVtMdBd5Cthtk/hChHf1B6JyY
         0KPdR7y8kOiLOKffgjQQ9WJBp0uwu9uViWDLswvMjvwjAYEiOLqSzr4Q0w7haSRukWu8
         upDk0qDO9IMLXWsA1HHEWLGKkylpTw7Guf6rr41Orts3nGpYcsP1VAYyTG4ZnO1ZL2kP
         QstQ==
X-Gm-Message-State: AOAM533S/o8jOPoKsVTu9XVAIoITxnmTbyu66iapBtcsk7haUdFQLXvR
        KJkfDsa1iWjymHZXeRwmKrAKUadI6R7iGA==
X-Google-Smtp-Source: ABdhPJwx92JM1HGxNJmjO2brSpaA61eqAQJo+cQGvuI9Wo+II8F0jRAEAVx4Soz7cZAQH0aeqtzcNg==
X-Received: by 2002:a63:551a:: with SMTP id j26mr27693742pgb.142.1630436695338;
        Tue, 31 Aug 2021 12:04:55 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id q22sm1238053pgn.67.2021.08.31.12.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 12:04:55 -0700 (PDT)
Date:   Tue, 31 Aug 2021 12:04:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.14.0 release
Message-ID: <20210831120452.71325cd8@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

End of summer sale, get your new iproute2 just in time for fall!
This is a relatively low volume release (maybe because of summer doldrums).

As always, it is recommended to always use the latest iproute2.
Do not treat iproute2 like perf and require matching packages.
The latest code will always run on older kernels (and vice versa);
this is possible because of the kernel API/ABI guarantees.
Except for rare cases, iproute2 does not do maintenance releases
and there is no long term stable version.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.14.0.tar=
.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Alexander Mikhalitsyn (2):
      ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped
      libnetlink: check error handler is present before a call

Andrea Claudi (9):
      tc: q_ets: drop dead code from argument parsing
      lib: bpf_legacy: avoid to pass invalid argument to close()
      dcb: fix return value on dcb_cmd_app_show
      dcb: fix memory leak
      tipc: bail out if algname is abnormally long
      tipc: bail out if key is abnormally long
      tc: htb: improve burst error messages
      lib: bpf_legacy: fix potential NULL-pointer dereference
      lib: bpf_glue: remove useless assignment

Ariel Levkovich (2):
      tc: f_flower: Add option to match on related ct state
      tc: f_flower: Add missing ct_state flags to usage description

Asbj=C3=B8rn Sloth T=C3=B8nnesen (2):
      tc: pedit: parse_cmd: add flags argument
      tc: pedit: add decrement operation

Christian Sch=C3=BCrmann (1):
      man8/ip-tunnel.8: fix typo, 'encaplim' is not a valid option

David Ahern (6):
      Update kernel headers
      Update kernel headers
      config.mk: Rerun configure when it is newer than config.mk
      Update kernel headers
      Update kernel headers
      Import wwan.h uapi file

Dmytro Linkin (3):
      devlink: Add helper function to validate object handler
      devlink: Add port func rate support
      devlink: Add ISO/IEC switch

Eric Dumazet (1):
      tc: fq: add horizon attributes

Feng Zhou (1):
      lib/bpf: Fix btf_load error lead to enable debug log

Gal Pressman (2):
      rdma: update uapi headers
      rdma: Add copy-on-fork to get sys command

Gokul Sivakumar (3):
      bridge: reorder cmd line arg parsing to let "-c" detected as "color" =
option
      bridge: fdb: don't colorize the "dev" & "dst" keywords in "bridge -c =
fdb"
      man: bridge: fix the typo to change "-c[lor]" into "-c[olor]" in man =
page

Guillaume Nault (1):
      utils: bump max args number to 512 for batch files

Hangbin Liu (3):
      configure: add options ability
      configure: convert LIBBPF environment variables to command-line optio=
ns
      ip/bond: add arp_validate filter support

Heiko Thiery (1):
      lib/fs: fix issue when {name,open}_to_handle_at() is not implemented

Hoang Le (1):
      tipc: call a sub-routine in separate socket

Jacob Keller (1):
      devlink: fix infinite loop on flash update for drivers without status

Jakub Kicinski (3):
      ip: align the name of the 'nohandler' stat
      ip: dynamically size columns when printing stats
      ss: fix fallback to procfs for raw sockets

Jethro Beekman (1):
      ip: Add nodst option to macvlan type source

Jianguo Wu (1):
      mptcp: make sure flag signal is set when add addr with port

Lahav Schlesinger (1):
      ipmonitor: Fix recvmsg with ancillary data

Martynas Pumputis (1):
      libbpf: fix attach of prog with multiple sections

Neta Ostrovsky (3):
      rdma: Update uapi headers
      rdma: Add context resource tracking information
      rdma: Add SRQ resource tracking information

Paolo Lungaroni (2):
      seg6: add counters support for SRv6 Behaviors
      seg6: add support for SRv6 End.DT46 Behavior

Parav Pandit (2):
      devlink: Add optional controller user input
      devlink: Show port state values in man page and in the help command

Peilin Ye (1):
      tc/skbmod: Remove misinformation about the swap action

Phil Sutter (1):
      tc: u32: Fix key folding in sample option

Roi Dayan (2):
      police: Add support for json output
      police: Fix normal output back to what it was

Sergey Ryazanov (2):
      iplink: add support for parent device
      iplink: support for WWAN devices

Stephen Hemminger (6):
      lib: remove blank line at eof
      uapi: update kernel headers from 5.14-rc1
      libnetlink: cosmetic changes
      uapi: headers update
      uapi: update neighbour.h
      v5.14.0

Tyson Moore (1):
      tc-cake: update docs to include LE diffserv

