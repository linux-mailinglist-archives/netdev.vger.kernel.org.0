Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B45161D85
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgBQWnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:43:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgBQWnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:43:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1BCC15AA8926;
        Mon, 17 Feb 2020 14:43:15 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:43:15 -0800 (PST)
Message-Id: <20200217.144315.1807054835221825779.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/10] mlxsw: Reduce dependency between bridge
 and router code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217142940.307014-1-idosch@idosch.org>
References: <20200217142940.307014-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:43:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 17 Feb 2020 16:29:30 +0200

> This patch set reduces the dependency between the bridge and the router
> code in preparation for RTNL removal from the route insertion path in
> mlxsw.
 ...

Looks good, series applied, thank you.
