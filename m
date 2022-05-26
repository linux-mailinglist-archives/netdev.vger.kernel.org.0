Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C920535678
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 01:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348657AbiEZXuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 19:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239878AbiEZXuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 19:50:09 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A0A9C2FA
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 16:50:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n18so2756316plg.5
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 16:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=UUylbFb1KzSKx6V2LN4l33pzMzUYLvtXg0/NJazfV4M=;
        b=Ivrdkxgv1uzZ3QdBcvQXPNdNMNVnU0garR3DHQ8X5F+pg/Liu2rDEiPA0/oL8knS7s
         w7brWWDPdeka1tgGnlmTBDd0XSSiFenxUBuG6DkbtrT3AohdlU78jNMRDfAkfdAzanSX
         mASFFsSfwPeAQQGNOQrdWUME+FkHwfZ5wwT5OgCBPcA5V03nE0P3Qtkus8VJugecvo8z
         KBpEVKifjiOzlKP4FMg/w85gXV577glZfhdKxKFQmHNDAe+jXr78579nICPPi6vUrLo9
         MskwSfF8vln0UtNcuPOYNxBOOt6SO5jNaqvj+vxyz/iVFhH1BWe0pKV02REPj1vYytg8
         sY1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=UUylbFb1KzSKx6V2LN4l33pzMzUYLvtXg0/NJazfV4M=;
        b=y7f6eeaDZ+aLmRlL/fkCT/DaT58+nfyMEd9/ls0rs5Zyby5x6hVVlZgSaQFJ+/PEeT
         6KbfMYytOedd6Ty7fIrcsUZstfykehklqG9EBhSnGI4YVeyAPyndbZzX1FJco9KK+W/2
         WteVqr2N2hoT7PRJwErfyEcpDIPGUmW/fpZte5snAXKiSan03JlNvnR2fbcu5eUhF0ss
         2PjH6jF5Cza0QDSH9czuaMZP+JPUEt9eozJ7eURDLvPlPlbWLoKpsxxjMeQs0JP99sX1
         Wb+cbZWjUXXc4117YCgNLdS6XUciH93aOeSUaxReGASIAJwtXTQuMwQPXnyEDTYs0H64
         YHKg==
X-Gm-Message-State: AOAM533DXX8Sz8b8e2a1tFNqE65P/xAYcFEZmK7VrMhXg63u8MRkRMmP
        WAt03qP4RYT17CdXChiFpZDrHymjpLoTww==
X-Google-Smtp-Source: ABdhPJwggc/hf2WFHEva9uDGQbWdg7gm/GLx1rp0ujqoruvbxnlE8uLxWr3tef7/rwkoB/9isbDZgQ==
X-Received: by 2002:a17:90a:2844:b0:1df:b47e:c541 with SMTP id p4-20020a17090a284400b001dfb47ec541mr5266687pjf.110.1653609007500;
        Thu, 26 May 2022 16:50:07 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id e5-20020a170902b78500b001622f07530asm2169417pls.17.2022.05.26.16.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 16:50:07 -0700 (PDT)
Date:   Thu, 26 May 2022 16:50:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.18.0 release
Message-ID: <20220526165004.69f0dfba@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the release of iproute2 corresponding to the 5.18 kernel.
There are not many new features in this release.

The build issues with libbpf should be fixed now.
Building with clang is now supported.
There are still some warnings with gcc-12 that will need to be
fixed in the upstream kernel headers.


Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.18.0.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Andrea Claudi (8):
      Makefile: move HAVE_MNL check to top-level Makefile
      configure: add check_libtirpc()
      ss: remove an implicit dependency on rpcinfo
      tc: em_u32: fix offset parsing
      man: devlink-region: fix typo in example
      man: fix some typos
      doc: fix 'infact' --> 'in fact' typo
      tipc: fix keylen check

Baowen Zheng (2):
      tc: add skip_hw and skip_sw to control action offload
      tc: separate action print for filter and action dump

Coco Li (1):
      iplink: add gro_max_size attribute handling

