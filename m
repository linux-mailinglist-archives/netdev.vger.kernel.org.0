Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1647E50E06
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfFXOaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:30:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfFXOaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:30:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B89C515041427;
        Mon, 24 Jun 2019 07:30:03 -0700 (PDT)
Date:   Mon, 24 Jun 2019 07:30:03 -0700 (PDT)
Message-Id: <20190624.073003.79543061561048819.davem@davemloft.net>
To:     john.rutherford@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: fix missing indentation in source code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624040123.32337-1-john.rutherford@dektech.com.au>
References: <20190624040123.32337-1-john.rutherford@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 07:30:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Rutherford <john.rutherford@dektech.com.au>
Date: Mon, 24 Jun 2019 14:01:23 +1000

> Fix misalignment of policy statement in netlink.c due to automatic
> spatch code transformation.
> 
> Fixes: 3b0f31f2b8c9 ("genetlink: make policy common to family")
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>

Applied.
