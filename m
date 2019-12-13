Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6198A11DB8D
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbfLMBOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 20:14:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfLMBOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 20:14:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A067C15422F8B;
        Thu, 12 Dec 2019 17:14:53 -0800 (PST)
Date:   Thu, 12 Dec 2019 17:14:53 -0800 (PST)
Message-Id: <20191212.171453.1545851757919326704.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V3 net-next v3 0/3] Introduce XDP to ena
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210131214.3887-1-sameehj@amazon.com>
References: <20191210131214.3887-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 17:14:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Tue, 10 Dec 2019 15:12:11 +0200

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This patchset includes 3 patches:
> * XDP_DROP implementation
> * XDP_TX implementation
> * A fix for an issue which might occur due to the XDP_TX patch. I see fit
>   to place it as a standalone patch for clarity.
...

Series applied, thank you.
