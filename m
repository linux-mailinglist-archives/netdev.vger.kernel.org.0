Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D3D327CB5
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhCAK6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:58:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13192 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbhCAK5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:57:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603cc8830006>; Mon, 01 Mar 2021 02:57:07 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 10:57:06 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next 0/4] devlink: Use utils helpers
Date:   Mon, 1 Mar 2021 12:56:50 +0200
Message-ID: <20210301105654.291949-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614596227; bh=IYJKVVG9FAYgai91I5xf1aalLPuJXWahcdNmSkIXZdU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=GFszEBpQagwC/9Kt42hrecX2ph+bZW5/DP4ZJCFOzF8XlIBanC/T5LzXGer/z3cZ3
         VBd0jUdb8nd4J46Ob3n6cubqtuAQosQD9DJNVQDOJJgu3qIxnftwd+n3NeEoBgSATg
         XAYLTwkIuMkZALfZ5Tuq/YqZ6Hk3QMjQWwMOQ64yzkY7j6ZQwIv/r5iROEVf6Ar7jn
         Wj7tXxeE2Yh2KLczkk0N01oFuyycQfgygk/TrZOacyGP8mlPjPvZURbC2J0lhXD14P
         /66/toRmEku21hjSRTqdFYIEWkAaN/vlKgmYy/AtGKKvJwgef29RYw8MEsKTntp8zB
         04NHYiqzeC7hQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series uses utils helper for socket operations, string
processing and print error messages.

Patch summary:
Patch-1 uses utils library helper for string split and string search
Patch-2 extends library for socket receive operation
Patch-3 converts devlink to use socket helpers from utlis library
Patch-4 print error when user provides invalid flavour or state

Parav Pandit (4):
  devlink: Use library provided string processing APIs
  utils: Introduce helper routines for generic socket recv
  devlink: Use generic socket helpers from library
  devlink: Add error print when unknown values specified

 devlink/devlink.c   | 365 ++++++++++++++++++++------------------------
 devlink/mnlg.c      | 121 ++-------------
 devlink/mnlg.h      |  13 +-
 include/mnl_utils.h |   6 +
 lib/mnl_utils.c     |  25 ++-
 5 files changed, 203 insertions(+), 327 deletions(-)

--=20
2.26.2

