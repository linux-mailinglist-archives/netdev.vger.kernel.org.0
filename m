Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14A1130B0
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfECOvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:51:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44706 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbfECOvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:51:07 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B319314B799EA;
        Fri,  3 May 2019 07:51:05 -0700 (PDT)
Date:   Fri, 03 May 2019 10:51:04 -0400 (EDT)
Message-Id: <20190503.105104.932427839600881016.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 net-next 00/12] NXP SJA1105 DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 07:51:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu,  2 May 2019 23:23:28 +0300

> This patchset adds a DSA driver for the SPI-controlled NXP SJA1105
> switch.

Series applied, thank you.

