Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE182215FFD
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGFUQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:16:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D270AC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:16:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 869D8120ED4AD;
        Mon,  6 Jul 2020 13:16:40 -0700 (PDT)
Date:   Mon, 06 Jul 2020 13:16:39 -0700 (PDT)
Message-Id: <20200706.131639.2107129979551104538.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, sbrivio@redhat.com
Subject: Re: [PATCH net-next] geneve: move all configuration under struct
 geneve_config
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0e05d6eb47238c62282bc9862d0607c41adc9330.1594046961.git.sd@queasysnail.net>
References: <0e05d6eb47238c62282bc9862d0607c41adc9330.1594046961.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 13:16:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Mon,  6 Jul 2020 17:18:08 +0200

> This patch adds a new structure geneve_config and moves the per-device
> configuration attributes to it, like we already have in VXLAN with
> struct vxlan_config. This ends up being pretty invasive since those
> attributes are used everywhere.
> 
> This allows us to clean up the argument lists for geneve_configure (4
> arguments instead of 8) and geneve_nl2info (5 instead of 9).
> 
> This also reduces the copy-paste of code setting those attributes
> between geneve_configure and geneve_changelink to a single memcpy,
> which would have avoided the bug fixed in commit
> 56c09de347e4 ("geneve: allow changing DF behavior after creation").
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Looks good, applied, thanks.
