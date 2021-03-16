Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA8333E0CA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhCPVsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhCPVsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:48:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E870F64F7F;
        Tue, 16 Mar 2021 21:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615931282;
        bh=0qSpmuvVZVrk7Xlu54mjY7aP2yc4iwEF4t5XThu2F7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RadelCHUA4Sy02sloHaTolP5ZFIHL/ja3L7/XLuctwjgexnVyPouj2Xs+McUa5NZI
         2z2FGKcFW8bTIa9hCrAT7ZzsAkPiyvRx060sBAvEgq7Vaec/ndHBlKuCtZIYzIDMjq
         DCWCr8Qb7Dt7MYrVu8dQSrnWYoK0NCi9kCpxkW8FgyHqBrPOqnF2jNorMARW0KHmoG
         vnW4xCIgsuNhMYiUadXCU2VmyUwNrvCD2aO9A1IrFVg9UXIqxhgLSom+nft6cDgjVk
         Ue1fdx+enpvqNsy47mAeoNzgrqwGagSdFyCC4O3cAstrE2q8IwuTiqdStcgfjkbHE7
         Nwa+qa0Zu+ymg==
Date:   Tue, 16 Mar 2021 14:48:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harald Welte <laforge@gnumonks.org>
Cc:     Jonas Bonn <jonas@norrbonn.se>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        osmocom-net-gprs@lists.osmocom.org,
        Oliver Smith <osmith@sysmocom.de>,
        Pravin Shelar <pravin.ovn@gmail.com>
Subject: Re: Automatic testing for kernel GTP tunnel driver
Message-ID: <20210316144801.3b03ab5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YFEQBFnqH21kEzeN@nataraja>
References: <YFEQBFnqH21kEzeN@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 21:07:32 +0100 Harald Welte wrote:
> If you have any questions, please feel free to reach out to Oliver
> and/or me.

Perhaps worth dropping a paragraph and the links into Documentation/?
