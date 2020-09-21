Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB40272FA1
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgIUQ62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:58:28 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7836 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729411AbgIUQlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:41:44 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f68d79a0000>; Mon, 21 Sep 2020 09:40:58 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 21 Sep
 2020 16:41:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 0/2] devlink: Use nla_policy to validate range
Date:   Mon, 21 Sep 2020 19:41:28 +0300
Message-ID: <20200921164130.83720-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600706458; bh=aJUoWL37cUC4umRhX0nkONHd618Ch1NnyKACcsWFTdY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=oTgcRx0fMso2BXX6OLlgRo7mBXYxLHF/+gt4B30G8U5CsXpILOQ8XqbAfkG5X33ox
         8DR+wMxBHJ3VH5FqxG/LTpMeMHM1a/qAX3TW8zkWPSugX57H3uvFn8i4/yJambBt5w
         BK5NIXpyEDJYh3M361iecA61eEqvYKrg/HrEtneB6ip9aSdRkhlZtyWPdGoy5UUIRb
         X+rEgStNqtp5eOkjClEuUFibH7YP9UelZNNFZ3o85cSFFebrrvRLrBT0eHtE9A/NkF
         2QLtYUe3Cliw9OHDPw+/Es2pin2Mp+kKs8x5gn+MhlD+6s3+uKuvM+FfbOfftxljIc
         v+kZ/9VdVpz/Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This two small patches uses nla_policy to validate user specified
fields are in valid range or not.

Patch summary:
Patch-1 checks the range of eswitch mode field
Patch-2 checks for the port type field. It eliminates a check in
code by using nla policy infrastructure.

Parav Pandit (2):
  devlink: Enhance policy to validate eswitch mode value
  devlink: Enhance policy to validate port type input value

 net/core/devlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--=20
2.26.2

