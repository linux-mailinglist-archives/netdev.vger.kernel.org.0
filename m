Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE7A12CAC3
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 21:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfL2UaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 15:30:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfL2UaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 15:30:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1640115513BDC;
        Sun, 29 Dec 2019 12:30:23 -0800 (PST)
Date:   Sun, 29 Dec 2019 12:30:20 -0800 (PST)
Message-Id: <20191229.123020.38816178473276472.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net 0/2] mlxsw: Couple of fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191229114023.60873-1-idosch@idosch.org>
References: <20191229114023.60873-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Dec 2019 12:30:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 29 Dec 2019 13:40:21 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set contains two fixes for mlxsw. Please consider both for
> stable.
> 
> Patch #1 from Amit fixes a wrong check during MAC validation when
> creating router interfaces (RIFs). Given a particular order of
> configuration this can result in the driver refusing to create new RIFs.
> 
> Patch #2 fixes a wrong trap configuration in which VRRP packets and
> routing exceptions were policed by the same policer towards the CPU. In
> certain situations this can prevent VRRP packets from reaching the CPU.

Series applied and queued up for -stable.
