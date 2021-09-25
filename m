Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9999A418394
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 19:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhIYReJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 13:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhIYReI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 13:34:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B504A60F12;
        Sat, 25 Sep 2021 17:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632591152;
        bh=d5C2IFnN+uy3Y+3K9gagSZtlmvqBZT5bhvzGwyRJGfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QrzSuFJqITx+SdH+XWvStzCoXf9UEP3FuqNbDEsZMlrFlhlCK/vZoWL9CIlYQ8Jq7
         rReLRmMiY3HaHIsGYc0aUxqef7qhTKBlJgUIyvx9W8Yue9dpON3T7O4zLBvXdgKf9Z
         M793QGI0uT/9cyvBhPB5nwmW3z7Ao4iPFL+SvkJwDiTvtUNCvdQxVNc9+P3lKT2TDk
         ct3EFV7jfEePInM/kdwbbIuRL0r6mdUAtsJ9d72jmq/Llz2aIDzckf1tb8ZzJv0NrG
         vx3GI5ifQs0XzAae3d1ZgHdBJEMwhofeEg8NGMcoBU68o6VoAxBFeqDIiG6PvWBhmI
         6u+mCna41W37Q==
Received: by pali.im (Postfix)
        id 474EE847; Sat, 25 Sep 2021 19:32:30 +0200 (CEST)
Date:   Sat, 25 Sep 2021 19:32:30 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/2] mwifiex: Work around firmware bugs on 88W8897 chip
Message-ID: <20210925173230.dkrdrl4h35lc7vjp@pali>
References: <20210830123704.221494-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830123704.221494-1-verdre@v0yd.nl>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI: There is a new NXP driver for these ex-Marvell wifi chips:
https://source.codeaurora.org/external/nxpwifi/mwifiex/tree/mxm_wifiex/wlan_src/mlinux?h=caf/master

And NXP has there also some modified mwifiex driver:
https://source.codeaurora.org/external/nxpwifi/mwifiex/tree/mwifiex_8997/mlinux?h=caf/master&id=070397228c46e0a6afce4f627b032d3818cc1356

Maybe somebody could be interested in looking into those NXP driver
modifications... Maybe NXP fixed some issues here.

Also look at another new bug report related to mwifiex firmware:
https://lore.kernel.org/linux-wireless/edeb34bc-7c85-7f1d-79e4-e3e21df86334@gk2.net/
