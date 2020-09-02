Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B7225B6EA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 01:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBXA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 19:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgIBXA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 19:00:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F5BC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 16:00:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F2CF15746448;
        Wed,  2 Sep 2020 15:44:09 -0700 (PDT)
Date:   Wed, 02 Sep 2020 16:00:54 -0700 (PDT)
Message-Id: <20200902.160054.1576232309562383787.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     kuba@kernel.org, louis.peens@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net] nfp: flower: fix ABI mismatch between driver and
 firmware
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200902150458.10024-1-simon.horman@netronome.com>
References: <20200902150458.10024-1-simon.horman@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:44:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Wed,  2 Sep 2020 17:04:58 +0200

> From: Louis Peens <louis.peens@netronome.com>
> 
> Fix an issue where the driver wrongly detected ipv6 neighbour updates
> from the NFP as corrupt. Add a reserved field on the kernel side so
> it is similar to the ipv4 version of the struct and has space for the
> extra bytes from the card.
> 
> Fixes: 9ea9bfa12240 ("nfp: flower: support ipv6 tunnel keep-alive messages from fw")
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

Applied and queued up for -stable, thanks Simon.
