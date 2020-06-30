Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA3B20EA1F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgF3AR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgF3AR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:17:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F12C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:17:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C9D4127BE1AB;
        Mon, 29 Jun 2020 17:17:57 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:17:56 -0700 (PDT)
Message-Id: <20200629.171756.655333160664195676.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, ndev@hwipl.net
Subject: Re: [PATCH net 0/5] support AF_PACKET for layer 3 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200627080713.179883-1-Jason@zx2c4.com>
References: <20200627080713.179883-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:17:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


We customarily don't add new Copyright lines for every change and
fix made to existing files, please get rid of that.

Also please add the sit.c code handling as indicated by Willem.

Thank you.
