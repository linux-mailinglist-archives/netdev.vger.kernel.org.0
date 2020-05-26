Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7051E1889
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgEZAqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgEZAql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 20:46:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51011C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 17:46:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 410E912793A96;
        Mon, 25 May 2020 17:46:40 -0700 (PDT)
Date:   Mon, 25 May 2020 17:46:39 -0700 (PDT)
Message-Id: <20200525.174639.246772802390623485.davem@davemloft.net>
To:     sven.auhagen@voleatech.de
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH 1/1] MVNETA_SKB_HEADROOM set last 3 bits to zero
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200523101408.s7upzn62ihjy3pgy@SvensMacBookAir.sven.lan>
References: <20200523101408.s7upzn62ihjy3pgy@SvensMacBookAir.sven.lan>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 17:46:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>
Date: Sat, 23 May 2020 12:14:08 +0200

> For XDP the MVNETA_SKB_HEADROOM is used as an offset for
> the received data. 
> The MVNETA manual states that the last 3 bits assumed to be 0.
> 
> This is currently the case but lets make it explicit in the definition
> to prevent future problems.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Applied with "mvneta: " added to the Subject line as a proper prefix.
