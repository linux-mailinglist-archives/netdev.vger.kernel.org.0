Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3BE1865E3
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 08:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgCPHtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 03:49:16 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:39898 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729975AbgCPHtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 03:49:16 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 82F278364E;
        Mon, 16 Mar 2020 20:49:14 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1584344954;
        bh=1rQSyOnMwjAoffjicjGeCZR94Ltrz9583k/PTHp0BH4=;
        h=From:To:Cc:Subject:Date;
        b=EI7lYRK9wkGl/zkiUMTdCjb5k4hDJifXZL18Fvc4kMUEW60KmxA/QPtzM8PHVVAbW
         OacM7TQjTHpUJiLOuOI7XOmVt1LSsLlh/R5VFco0fhtuy8XDNv7qEApH9qKI1RyCki
         KqZgQRHzUonocMLeW59Z6d5K6RlgxHdoSl/uKX/YiHU/LDSTQmzxX88EifAN6GHoz8
         FLllPOAAtg2J6W76Nj8NECyhFXuM84G2N17Q2ECCTMTZSTmXTi9AwhHfrEzIHLxRku
         1jYICPw6qxSKapAMp+HHCs3cN0ozCPO996tydm2nEuF9VVgxoftgDjLs6jtwdfP/S1
         sh1BsDOm4yTPw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e6f2f750000>; Mon, 16 Mar 2020 20:49:14 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id E429113EF2A;
        Mon, 16 Mar 2020 20:49:08 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 4203528006E; Mon, 16 Mar 2020 20:49:09 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     davem@davemloft.net, andrew@lunn.ch, josua@solid-run.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v3 0/2] net: mvmdio: avoid error message for optional IRQ
Date:   Mon, 16 Mar 2020 20:49:05 +1300
Message-Id: <20200316074907.21879-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've gone ahead an sent a revert. This is the same as the original v1 exc=
ept
I've added Andrew's review to the commit message.

Chris Packham (2):
  Revert "net: mvmdio: avoid error message for optional IRQ"
  net: mvmdio: avoid error message for optional IRQ

 drivers/net/ethernet/marvell/mvmdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--=20
2.25.1

