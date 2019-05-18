Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8135D224CB
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 22:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfERUOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 16:14:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfERUOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 16:14:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B979214DF47E7;
        Sat, 18 May 2019 13:14:29 -0700 (PDT)
Date:   Sat, 18 May 2019 13:14:29 -0700 (PDT)
Message-Id: <20190518.131429.872857914595038838.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 0/2] mlxsw: Two port module fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190518155829.31055-1-idosch@idosch.org>
References: <20190518155829.31055-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 May 2019 13:14:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sat, 18 May 2019 18:58:27 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 fixes driver initialization failure on old ASICs due to
> unsupported register access. This is fixed by first testing if the
> register is supported.
> 
> Patch #2 fixes reading of certain modules' EEPROM. The problem and
> solution are explained in detail in the commit message.

Series applied.

> Please consider both patches for stable.

Queued up.

Thanks!
