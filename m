Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D712D5DA
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 09:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE2HBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 03:01:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58404 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfE2HBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 03:01:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 208781478A005;
        Wed, 29 May 2019 00:01:46 -0700 (PDT)
Date:   Wed, 29 May 2019 00:01:45 -0700 (PDT)
Message-Id: <20190529.000145.29235432566162518.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next 0/2] qed*: Fix inifinite spinning of PTP poll
 thread.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528032133.5745-1-skalluru@marvell.com>
References: <20190528032133.5745-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 00:01:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Mon, 27 May 2019 20:21:31 -0700

> The patch series addresses an error scenario in the PTP Tx implementation.
> 
> Please consider applying it to net-next.

Series applied.
