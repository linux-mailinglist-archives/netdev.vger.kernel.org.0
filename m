Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE62C39E83A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhFGUVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:21:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53190 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbhFGUVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 16:21:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 360524F66C255;
        Mon,  7 Jun 2021 13:19:12 -0700 (PDT)
Date:   Mon, 07 Jun 2021 13:18:49 -0700 (PDT)
Message-Id: <20210607.131849.385731094335120916.davem@davemloft.net>
To:     13145886936@163.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Subject: Re: [PATCH] net/atm/common.c fix a spelling mistake
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210607063819.377166-1-13145886936@163.com>
References: <20210607063819.377166-1-13145886936@163.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 07 Jun 2021 13:19:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 13145886936@163.com
Date: Sun,  6 Jun 2021 23:38:19 -0700

> From: gushengxian <gushengxian@yulong.com>
> 
> iff should be changed to if.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>

'iff' is the canonical way to say 'if and only if'.

I'm not applying this, sorry.
