Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3260A47E5
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfIAGgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:36:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33444 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfIAGgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 02:36:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27EFF14CDB528;
        Sat, 31 Aug 2019 23:36:53 -0700 (PDT)
Date:   Sat, 31 Aug 2019 23:36:50 -0700 (PDT)
Message-Id: <20190831.233650.1425406154795566943.davem@davemloft.net>
To:     razvan.stefanescu@microchip.com
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] net: dsa: microchip: add KSZ8563 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830075202.20740-1-razvan.stefanescu@microchip.com>
References: <20190830075202.20740-1-razvan.stefanescu@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 23:36:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Razvan Stefanescu <razvan.stefanescu@microchip.com>
Date: Fri, 30 Aug 2019 10:52:00 +0300

> This patchset adds compatibility string for the KSZ8563 switch.

Series applied, thank you.
