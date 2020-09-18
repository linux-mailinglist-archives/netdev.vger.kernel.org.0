Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAB726FA3C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIRKRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:17:03 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2580 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRKRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:17:03 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6488f30000>; Fri, 18 Sep 2020 03:16:19 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 10:17:02 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <dsahern@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next RESEND 0/3] devlink show controller and external info
Date:   Fri, 18 Sep 2020 13:16:46 +0300
Message-ID: <20200918101649.60086-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918080300.35132-1-parav@nvidia.com>
References: <20200918080300.35132-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600424179; bh=kPP9KncKILyqjGSEKP65pWzMgBxiayppcWL4Ky9CGtE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=JIB3JmgrobkdQTjG1v3vbtsTrejfpWclChhj2brX9JZmvID45CwO0PW1YBUFckMGX
         CL5+B862/SiZ3w2/tyzgIF+7ucYscNm7DFbWOoUe+1hKszo3wQrgJGawyoqF6A2JdS
         LN0epuoaASp0oBQKouOZT8RuHAh1gr1hxqHNSTAPIAkyrF0/dKpDRBXp27r7AwyJR1
         IoH+WrLiPbozTNEwL0YBUWEfh6eh5GrZHqyn57pfdB3fUQxHbWToAkg+F271cjON/+
         L4kb1koD7D46tixRgYRejtoAKiRPRJIS3v27mJsbnL7ddbiAD821tzT8TBX+h2aoXQ
         pjQYr4dDUrtZw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For certain devlink port flavours controller number and optionally external=
 attributes are reported by the kernel.

(a) controller number indicates that a given port belong to which local or =
external controller.
(b) external port attribute indicates that if a given port is for external =
or local controller.

This short series shows this attributes to user.

Patch summary:
Patch-1 updates the kernel header
Patch-2 shows external attribute
Patch-3 show controller number

Parav Pandit (3):
  devlink: Update kernel headers
  devlink: Show external port attribute
  devlink: Show controller number of a devlink port

 devlink/devlink.c            | 9 +++++++++
 include/uapi/linux/devlink.h | 4 ++++
 2 files changed, 13 insertions(+)

--=20
2.26.2

