Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE7D195C4
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfEIXl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:41:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfEIXl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:41:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BC5A14DE9A9A;
        Thu,  9 May 2019 16:41:57 -0700 (PDT)
Date:   Thu, 09 May 2019 16:41:56 -0700 (PDT)
Message-Id: <20190509.164156.1037503742659881023.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net] nfp: add missing kdoc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509231934.13103-1-jakub.kicinski@netronome.com>
References: <20190509231934.13103-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 16:41:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu,  9 May 2019 16:19:34 -0700

> Add missing kdoc for app member.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Applied, thanks Jakub.
