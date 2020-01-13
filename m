Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E4013890F
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 01:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbgAMAWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 19:22:39 -0500
Received: from mx3.wp.pl ([212.77.101.9]:54840 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387509AbgAMAWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 19:22:38 -0500
Received: (wp-smtpd smtp.wp.pl 26221 invoked from network); 13 Jan 2020 01:22:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578874956; bh=S7dYIstzYUkNSmEPOPGUZNxmFX8xxOKBsDPBLO3oxCY=;
          h=From:To:Cc:Subject;
          b=g/m+35tGn6TygzwqoXdkTzgvuKePEdgQnhAq8dKKD1x+oqWsO5c1kPQNxt62zF/3g
           ZuF3FreYlexcMv+uvXJ6MQzl2OmIIzpisOPHrcoXGP80+MNyE32MhkijDrZrMvaDY9
           5EKJp2XCaiBDPlQZ8Fo6QkBor58XB/E2KFc/SdR0=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <geert@linux-m68k.org>; 13 Jan 2020 01:22:36 +0100
Date:   Sun, 12 Jan 2020 16:22:31 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-m68k@vger.kernel.org
Subject: Re: [PATCH] net: amd: a2065: Use print_hex_dump_debug() helper
Message-ID: <20200112162231.187e84ce@cakuba>
In-Reply-To: <20200112163354.18505-1-geert@linux-m68k.org>
References: <20200112163354.18505-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: d3d5d3c381236083fcc6deeed849005c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [EcPk]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jan 2020 17:33:54 +0100, Geert Uytterhoeven wrote:
> Use the print_hex_dump_debug() helper, instead of open-coding the same
> operations.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied to net-next, thank you!
