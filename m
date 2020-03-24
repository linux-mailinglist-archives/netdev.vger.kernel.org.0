Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EE919049C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgCXEqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:46:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgCXEqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:46:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E14451579A57D;
        Mon, 23 Mar 2020 21:46:37 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:46:36 -0700 (PDT)
Message-Id: <20200323.214636.1040830888283850102.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, mbizon@freebox.fr, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: Fix duplicate frames flooded by learning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200322205850.3528-1-f.fainelli@gmail.com>
References: <20200322205850.3528-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:46:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun, 22 Mar 2020 13:58:50 -0700

> When both the switch and the bridge are learning about new addresses,
> switch ports attached to the bridge would see duplicate ARP frames
> because both entities would attempt to send them.
> 
> Fixes: 5037d532b83d ("net: dsa: add Broadcom tag RX/TX handler")
> Reported-by: Maxime Bizon <mbizon@freebox.fr>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable.
