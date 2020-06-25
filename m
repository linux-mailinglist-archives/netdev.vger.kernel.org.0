Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE3C20A891
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406042AbgFYXHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404734AbgFYXHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:07:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB1FC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:07:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EC51153C7505;
        Thu, 25 Jun 2020 16:07:13 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:07:12 -0700 (PDT)
Message-Id: <20200625.160712.1069325238499341512.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, po.liu@nxp.com, xiaoliang.yang_1@nxp.com,
        kuba@kernel.org
Subject: Re: [PATCH net 0/4] Fixes for SJA1105 DSA tc-gate action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624135447.3261002-1-olteanv@gmail.com>
References: <20200624135447.3261002-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:07:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 24 Jun 2020 16:54:43 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This small series fixes 2 bugs in the tc-gate implementation:
> 1. The TAS state machine keeps getting rescheduled even after removing
>    tc-gate actions on all ports.
> 2. tc-gate actions with only one gate control list entry are installed
>    to hardware with an incorrect interval of zero, which makes the
>    switch erroneously drop those packets (since the configuration is
>    invalid).
> 
> To keep the code palatable, a forward-declaration was avoided by moving
> some code around in patch 1/4. I hope that isn't too much of an issue.

Series applied, thank you.
