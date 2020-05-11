Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492B81CE959
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgEKXwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728102AbgEKXwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:52:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ACAC061A0C;
        Mon, 11 May 2020 16:52:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8355120ED551;
        Mon, 11 May 2020 16:52:17 -0700 (PDT)
Date:   Mon, 11 May 2020 16:51:29 -0700 (PDT)
Message-Id: <20200511.165129.2255288530907660795.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: dsa: Constify two tagger ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200511234715.23566-1-f.fainelli@gmail.com>
References: <20200511234715.23566-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 16:52:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 11 May 2020 16:47:13 -0700

> This patch series constifies the dsa_device_ops for ocelot and sja1105

Series applied, thanks Florian.
