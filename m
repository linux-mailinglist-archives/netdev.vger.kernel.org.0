Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0C10677A
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 09:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfKVIEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 03:04:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59888 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfKVIEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 03:04:49 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5858E151671AB;
        Fri, 22 Nov 2019 00:04:48 -0800 (PST)
Date:   Fri, 22 Nov 2019 00:04:45 -0800 (PST)
Message-Id: <20191122.000445.1997368266185172608.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net,v2 0/2] Fix send indirection table offset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
References: <1574372021-29439-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 00:04:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 21 Nov 2019 13:33:39 -0800

> Fix send indirection table offset issues related to guest and
> host bugs.

Series applied, thank you.
