Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDFC010417
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfEADF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:05:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfEADF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:05:59 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 039A7136D6BEB;
        Tue, 30 Apr 2019 20:05:57 -0700 (PDT)
Date:   Tue, 30 Apr 2019 23:05:51 -0400 (EDT)
Message-Id: <20190430.230551.1783659979502754212.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/13] Improvements to DSA core VLAN
 manipulation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190428184554.9968-1-olteanv@gmail.com>
References: <20190428184554.9968-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 20:05:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 28 Apr 2019 21:45:41 +0300

> In preparation of submitting the NXP SJA1105 driver, the Broadcom b53
> and Mediatek mt7530 drivers have been found to apply some VLAN
> workarounds that are needed in the new driver as well.
> 
> Therefore this patchset is mostly simply promoting the DSA driver
> workarounds for VLAN to the generic code.
 ...

Series applied, thanks.
