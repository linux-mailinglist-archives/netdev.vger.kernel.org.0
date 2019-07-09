Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6505763C62
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfGIUD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:03:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbfGIUD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 16:03:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4819D140D231D;
        Tue,  9 Jul 2019 13:03:57 -0700 (PDT)
Date:   Tue, 09 Jul 2019 13:03:56 -0700 (PDT)
Message-Id: <20190709.130356.462785391825781786.davem@davemloft.net>
To:     josua@solid-run.com
Cc:     netdev@vger.kernel.org, josua.mayer@jm0.eu
Subject: Re: [PATCH v2 0/4] Fix hang of Armada 8040 SoC in orion-mdio
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709130101.5160-1-josua@solid-run.com>
References: <20190706151900.14355-1-josua@solid-run.com>
        <20190709130101.5160-1-josua@solid-run.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 13:03:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: josua@solid-run.com
Date: Tue,  9 Jul 2019 15:00:57 +0200

> From: Josua Mayer <josua.mayer@jm0.eu>
> 
> With a modular kernel as configured by Debian a hang was observed with
> the Armada 8040 SoC in the Clearfog GT and Macchiatobin boards.
> 
> The 8040 SoC actually requires four clocks to be enabled for the mdio
> interface to function. All 4 clocks are already specified in
> armada-cp110.dtsi. It has however been missed that the orion-mdio driver
> only supports enabling up to three clocks.
> 
> This patch-set allows the orion-mdio driver to handle four clocks and
> adds a warning when more clocks are specified to prevent this particular
> oversight in the future.
> 
> Changes since v1:
> - fixed condition for priting the warning (Andrew Lunn)
> - rephrased commit description for deferred probing (Andrew Lunn)
> - fixed compiler warnings (kbuild test robot)

Series applied, thanks Josua.
