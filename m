Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA958169B21
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 01:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBXANP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 19:13:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBXANO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 19:13:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26303158D77F8;
        Sun, 23 Feb 2020 16:13:14 -0800 (PST)
Date:   Sun, 23 Feb 2020 16:13:11 -0800 (PST)
Message-Id: <20200223.161311.2119739902658169966.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 00/12] mlxsw: Cosmetic fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 16:13:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sun, 23 Feb 2020 08:31:32 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> This is a set of mainly action/trap related cosmetic fixes.
> No functional changes.

Series applied, thanks Jiri.

The final patch removing unused PCI values didn't apply cleanly and
had some fuzz...
