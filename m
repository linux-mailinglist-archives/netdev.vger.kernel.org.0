Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718DF1D6415
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgEPU47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 16:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726592AbgEPU47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 16:56:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E64C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 13:56:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19385119445D0;
        Sat, 16 May 2020 13:56:59 -0700 (PDT)
Date:   Sat, 16 May 2020 13:56:58 -0700 (PDT)
Message-Id: <20200516.135658.485531358159506210.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        simon.horman@netronome.com, kernel-team@fb.com
Subject: Re: [PATCH net-next 0/3] ethtool: set_channels: add a few more
 checks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515194902.3103469-1-kuba@kernel.org>
References: <20200515194902.3103469-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 13:56:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 15 May 2020 12:48:59 -0700

> There seems to be a few more things we can check in the core before
> we call drivers' ethtool_ops->set_channels. Adding the checks to
> the core simplifies the drivers. This set only includes changes
> to the NFP driver as an example.
> 
> There is a small risk in the first patch that someone actually
> purposefully accepts a strange configuration without RX or TX
> channels, but I couldn't find such a driver in the tree.

Series applied, thanks Jakub.

And for the record I accept logical 'or' of booleans as valid :-)
