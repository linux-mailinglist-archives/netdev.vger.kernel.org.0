Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891B38964C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfHLEcs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Aug 2019 00:32:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfHLEcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:32:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25C7B145BAEA4;
        Sun, 11 Aug 2019 21:32:47 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:32:46 -0700 (PDT)
Message-Id: <20190811.213246.151393820300894015.davem@davemloft.net>
To:     j.neuschaefer@gmx.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alexios.zavras@intel.com, tglx@linutronix.de, allison@lohutok.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: nps_enet: Fix function names in doc comments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190810111159.3389-1-j.neuschaefer@gmx.net>
References: <20190810111159.3389-1-j.neuschaefer@gmx.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:32:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Date: Sat, 10 Aug 2019 13:11:56 +0200

> Adjust the function names in two doc comments to match the corresponding
> functions.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Applied.
