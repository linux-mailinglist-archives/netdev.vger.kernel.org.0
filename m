Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3F161D5F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgBQWfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:35:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56216 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgBQWfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:35:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E230415AA818B;
        Mon, 17 Feb 2020 14:35:46 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:35:46 -0800 (PST)
Message-Id: <20200217.143546.270027392633183186.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] couple more ARFS tidy-ups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3d83a647-beb0-6de7-39f7-c960e3299dc7@solarflare.com>
References: <3d83a647-beb0-6de7-39f7-c960e3299dc7@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:35:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Mon, 17 Feb 2020 13:42:04 +0000

> Tie up some loose ends from the recent ARFS work.

Series applied, thank you.
