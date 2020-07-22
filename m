Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEA4228DAD
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 03:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbgGVBgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 21:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgGVBgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 21:36:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED4CC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 18:36:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 573B011D69C3E;
        Tue, 21 Jul 2020 18:20:07 -0700 (PDT)
Date:   Tue, 21 Jul 2020 18:36:51 -0700 (PDT)
Message-Id: <20200721.183651.161331443143182363.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] ionic updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721203409.3432-1-snelson@pensando.io>
References: <20200721203409.3432-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 18:20:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue, 21 Jul 2020 13:34:03 -0700

> These are a few odd code tweaks to the ionic driver: FW defined MTU
> limits, remove unnecessary code, and other tidiness tweaks.

Series applied, thanks Shannon.