Daniel Braunwarth (2):
      lib: add profinet and ethercat as link layer protocol names
      tc: bash-completion: Add profinet and ethercat to procotol completion list

David Ahern (17):
      Update kernel headers
      Update kernel headers
      devlink: Remove strtouint64_t in favor of get_u64
      devlink: Remove strtouint32_t in favor of get_u32
      devlink: Remove strtouint16_t in favor of get_u16
      devlink: Remove strtouint8_t in favor of get_u8
      configure: Allow command line override of toolchain
      Update kernel headers
      bpf_glue: Remove use of bpf_load_program from libbpf
      bpf: Export bpf syscall wrapper
      bpf: Remove use of bpf_create_map_xattr
      Revert "configure: Allow command line override of toolchain"
      Import batman_adv.h header from last kernel sync point
      Update kernel headers
      libbpf: Use bpf_object__load instead of bpf_object__load_xattr
      libbpf: Remove use of bpf_program__set_priv and bpf_program__priv
      libbpf: Remove use of bpf_map_is_offload_neutral

Davide Caratti (1):
      ss: display advertised TCP receive window and out-of-order counter

Eli Cohen (5):
      vdpa: Remove unsupported command line option
      vdpa: Allow for printing negotiated features of a device
      vdpa: Support for configuring max VQ pairs for a device
      vdpa: Support reading device features
      vdpa: Update man page with added support to configure max vq pair

Eric Dumazet (2):
      iplink: add ip-link documentation
      iplink: remove GSO_MAX_SIZE definition

Eyal Birger (1):
      ip/geneve: add support for IFLA_GENEVE_INNER_PROTO_INHERIT

Gal Pressman (1):
      tunnel: Fix missing space after local/remote print

Geliang Tang (3):
      mptcp: add fullmesh check for adding address
      mptcp: add fullmesh support for setting flags
      mptcp: add port support for setting flags

Hangbin Liu (1):
      bond: add ns_ip6_target option

Hans Schultz (4):
      bridge: link: add command to set port in locked mode
      ip: iplink_bridge_slave: add locked port flag support
      man8/bridge.8: add locked port feature description and cmd syntax
      man8/ip-link.8: add locked port feature description and cmd syntax

Jiri Pirko (1):
      devlink: fix "devlink health dump" command without arg

Joachim Wiberg (9):
      bridge: support for controlling flooding of broadcast per port
      man: bridge: document new bcast_flood flag for bridge ports
      man: bridge: add missing closing " in bridge show mdb
      ip: iplink_bridge_slave: support for broadcast flooding
      man: ip-link: document new bcast_flood flag on bridge ports
      man: ip-link: mention bridge port's default mcast_flood state
      man: ip-link: whitespace fixes to odd line breaks mid sentence
      bridge: support for controlling mcast_router per port
      man: bridge: document per-port mcast_router settings

Justin Iurman (2):
      Add support for the IOAM insertion frequency
      Update documentation

Luca Boccassi (2):
      man: 'allow to' -> 'allow one to'
      man: use quote instead of acute accent

Nicolas Escande (1):
      ip/batadv: allow to specify RA when creating link

Stephen Hemminger (17):
      tc: add format attribute to tc_print_rate
      utils: add format attribute
      netem: fix clang warnings
      flower: fix clang warnings
      tc_util: fix clang warning in print_masked_type
      ipl2tp: fix clang warning
      can: fix clang warning
      tipc: fix clang warning about empty format string
      tunnel: fix clang warning
      libbpf: fix clang warning about format non-literal
      json_print: suppress clang format warning
      tc_util: fix breakage from clang changes
      tc/f_flower: fix indentation
      uapi: update from 5.18-rc1
      uapi: upstream update to stddef.h
      uapi: update of virtio_ids
      v5.18.0

Wen Liang (2):
      tc: u32: add support for json output
      tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`

Wojciech Drewek (3):
      f_flower: fix indentation for enc_key_id and u32
      ip: GTP support in ip link
      f_flower: Implement gtp options support

