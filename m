Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0451B6499
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgDWTkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgDWTkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:40:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D10EC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:40:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DF2F1277A238;
        Thu, 23 Apr 2020 12:40:19 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:40:18 -0700 (PDT)
Message-Id: <20200423.124018.372142582761672998.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, lucien.xin@gmail.com, sbrivio@redhat.com,
        girish.moodalbail@oracle.com, mschiffer@universe-factory.net
Subject: Re: [PATCH net 0/2] net: vxlan/geneve: use the correct nlattr
 array for extack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1587568231.git.sd@queasysnail.net>
References: <cover.1587568231.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:40:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Wed, 22 Apr 2020 17:29:49 +0200

> The ->validate callbacks for vxlan and geneve have a couple of typos
> in extack, where the nlattr array for IFLA_* attributes is used
> instead of the link-specific one.

Series applied and queued up for -stable, thanks.
