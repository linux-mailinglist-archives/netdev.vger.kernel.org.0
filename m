Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A083E63D7B
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbfGIVrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:47:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46152 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIVrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:47:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2ADC014249729;
        Tue,  9 Jul 2019 14:47:00 -0700 (PDT)
Date:   Tue, 09 Jul 2019 14:46:59 -0700 (PDT)
Message-Id: <20190709.144659.591991854466468779.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Subject: Re: [PATCH 1/2] net: netsec: remove superfluous if statement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562706889-15471-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1562706889-15471-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 14:47:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Wed, 10 Jul 2019 00:14:48 +0300

> While freeing tx buffers the memory has to be unmapped if the packet was
> an skb or was used for .ndo_xdp_xmit using the same arguments. Get rid
> of the unneeded extra 'else if' statement
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied.
