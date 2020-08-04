Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46B323B239
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgHDBUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729084AbgHDBUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:20:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7878C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:20:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E03821277EA5B;
        Mon,  3 Aug 2020 18:03:37 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:20:22 -0700 (PDT)
Message-Id: <20200803.182022.958969303923411212.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next 0/5] net: dsa: loop: Preparatory changes for
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803200354.45062-1-f.fainelli@gmail.com>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 18:03:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon,  3 Aug 2020 13:03:49 -0700

> These patches are all meant to help pave the way for a 802.1Q data path
> added to the mockup driver, making it more useful than just testing for
> configuration. Sending those out now since there is no real need to
> wait.

Series applied, I added "a 802.1Q data path" to the subject line I integrated
into the merge commit for the series as it seems your Subject line here was
chopped off.
