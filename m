Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF63193100
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCYTUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:20:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgCYTUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:20:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B527615A09711;
        Wed, 25 Mar 2020 12:20:19 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:20:18 -0700 (PDT)
Message-Id: <20200325.122018.434516835633932505.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [PATCH net-next 0/2] Miscellaneous fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585136477-16629-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1585136477-16629-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 12:20:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Wed, 25 Mar 2020 17:11:15 +0530

> From: Sunil Goutham <sgoutham@marvell.com>
> 
> This patchset fixes couple of issues related to missing
> page refcount updation and taking a mutex lock in atomic
> context.

Series applied, thanks Sunil.
