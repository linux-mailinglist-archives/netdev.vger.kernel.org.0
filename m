Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B58105ACB
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfKUUAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:00:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfKUUAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:00:38 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C68014EC15A9;
        Thu, 21 Nov 2019 12:00:37 -0800 (PST)
Date:   Thu, 21 Nov 2019 12:00:36 -0800 (PST)
Message-Id: <20191121.120036.2169345820213854498.davem@davemloft.net>
To:     krzk@kernel.org
Cc:     linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] net: Fix Kconfig indentation, continued
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121132835.28886-1-krzk@kernel.org>
References: <20191121132835.28886-1-krzk@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 12:00:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Thu, 21 Nov 2019 21:28:35 +0800

> Adjust indentation from spaces to tab (+optional two spaces) as in
> coding style.  This fixes various indentation mixups (seven spaces,
> tab+one space, etc).
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Applied.
