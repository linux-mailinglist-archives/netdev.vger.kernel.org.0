Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC3027A409
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgI0U2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgI0U17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:27:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE6EC0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 13:27:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9603913BAFAD7;
        Sun, 27 Sep 2020 13:11:11 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:27:58 -0700 (PDT)
Message-Id: <20200927.132758.357103264963271673.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 00/10] mlxsw: Expose transceiver overheat
 counter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:11:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 27 Sep 2020 10:50:05 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Amit says:
> 
> An overheated transceiver can be the root cause of various network
> problems such as link flapping. Counting the number of times a
> transceiver's temperature was higher than its configured threshold can
> therefore help in debugging such issues.
> 
> This patch set exposes a transceiver overheat counter via ethtool. This
> is achieved by configuring the Spectrum ASIC to generate events whenever
> a transceiver is overheated. The temperature thresholds are queried from
> the transceiver (if available) and set to the default otherwise.
> 
> Example:
> 
> # ethtool -S swp1
> ...
> transceiver_overheat: 2
> 
> Patch set overview:
> 
> Patches #1-#3 add required device registers
> Patches #4-#5 add required infrastructure in mlxsw to configure and
> count overheat events
> Patches #6-#9 gradually add support for the transceiver overheat counter
> Patch #10 exposes the transceiver overheat counter via ethtool

Series applied, thanks.
