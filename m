Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D6217CC7E
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 07:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgCGGeX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 7 Mar 2020 01:34:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40986 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgCGGeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:34:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCE4415528E33;
        Fri,  6 Mar 2020 22:34:22 -0800 (PST)
Date:   Fri, 06 Mar 2020 22:33:55 -0800 (PST)
Message-Id: <20200306.223355.168471543129088317.davem@davemloft.net>
To:     j.neuschaefer@gmx.net
Cc:     netdev@vger.kernel.org, tgraf@suug.ch, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rhashtable: Document the right function parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305160516.10396-1-j.neuschaefer@gmx.net>
References: <20200305160516.10396-1-j.neuschaefer@gmx.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 22:34:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Date: Thu,  5 Mar 2020 17:05:16 +0100

> rhashtable_lookup_get_insert_key doesn't have a parameter `data`. It
> does have a parameter `key`, however.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Applied, thank you.
