Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A883319048B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgCXElG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:41:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56318 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXElF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:41:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F83B15799EB3;
        Mon, 23 Mar 2020 21:41:05 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:41:04 -0700 (PDT)
Message-Id: <20200323.214104.1464515066908068847.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/5] devlink: Preparations for trap policers
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200322184830.1254104-1-idosch@idosch.org>
References: <20200322184830.1254104-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:41:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 22 Mar 2020 20:48:25 +0200

> This patch set prepares the code for devlink-trap policer support in a
> follow-up patch set [1][2]. No functional changes intended.
 ...

Series applied, thanks.
