Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658EF19040C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgCXECT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:02:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55894 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgCXECT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:02:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DE6215531023;
        Mon, 23 Mar 2020 21:02:18 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:02:17 -0700 (PDT)
Message-Id: <20200323.210217.2240666906885657867.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: phy: xpcs: Improvements for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1584697754.git.Jose.Abreu@synopsys.com>
References: <cover.1584697754.git.Jose.Abreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:02:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri, 20 Mar 2020 10:53:33 +0100

> Misc set of improvements for XPCS. All for net-next.
> 
> Patch 1/4, returns link error upon 10GKR faults are detected.
> 
> Patch 2/4, resets XPCS upon probe so that we start from well known state.
> 
> Patch 3/4, sets Link as down if AutoNeg is enabled but did not finish with
> success.
> 
> Patch 4/4, restarts AutoNeg process if previous outcome was not valid.

Series applied, thanks Jose.
