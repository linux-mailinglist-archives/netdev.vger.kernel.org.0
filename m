Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2992D86CB
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391103AbfJPDfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:35:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbfJPDfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:35:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A02612B8A11F;
        Tue, 15 Oct 2019 20:35:33 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:35:32 -0700 (PDT)
Message-Id: <20191015.203532.501264276758107188.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: updated pedit test cases
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571091509-9585-1-git-send-email-mrv@mojatatu.com>
References: <1571091509-9585-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:35:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Mon, 14 Oct 2019 18:18:29 -0400

> Added TDC test cases for Ethernet LAYERED_OP operations:
> - set single source Ethernet MAC
> - set single destination Ethernet MAC
> - set single invalid destination Ethernet MAC
> - set Ethernet type
> - invert source/destination/type fields
> - add operation on Ethernet type field
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied, thanks.
