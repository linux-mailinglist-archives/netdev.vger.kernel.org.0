Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9249C25A18D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgIAWgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgIAWgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:36:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CC7C061244;
        Tue,  1 Sep 2020 15:36:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECCE51365945F;
        Tue,  1 Sep 2020 15:19:21 -0700 (PDT)
Date:   Tue, 01 Sep 2020 15:36:07 -0700 (PDT)
Message-Id: <20200901.153607.102288342952967095.davem@davemloft.net>
To:     kamil@re-ws.pl
Cc:     jacmet@sunsite.dk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: dm9601: Add USB ID of Keenetic Plus DSL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901085738.27482-1-kamil@re-ws.pl>
References: <20200901085738.27482-1-kamil@re-ws.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 15:19:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kamil Lorenc <kamil@re-ws.pl>
Date: Tue,  1 Sep 2020 10:57:38 +0200

> Keenetic Plus DSL is a xDSL modem that uses dm9620 as its USB interface.
> 
> Signed-off-by: Kamil Lorenc <kamil@re-ws.pl>

Applied, thanks.
