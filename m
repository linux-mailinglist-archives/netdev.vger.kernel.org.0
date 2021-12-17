Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5024791D3
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbhLQQrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:47:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38804 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbhLQQrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 11:47:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0027DB828FF;
        Fri, 17 Dec 2021 16:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDB1C36AE1;
        Fri, 17 Dec 2021 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639759663;
        bh=DHZamR+BFpd7/KAMScY5qT50nC8pognFKCb+NseirOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pfGbuuBchvMgUfqwBlmsNUDBv6lMtp09XP8W9UofTmOwQQqitB5IfffrY1Meyd1zZ
         jdf0dCX1y7A6WbW9WjiiUxat+Rzj34VsF1uz5BoRKoRzWlpMapWi0Ru5Vq4oEqcVNT
         RwDDqPHBNhFYszuwZrT+UODFWc1+ugrX4CUOfxebBRnhkOnLoWC5t6ttafjv+s4Rea
         wzubmjZiRxjJcm6jX/WCmv0R2USdDaQsMQf+F1fu6zuJ9FdwaRygJJIOmrMC6ZW4PU
         8rME856p7w7JYxySgFDsmQPI0dqZZPM1G6n43wVKaYhHLRakapC11bLQhNZgWBeBEx
         hU/yC1bGs9Xow==
Date:   Fri, 17 Dec 2021 08:47:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, deng.changcheng@zte.com.cn,
        stefan.wahren@i2se.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net: vertexcom: Remove unneeded semicolon
Message-ID: <20211217084742.7662694a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211217084827.452729-1-deng.changcheng@zte.com.cn>
References: <20211217084827.452729-1-deng.changcheng@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Dec 2021 08:48:27 +0000 cgel.zte@gmail.com wrote:
> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Fix the following coccicheck review:
> ./drivers/net/ethernet/vertexcom/mse102x.c: 414: 2-3: Unneeded semicolon

The Alibaba bot has beaten you to the punch, see commit 431b9b4d9789
("net: vertexcom: remove unneeded semicolon") in net-next.

Here we thought that "robot wars" will be like Terminator, what we got 
instead is false scarcity of concert tickets and auto-generated patches
which often don't build :(
