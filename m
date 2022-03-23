Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77A44E5A5F
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 22:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240922AbiCWVIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 17:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240936AbiCWVIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 17:08:46 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6F48CCCE
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 14:07:16 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k14so2213489pga.0
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 14:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4n54KKSYTifGRwgBQh4ZXQifTE1THI8hFThmOrv34YM=;
        b=kkih1QwDDhEaSSPL4loh7xSDFOOS/sDng9VyqvSY1vI8IUOKnOCJd56C7GR4G0HjCv
         HjvNGGk6A0Nqb1QYGmBNboDyvgtva+lrvry1iKEjk1EHlYXq44mN6P7L7JZCWR8fWS15
         XVXFuO+wRG14MuEg9ENt4KqHqk5UbrAlv9EHSZFA9q6NBrpF1eVGLFU9SEFlhI8RzVzS
         dzortI4Z2auSyEmGDKDtU72vvplxK5TgFnfbqm7CbKin5QmK38mg97r0uEZ18bELxNNa
         xsdsAIMLglyo2ioUDdw5T6K/hogiBUXnfznpq4mpdWWya/UoZjh1zz4mslihmQ4EJV/Q
         0APg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4n54KKSYTifGRwgBQh4ZXQifTE1THI8hFThmOrv34YM=;
        b=n1enw4dJCc2XD3ep0yqj4Hd3BL4Hp3ip+2+sSDWIbKX4mpaAtjBhQMbNEoJIuUgjeC
         rNXETtNcdNRTb31RQAq9k+FOPUU5IsDYqjb8HBfC/TTpMBjERJDo/bokdP8cDnDdzmtH
         MFxdI3A1/PuUsFD08NdpirTcibADwYow1cNLn0UVnuGJhDWCKxzK8m8sKkOAMCcfOygw
         jbS5QCJ/ZKlfE19N1cjBiW89FaPXdXMX5xR7TlMFenAxaFeOOK1GW6vg4qmpJad0a5R+
         mSsOPEIXHlO6X9OkMf9QzSA4K9hlSIw+e9x+Bg/gHXH44pazGForuczbC5gldnsA/2Gi
         9emQ==
X-Gm-Message-State: AOAM533/GohpMuIQt6mvD5ECtjwhQ+kYugihSTaRdoJskT6O20oKfAYI
        kj1hR43XkQMuI6ihtNbDLHX8Ne6+lzdeBw==
X-Google-Smtp-Source: ABdhPJxaQkCAy+VRVSUBhmtgWHJX4glHOBQZaTuUOMyb6WgOK5MJbDE0mhOfU7P4YX1rLtWSoGJh0w==
X-Received: by 2002:a65:5542:0:b0:381:f5d3:e343 with SMTP id t2-20020a655542000000b00381f5d3e343mr1366674pgr.462.1648069635442;
        Wed, 23 Mar 2022 14:07:15 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id x9-20020a056a00188900b004f7454e4f53sm825822pfh.37.2022.03.23.14.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 14:07:14 -0700 (PDT)
Date:   Wed, 23 Mar 2022 14:07:12 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.17.0 release
Message-ID: <20220323140712.5b593820@hermes.local>
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

This is the release of iproute2 corresponding to the 5.17 kernel.
There are not a lot of features, mostly just small bug fixes.

TL;DR: warnings when building with libbpf on more recent
Linux distributions are expected.

Background:
Iproute2 now has the option of using libbpf for management
of bpf object files as of v5.11 and libbpf is still not completely
settled.  Over the past year, libbpf has been marching to a v1.0
release where it is deprecating many APIs and supported runtime
functionality. Those deprecations manifest as a number of compile
warnings and runtime warnings, depending on libbpf version. The
messages are just warnings to the builder and user; there is not any
*expected* behavior changes prior to the v1.0 release.

At this time, iproute2 v5.17 compiles cleanly with libbpf up to
version 0.6, but there are a few warnings with libbpf 0.7 released in
February 2022 - the latest version as of the release of iproute2 5.17.
The compile time warnings are mostly addressed by the current -next
branch and will be fixed by the time iproute2 v5.18 is released. In
general, this will be an on-going problem as more APIs are deprecated
leading up to the 1.0 release.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.17.0.tar=
.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Andrea Claudi (3):
      ss: use freecon() instead of free() when appropriate
      lib/fs: fix memory leak in get_task_name()
      rdma: make RES_PID and RES_KERN_NAME alternative to each other

Antony Antony (2):
      testsuite: link xfrm delete no if_id test
      link_xfrm: if_id must be non zero

Benjamin Poirier (2):
      bridge: Fix error string typo
      bridge: Remove vlan listing from `bridge link`

David Ahern (3):
      Update kernel headers
      Update kernel headers and import virtio_net
      Update kernel headers

Davide Caratti (1):
      mptcp: add support for changing the backup flag

Geliang Tang (1):
      mptcp: add id check for deleting address

Guillaume Nault (1):
      iprule: Allow option dsfield in 'ip rule show'

Hangbin Liu (1):
      bond: add arp_missed_max option

Kevin Bracey (1):
      q_cake: allow changing to diffserv3

Leon Romanovsky (2):
      rdma: Limit copy data by the destination size
      rdma: Don't allocate sparse array

Maxim Petrov (2):
      libnetlink: fix socket leak in rtnl_open_byproto()
      lnstat: fix strdup leak in -w argument parsing

Maxime de Roucy (1):
      ipaddress: remove 'label' compatibility with Linux-2.0 net aliases

Paolo Abeni (1):
      mptcp: add support for fullmesh flag

Parav Pandit (5):
      vdpa: Remove duplicate vdpa UAPI header file
      vdpa: Update kernel headers
      vdpa: Enable user to query vdpa device config layout
      vdpa: Enable user to set mac address of vdpa device
      vdpa: Enable user to set mtu of the vdpa device

Petr Machata (3):
      dcb: Rewrite array-formatting code to not cause warnings with Clang
      dcb: app: Add missing "dcb app show dev X default-prio"
      dcb: Fix error reporting when accessing "dcb app"

Roi Dayan (1):
      tc_util: Fix parsing action control with space and slash

Sam James (1):
      lib: fix ax25.h include for musl

Shangyan Zhou (2):
      rdma: Fix res_print_uint() and add res_print_u64()
      rdma: Fix the logic to print unsigned int.

Stephen Hemminger (12):
      uapi: add missing rose and ax25 files
      uapi: add missing virtio headers
      netem: fix checkpatch warnings
      f_flower: fix checkpatch warnings
      tc/action: print error to stderr
      uapi: update kernel headers from 5.17-rc1
      tc: fix duplicate fall-through
      uapi: update to xfrm.h
      Revert "rdma: Fix res_print_uint() and add res_print_u64()"
      uapi: update magic.h
      uapi: update vdpa.h
      v5.17.0

Thomas Niederberger (1):
      man: Fix a typo in the flag documentation of ip address

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      tc: Add support for ce_threshold_value/mask in fq_codel

Vincent Mailhol (2):
      iplink_can: add ctrlmode_{supported,_static} to the "--details --json=
" output
      iplink_can: print_usage: typo fix, add missing spaces

