Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834A547D608
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 18:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344421AbhLVRvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 12:51:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44870 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbhLVRu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 12:50:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4498461B6C;
        Wed, 22 Dec 2021 17:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EDDC36AE8;
        Wed, 22 Dec 2021 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640195458;
        bh=JUac83OQJZ0L94pmMFyOojjxuMWJ4jlxQQH42a4iQv4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cTavYsrX0ZckSIgCM3g1qTvnJ6mQgrVSomcHM8CTDEMuUJttgf0gldz1MViDlrNfB
         mksn0681txqXbVEpEK4GVvyx5Es4hz+dgFS+yTvUPDKGttZsYamm5Bu9HEj9NOZJrh
         XHWeZUjQuBFyWe1VwBFlyfEzKn98WEdauP6efdxFf0hZwaKbPx4AxL1bE6AW0YcMEs
         y19DDw1XCzHJj0yEUAOJ5RxIcO0acpURo9NN/WP9rgTeZwGl9DQEwYLlbrbRIgMcRy
         ms/Jw4ZzJ8BUflwg2CNKWAL5vG2G219lBc7ja3dohilitFnEPwN2N+YkgZEbbKUPIs
         Kzh8epen532ew==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wilc1000: Convert static "chipid" variable to
 device-local
 variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211221210538.4011227-1-davidm@egauge.net>
References: <20211221210538.4011227-1-davidm@egauge.net>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164019545506.12144.12415516728953232362.kvalo@kernel.org>
Date:   Wed, 22 Dec 2021 17:50:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> wrote:

> Move "chipid" variable into the per-driver structure so the code
> doesn't break if more than one wilc1000 module is present.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>

Patch applied to wireless-drivers-next.git, thanks.

4d2cd7b06ce0 wilc1000: Convert static "chipid" variable to device-local variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211221210538.4011227-1-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

