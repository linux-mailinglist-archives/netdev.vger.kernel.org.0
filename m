Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20D5736D6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbfGXSpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:45:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfGXSpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:45:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F23B1540721A;
        Wed, 24 Jul 2019 11:45:36 -0700 (PDT)
Date:   Wed, 24 Jul 2019 11:45:35 -0700 (PDT)
Message-Id: <20190724.114535.1668136550551949994.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@kernel.org,
        sgruszka@redhat.com, kvalo@codeaurora.org,
        ath9k-devel@qca.qualcomm.com, merez@codeaurora.org,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, amitkarwar@gmail.com,
        nishants@marvell.com, gbhat@marvell.com, huxinming820@gmail.com,
        imitsyanko@quantenna.com, avinashp@quantenna.com,
        smatyukevich@quantenna.com, pkshih@realtek.com,
        linuxwifi@intel.com, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        netdev@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] Use dev_get_drvdata where possible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724112524.13042-1-hslester96@gmail.com>
References: <20190724112524.13042-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 11:45:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Wed, 24 Jul 2019 19:25:24 +0800

> These patches use dev_get_drvdata instead of
> using to_pci_dev + pci_get_drvdata to make
> code simpler.

Patches 1-4 applied to net-nex t.
