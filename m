Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD81284C35
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgJFNGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFNGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:06:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EBEC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 06:06:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 49BBA127C6C04;
        Tue,  6 Oct 2020 05:49:18 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:06:05 -0700 (PDT)
Message-Id: <20201006.060605.29060901209971026.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 0/2] Fix tail dropping watermarks for Ocelot
 switches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201005090912.424121-1-vladimir.oltean@nxp.com>
References: <20201005090912.424121-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 05:49:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon,  5 Oct 2020 12:09:10 +0300

> This series adds a missing division by 60, and a warning to prevent that
> in the future.

Series applied, thank you.
