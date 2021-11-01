Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA1A44244A
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhKAXto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhKAXtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 19:49:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF5C061764
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 16:47:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p18so9855978plf.13
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 16:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=UzYhPRxfN72kUqnxzFAI5MAMDQEz6/F2C3soDyRpS2c=;
        b=WDl2XKPNursO5FZzbRDwLHcIfpZ+Vu+U11YkFDaM++Viknk/D/DPwMh++Iz/gmRHmr
         QcxGpNIkzllLtn7PvlIarxOPBy1l0oghI6w21Ikz2uhxfzuHS/hiP6JvrliZiG61jC1B
         kQBlYSXIfFwfCW3mY3v9YKnqXKpYAYJVGDqrchje54NBVxdrCJDULX07rXV7LNDUtkJJ
         2y9cT5ACPCuPU/JXUo3uF8avTaaUqeZmrkSkYFQR0d7n7kZxtWdM0ZqTnWEK8WXQhb7k
         tyZEHtPL7Mw1jbI6fmyy0ShR/Y4RWX9/F8VdH+Oh0g4XqKX1uuf6mD3cLnOqTgzxuKYk
         iWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=UzYhPRxfN72kUqnxzFAI5MAMDQEz6/F2C3soDyRpS2c=;
        b=vDUrDdc6sbGiWHSBPEBIhQ4XpnhZlTENdG+Du5MLFhfGnTLfzC3MTU7z9XxyZVH0f9
         b+sw/aVJvdjSoN2taxao3OjTiSPeXarVepKJ7Hxvd+VuCIr9klVcRjQKvaZwrpIGjcG5
         Hc/Auo9j7MHblKo17leUOSgOlCbRGfqlXGMoB458HxGE2jYb2mnhuOen6TnQn1VbDLJf
         4CrRIszAlGi2aoKzwLo8npzfHn9FB68Vj+UGh+TW3ntEwnSM5UJWnQKy/tkZH3FVuyb8
         y2p0xkWihuf3fCuoHM5BDUULiCz/YBQUpX9rS20HpIcNEjBboamqaEO7xmSikMT/HUIM
         VOOQ==
X-Gm-Message-State: AOAM533mY2GMFXEf9dmEX6HkCgQ+1GVvd0uROrMncCNWjZu/bpt3jlTL
        nZV90vsfPKQy/2XtccyZBBAqKj87jp01xg==
X-Google-Smtp-Source: ABdhPJzGDWpofgaoUfufpelsxEna0/8OrBK0EZ/+wkP7TpMBYCTx6kMQuzbOjv/+xJpb6W5ssdsEQg==
X-Received: by 2002:a17:90a:5b0d:: with SMTP id o13mr2477894pji.117.1635810428735;
        Mon, 01 Nov 2021 16:47:08 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id b6sm14393429pfv.204.2021.11.01.16.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:47:08 -0700 (PDT)
Date:   Mon, 1 Nov 2021 16:47:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.15
Message-ID: <20211101164705.6f4f2e41@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Iproute2 trick or treat edition. As usual many small bug fixes and
a few new features such as IOAM.

As always, it is recommended to always use the latest iproute2.
The latest code will always run on older kernels (and vice versa);
this is possible because of the kernel API/ABI guarantees.
Except for rare cases, iproute2 does not do maintenance releases
and there is no long term stable version.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.15.0.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Andrea Claudi (1):
      lib: bpf_legacy: fix bpffs mount when /sys/fs/bpf exists

Antoine Tenart (4):
      man: devlink-port: fix the devlink port add synopsis
      man: devlink-port: fix style
      man: devlink-port: remove extra .br
      man: devlink-port: fix pfnum for devlink port add

David Ahern (3):
      Update kernel headers
      Import ioam6 uapi headers
      Update kernel headers

David Marchand (1):
      iptuntap: fix multi-queue flag display

Davide Caratti (1):
      mptcp: unbreak JSON endpoint list

Frank Villaro-Dixon (1):
      cmd: use spaces instead of tabs for usage indentation

Gokul Sivakumar (1):
      ipneigh: add support to print brief output of neigh cache in tabular format

Hangbin Liu (1):
      ip/bond: add lacp active support

Ilya Dmitrichenko (1):
      ip/tunnel: always print all known attributes

Justin Iurman (4):
      Add, show, link, remove IOAM namespaces and schemas
      New IOAM6 encap type for routes
      IOAM man8
      ipioam6: use print_nl instead of print_null

Luca Boccassi (2):
      tree-wide: fix some typos found by Lintian
      configure: restore backward compatibility

Neta Ostrovsky (1):
      rdma: Fix SRQ resource tracking information json

Nikolay Aleksandrov (1):
      man: ip-link: remove double of

Paul Chaignon (1):
      lib/bpf: fix map-in-map creation without prepopulation

Peilin Ye (1):
      tc/skbmod: Introduce SKBMOD_F_ECN option

Puneet Sharma (1):
      tc/f_flower: fix port range parsing

Stephen Hemminger (5):
      uapi: update headers from 5.15 merge
      ip: remove leftovers from IPX and DECnet
      uapi: updates from 5.15-rc1
      uapi: pickup fix for xfrm ABI breakage
      v5.15.0

