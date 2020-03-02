Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F1C1763A9
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgCBTON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:14:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbgCBTOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 14:14:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A230145A99C2;
        Mon,  2 Mar 2020 11:14:12 -0800 (PST)
Date:   Mon, 02 Mar 2020 11:14:12 -0800 (PST)
Message-Id: <20200302.111412.2263768770144326102.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [PATCH 0/3] net: thunderx: Miscellaneous changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Mar 2020 11:14:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Mon,  2 Mar 2020 15:28:59 +0530

> From: Sunil Goutham <sgoutham@marvell.com>
> 
> This patchset has changes wrt driver performance optimization,
> load time optimization. And a change to PCI device regiatration
> table for timestamp device.

Series applied, thanks Sunil.
