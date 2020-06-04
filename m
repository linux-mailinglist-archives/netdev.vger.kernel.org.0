Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3CA1EEDEE
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgFDWsE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Jun 2020 18:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgFDWsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:48:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E2CC08C5C0;
        Thu,  4 Jun 2020 15:48:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93970120ED481;
        Thu,  4 Jun 2020 15:48:03 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:48:02 -0700 (PDT)
Message-Id: <20200604.154802.1372454299803362553.davem@davemloft.net>
To:     michal.vokac@ysoft.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: qca8k: Fix "Unexpected gfp" kernel
 exception
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1591183899-24987-1-git-send-email-michal.vokac@ysoft.com>
References: <1591183899-24987-1-git-send-email-michal.vokac@ysoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:48:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Vok·Ë <michal.vokac@ysoft.com>
Date: Wed,  3 Jun 2020 13:31:39 +0200

> Commit 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
> replaced the dsa_switch_alloc helper by devm_kzalloc in all DSA
> drivers. Unfortunately it introduced a typo in qca8k.c driver and
> wrong argument is passed to the devm_kzalloc function.
> 
> This fix mitigates the following kernel exception:
 ...
> Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
> Cc: <stable@vger.kernel.org>

Please do not CC: stable for networking changes.

> Signed-off-by: Michal Vok·Ë <michal.vokac@ysoft.com>

Applied and queued up for -stable, thank you.
