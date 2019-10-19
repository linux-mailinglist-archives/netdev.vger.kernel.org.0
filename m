Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EFFDDAAC
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfJSTUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:20:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:20:32 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE0D31493C20E;
        Sat, 19 Oct 2019 12:20:31 -0700 (PDT)
Date:   Sat, 19 Oct 2019 12:20:31 -0700 (PDT)
Message-Id: <20191019.122031.2164922400722296846.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net] net: dsa: fix switch tree list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191018210246.3018693-1-vivien.didelot@gmail.com>
References: <20191018210246.3018693-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 19 Oct 2019 12:20:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Fri, 18 Oct 2019 17:02:46 -0400

> If there are multiple switch trees on the device, only the last one
> will be listed, because the arguments of list_add_tail are swapped.
> 
> Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied and queued up for-stable, thanks Vivien.
