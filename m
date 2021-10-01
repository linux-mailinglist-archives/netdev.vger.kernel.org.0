Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B4041F07F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354949AbhJAPIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59239 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354960AbhJAPIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BC805C0114;
        Fri,  1 Oct 2021 11:06:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 01 Oct 2021 11:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lCls8i3KAYw3ql8aF
        cCBXPnboZFa/9TzLHUnZfZ9+qk=; b=ROx7Mbq8iuDxGsWUM5WuS2HdvQtmR8/N9
        P7LhBVSBOUeKH98iLbn0mNzmDWoNuFLCHl/WqnYIQRptutYmf92rLA12tl41DceM
        ZaoY3GhcNWM7eABYnvBarFzr1kluBhNF51/tzF/W4Yu5dywXVVpDp60wb30S4e5q
        eV1phQEnT9nNf9p7pTh32UXICCrwt+zTT9l7E1Pc2EW/8yjsmSydmCtTBpOczFy/
        NGoTSfzZNqgCMwLX5KJZ0oeb1po/Kj8xmZ41a7juP49ONO6+KPLBXVCvPKBDyL7e
        K7SVywtVkqfGNq2JKhPimWMMB5n0XDvuvTVNHF3vbK+MTXUneG2Yg==
X-ME-Sender: <xms:CCRXYZJUoMZaMywmSVZ1GFgm2j-08O5u_PTyV8iV-5G96k9d4WqV-w>
    <xme:CCRXYVJKzXiatiO-xB-iyecRTPrKbQsrvv2BalDQRwm0ETqqyUIkjJ2A9VLPNY0ia
    lJ-GhQ5IO1zPiY>
X-ME-Received: <xmr:CCRXYRupJncWKwo-t_c6Lpyfl_qKyrd6SZIyAaRSGCJDjMYwC417AYuzhAmvnxau41HaWNYEv2_i9NLn3nSd5hSWlJPO3I5SGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekiedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:CCRXYaauKwtOfLIIJ-tYlaFAUI4T_neeeLzJUt_1Pp_WnualXJoZ8A>
    <xmx:CCRXYQZFzjFNxB7RRx7BAYHmdQnArdUP5ON6qnlQsprYcKmroUtq_A>
    <xmx:CCRXYeBjRd0CcbN2b1ZrJBj36pvuoODEnNfjJAmNr7vvV-wUoIYb2A>
    <xmx:CSRXYfmsHvlL8eEMitU-8JTN8Ytok-dmt4aBZcXKBJMBGpAt4D1YEQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Oct 2021 11:06:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 0/7] ethtool: Small EEPROM changes
Date:   Fri,  1 Oct 2021 18:06:20 +0300
Message-Id: <20211001150627.1353209-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset contains small patches for various issues I noticed while
working on the module EEPROM parsing code.

v2:
* Patch #1: Do not assume the CLEI code is NULL terminated

Ido Schimmel (7):
  cmis: Fix CLEI code parsing
  cmis: Fix wrong define name
  cmis: Correct comment
  sff-8636: Remove incorrect comment
  sff-8636: Fix incorrect function name
  sff-8636: Convert if statement to switch-case
  sff-8636: Remove extra blank lines

 cmis.c | 12 +++++++-----
 cmis.h |  6 +++---
 qsfp.c | 18 +++++++++---------
 3 files changed, 19 insertions(+), 17 deletions(-)

-- 
2.31.1

