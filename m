Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45984890C2
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 08:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbiAJHZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 02:25:32 -0500
Received: from out162-62-57-252.mail.qq.com ([162.62.57.252]:56697 "EHLO
        out162-62-57-252.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239314AbiAJHYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 02:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641799466;
        bh=9k1eFxwwZYjFKr+WJMD9o6mAxJi78ILGRPskXq6r9Nw=;
        h=From:To:Cc:Subject:Date;
        b=RvmkWRGgc9cJZOlbPuUmCGG/LdL5fUOJoTPfl8oMyQ+jmk1ZcwJjGgQKvgrTffT5J
         uauZ4XBeIx3375NEPKKr8EuhOGbmH1ADEDrX/R7JG1kwMUTCxFHEkXq0ybFVbWTZzI
         Wo4eMVsE6K7CE3T8RSh+J5d8VHnmc19VZdLafzIE=
Received: from fedora.. ([119.32.47.91])
        by newxmesmtplogicsvrsza9.qq.com (NewEsmtp) with SMTP
        id 5CD80CD5; Mon, 10 Jan 2022 15:23:13 +0800
X-QQ-mid: xmsmtpt1641799393t3g57ii7w
Message-ID: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
X-QQ-XMAILINFO: N9vFsJHELd5M78BrG7pkWX+iqbIqvE7AJmW7380o2BEH1iGng8N8iYDr23IHo0
         2v85PrK3LhxPTuXuJTMpGt5FSAX55+vCRTUUfDQYQZjLzLS4wgqfsnyxOPKY88UZH+fq7B7SVDmr
         dH8aN8VKngMlB7QGBWnJt0u1+pEJImetkN3N5snGKPgq1U+miR/dCgaVIkcJ8mKtb5SFwOClyDCO
         1ALTtuzFg/Uk+7X0g1VjR2DFSkKdClV2kPEMM/BuB3nDc73VlTxFv1Zc+4sb/UaVT1KS3+UmQzW7
         SZdETf3eXJEzCaeyQhDGd6NoE47AbbjaerHrLco3zt9rdIp02vBg6F4WhWnhMU9fZO/bCZVmhE/U
         oyDnjZqCu9dgEAndmMq2pZT/z0zzPZUDkZOZKse1fstQJFKF6MoYtdHYa8PLmxPaXdTxlLY9vzQU
         xkG2Sf/ZWYLnZ0F+lfbf04NnhAyMTYxk4gYU2l8JkxJjQuEa2rmV/NIBjBZI/0CjPTiSMTPKDLjm
         O77kAoan5Tr+onw/dZr8S2dp94R2kG9EY3aD6rcgELmjDVTYaQW/HxwvUa1r+mlLtuSMBVS9dbKw
         3sQ/2O/j5d3hwYJhbK4UsqrNBKVO9qP/tnjN4LNhKJIjqBb8aSW17lElY2zhO4dYAkrxU2YYYGFF
         vazyiHqDHIErFFGWXpHG4DvdpRKA7Gq9ko07Ws8+l+R0bWBZ/PshiHfjOMQCORNXDpLpMM+bwvX/
         0wxd/M6RtBRwDUfdt7F3qlx87LvmxJJKxOUkWL/npIg3mMEnSe/dKjQo46xRsM12qGqh6Jdvy66E
         80C08x/3Iv+dLBVZFdgk2YMtFZ+/0kGganAlZ7YMRHudd1oMlUu1rTvXAjN+m1dbJWDKIGsyDr8D
         aShgpCwK32DvezXFVayNBSM5dI48SCi9mMKMiu2YTEuXRBrJ2FGt8=
From:   conleylee@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, conley <conleylee@foxmail.com>
Subject: [PATCH 0/2] sun4i-emac: replace magic number with marcos
Date:   Mon, 10 Jan 2022 15:23:07 +0800
X-OQ-MSGID: <20220110072309.2259523-1-conleylee@foxmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: conley <conleylee@foxmail.com>

- sun4i-emac.h: add register related marcos
- sun4i-emac.c: replace magic number with marco

*** BLURB HERE ***

conley (2):
  sun4i-emac.h: add register related marcos
  sun4i-emac.c: replace magic number with macro

 drivers/net/ethernet/allwinner/sun4i-emac.c | 26 ++++++++++-----------
 drivers/net/ethernet/allwinner/sun4i-emac.h | 18 ++++++++++++++
 2 files changed, 31 insertions(+), 13 deletions(-)

-- 
2.31.1

