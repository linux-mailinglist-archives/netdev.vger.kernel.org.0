Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B38C16093D
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBQDuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:50:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48472 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:50:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DD037157D8A57;
        Sun, 16 Feb 2020 19:50:11 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:50:11 -0800 (PST)
Message-Id: <20200216.195011.1957708776020037227.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH -net] skbuff: remove stale bit mask comments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <677a95d0-0db9-edec-0fa5-d7d3e1b5ec11@infradead.org>
References: <677a95d0-0db9-edec-0fa5-d7d3e1b5ec11@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:50:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 15 Feb 2020 13:41:12 -0800

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Remove stale comments since this flag is no longer a bit mask
> but is a bit field.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied.
