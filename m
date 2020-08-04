Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C008423C214
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgHDXMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgHDXMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:12:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED516C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:12:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FF3512896E6C;
        Tue,  4 Aug 2020 15:55:31 -0700 (PDT)
Date:   Tue, 04 Aug 2020 16:12:16 -0700 (PDT)
Message-Id: <20200804.161216.168178586901520741.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] flow_dissector: Add IPv6 flow label to
 symmetric keys
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804155642.52766-1-tom@herbertland.com>
References: <20200804155642.52766-1-tom@herbertland.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 15:55:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kernel patch submissions must have proper signoffs.
