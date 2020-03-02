Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B0317637D
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbgCBTKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:10:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52400 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgCBTKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 14:10:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF59F1445D075;
        Mon,  2 Mar 2020 11:10:19 -0800 (PST)
Date:   Mon, 02 Mar 2020 11:10:16 -0800 (PST)
Message-Id: <20200302.111016.387767595090308633.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [PATCH 0/7] octeontx2: Flow control support and other misc
 changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Mar 2020 11:10:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Mon,  2 Mar 2020 12:49:21 +0530

> From: Sunil Goutham <sgoutham@marvell.com>
> 
> This patch series adds flow control support (802.3 pause frames) and
> has other changes wrt generic admin function (AF) driver functionality.

Series applied, thanks.
