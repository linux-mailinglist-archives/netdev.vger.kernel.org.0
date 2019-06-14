Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5AE4630F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfFNPiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:38:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45148 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNPip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:38:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE61514AEB2DE;
        Fri, 14 Jun 2019 08:38:44 -0700 (PDT)
Date:   Fri, 14 Jun 2019 08:38:41 -0700 (PDT)
Message-Id: <20190614.083841.1881027837524446070.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: add and use helper
 rtl_is_8168evl_up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0c355e89-8e6b-7ea9-4971-21980f9e64da@gmail.com>
References: <0c355e89-8e6b-7ea9-4971-21980f9e64da@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 08:38:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 14 Jun 2019 07:51:33 +0200

> Few registers have been added or changed its purpose with version
> RTL8168e-vl, so create a helper for identifying chip versions from
> RTL8168e-vl.

Series applied, thanks Heiner.
