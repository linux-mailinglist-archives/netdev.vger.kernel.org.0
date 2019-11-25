Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0411091B4
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 17:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfKYQRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 11:17:48 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:35184 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbfKYQRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 11:17:47 -0500
Received: by mail-pl1-f169.google.com with SMTP id s10so6716882plp.2
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 08:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=hsvydpQdD69LndXzjXcZyETic3mA+X3bOyMHEjBDxo8=;
        b=t49B+rqAAHN83Al01YnaDrZjj4NvXDQzbrzrh9kgX0tkiad1r/Yb+uYiRkcpSoJG2K
         Jiu1HwKb+hO2OMHOblLtA+IgYKLJxa6YQBNQfOczgRSdQNcGQo9ODm8kFtdl23Y3VMdB
         wLkMyUsWLwkLC7YwZskZrVuENIKFdoXJhH3fKRR7svPX/LARAnfAc2w7X/UQwnL9pY1x
         3LcwzNRfRkUDklmVQFBjc+KfLbFUGU+Q63ACHWhT1oXHtY1kCtBeWEBTPY+T+DZgcAnO
         7qbHgJC4m3r6JWJFj8QWNiLOboWqZwswYTUImqWnSs0N4pc/aB0+oFdXQvFh4Cs/HPlj
         tndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=hsvydpQdD69LndXzjXcZyETic3mA+X3bOyMHEjBDxo8=;
        b=L/dMWgit2VO+XP0aW3ih4lEHM1k4+z8Kv6NIJ6yX3YlxSPDBoU/PiOsd5S9cqwZH8E
         KtgC7w3N7aLT0iVUtjTrU2J9YarTBczO7AUFZOjO6MkRMdwxrtfyG05CjrgH6b0QigVA
         vakS+BpxdQvbgGyoNmOdFYf+PuI2+z6ydZz/aJJGLZD/kb+W9MI/uxMrYLFqxAvucniI
         ZYUm91AmUlMoT/Oof1QPuvbIQycQKUJ6LE6HkeC8f0NOM+oiqVqzQqhQlyWF+770s6Hv
         5k+DqrzGrm/jXOVWUxGJriLvh30CKuO2zKc078xNF5hE+dHOSIzwguwIM6V5sQIjXqdB
         in6g==
X-Gm-Message-State: APjAAAWpjuMCMspgOLAqlOqlksZX4YLNUwObd2cfl/diNAYdj6j7wR5n
        MtKKHn4wjbq/BQSBypOWO+iHAIMCk0obKA==
X-Google-Smtp-Source: APXvYqzaZF/u9v5YvRA8lexcbeoB1WlGLk0FC8JL68KCGL4FYtFiine1ss9b6upBJs5RojrEOlzGVA==
X-Received: by 2002:a17:90a:f982:: with SMTP id cq2mr39790269pjb.34.1574698665819;
        Mon, 25 Nov 2019 08:17:45 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b18sm9050112pgh.60.2019.11.25.08.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 08:17:45 -0800 (PST)
Date:   Mon, 25 Nov 2019 08:17:37 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.4
Message-ID: <20191125081737.2ff4a7ca@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 5.4 kernel has been released, and the last patches have
been applied to iproute2.

Not a lot of changes in this release, most are related to fixing output
formatting and documentation.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.4.0.tar.=
gz

Repository for upcoming release:
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing lis=
t.

---
Andrea Claudi (4):
      tunnel: factorize printout of GRE key and flags
      ip tunnel: add json output
      bpf: replace snprintf with asprintf when dealing with long buffers
      tc: fix segmentation fault on gact action

Aya Levin (3):
      devlink: Add helper for left justification print
      devlink: Left justification on FMSG output
      devlink: Fix inconsistency between command input and output

Damien Robert (1):
      man: add reference to `ip route add encap ... src`

David Ahern (3):
      Import tc_act/tc_ct.h uapi file
      Update kernel headers
      Update kernel headers

David Dai (1):
      iproute2-next: police: support 64bit rate and peakrate in tc utility

Dirk van der Merwe (2):
      devlink: add 'reset_dev_on_drv_probe' devlink param
      devlink: unknown 'fw_load_policy' string validation

Donald Sharp (1):
      ip nexthop: Allow flush|list operations to specify a specific protocol

Eli Britstein (5):
      tc_util: introduce a function to print JSON/non-JSON masked numbers
      tc_util: add an option to print masked numbers with/without a newline
      tc: flower: fix newline prints for ct-mark and ct-zone
      tc_util: fix JSON prints for ct-mark and ct-zone
      tc: flower: fix output for ip tos and ttl

Florent Fourcot (1):
      man: remove "defaut group" sentence on ip link

Gal Pressman (1):
      rdma: Add driver QP type string

Guillaume Nault (1):
      man: remove ppp from list of devices not allowed to change netns

Hritik Vijay (1):
      ss: show header for --processes/-p

Ido Schimmel (4):
      devlink: Increase number of supported options
      devlink: Add devlink trap set and show commands
      devlink: Add devlink trap group set and show commands
      devlink: Add man page for devlink-trap

Jakub Kicinski (1):
      devlink: require resource parameters

Jiri Pirko (3):
      devlink: implement flash update status monitoring
      devlink: implement flash status monitoring
      devlink: add reload failed indication

Julien Fortin (1):
      ip: fix ip route show json output for multipath nexthops

Micha=C5=82 =C5=81yszczek (3):
      ipnetns: do not check netns NAME when -all is specified
      rdma/sys.c: fix possible out-of-bound array access
      libnetlink.c, ss.c: properly handle fread() errors

Nicolas Dichtel (3):
      ipnetns: enable to dump nsid conversion table
      ip-netns.8: document the 'auto' keyword of 'ip netns set'
      ip-netns.8: document target-nsid and nsid options of list-id

Paul Blakey (3):
      tc: add NLA_F_NESTED flag to all actions options nested block
      tc: Introduce tc ct action
      tc: flower: Add matching on conntrack info

Roman Mashak (2):
      man: tc-ematch.8: update list of filter using extended matches
      man: tc-ematch.8: documented canid() ematch rule

Stephen Hemminger (12):
      uapi: update headers from 5.4-rc
      uapi: update btf from 5.4-rc1
      examples: remove out of date cbq stuff
      examples: remove gaiconf
      examples: remove diffserv
      remove out of date README
      don't install examples
      uapi: SPDX license updates
      uapi: devlink.h health timestamp
      remove no longer useful README for lnstat
      netem: remove redundant README
      v5.4.0

Thomas Haller (1):
      man: add note to ip-macsec manual about necessary key management

Vedang Patel (4):
      etf: Add skip_sock_check
      taprio: add support for setting txtime_delay.
      tc: etf: Add documentation for skip_sock_check.
      tc: taprio: Update documentation

Vinicius Costa Gomes (1):
      taprio: Add support for setting flags

Vlad Buslov (1):
      tc: remove duplicated NEXT_ARG_FWD() in parse_ct()

