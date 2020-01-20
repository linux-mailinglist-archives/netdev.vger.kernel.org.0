Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74BBF142AB0
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 13:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgATM0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 07:26:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgATM0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 07:26:11 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D655514E226FC;
        Mon, 20 Jan 2020 04:26:09 -0800 (PST)
Date:   Mon, 20 Jan 2020 13:26:08 +0100 (CET)
Message-Id: <20200120.132608.557795194529925220.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/4] mlxsw: Adjust SPAN egress mirroring
 buffer size handling for Spectrum-2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120075253.3356176-1-idosch@idosch.org>
References: <20200120075253.3356176-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 04:26:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 20 Jan 2020 09:52:49 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Jiri says:
> 
> For Spectrum-2 the computation of SPAN egress mirroring buffer uses a
> different formula. On top of MTU it needs also current port speed. Fix
> the computation and also trigger the buffer size set according to PUDE
> event, which happens when port speed changes.

Series applied, thanks Ido.
