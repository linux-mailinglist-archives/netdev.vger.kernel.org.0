Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21861982D7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgC3Rzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:55:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40334 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbgC3Rzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:55:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADFFF15C42827;
        Mon, 30 Mar 2020 10:55:52 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:55:51 -0700 (PDT)
Message-Id: <20200330.105551.2176256870349576678.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Simplify 'dsa_tag_protocol_to_str()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200328095309.27389-1-christophe.jaillet@wanadoo.fr>
References: <20200328095309.27389-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:55:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 28 Mar 2020 10:53:09 +0100

> There is no point in preparing the module name in a buffer. The format
> string can be passed diectly to 'request_module()'.
> 
> This axes a few lines of code and cleans a few things:
>    - max len for a driver name is MODULE_NAME_LEN wich is ~ 60 chars,
>      not 128. It would be down-sized in 'request_module()'
>    - we should pass the total size of the buffer to 'snprintf()', not the
>      size minus 1
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to net-next.
