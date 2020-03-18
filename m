Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD781894C9
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgCREM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:12:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35508 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgCREM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:12:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7075141C8E48;
        Tue, 17 Mar 2020 21:12:58 -0700 (PDT)
Date:   Tue, 17 Mar 2020 21:12:58 -0700 (PDT)
Message-Id: <20200317.211258.2083489740977534401.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     jiri@resnulli.us, netdev@vger.kernel.org, kernel-team@fb.com,
        ecree@solarflare.com, pablo@netfilter.org
Subject: Re: [PATCH net-next 0/2] net: rename flow_action stats and set NFP
 type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317014212.3467451-1-kuba@kernel.org>
References: <20200317014212.3467451-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 21:12:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 16 Mar 2020 18:42:10 -0700

> Jiri, I hope this is okay with you, I just dropped the "type" from
> the helper and value names, and now things should be able to fit
> on a line, within 80 characters.
> 
> Second patch makes the NFP able to offload DELAYED stats, which
> is the type it supports.

Series applied, thanks.
