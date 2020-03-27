Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31301960D9
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgC0WHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:07:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0WHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:07:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FD6D15B718AE;
        Fri, 27 Mar 2020 15:07:05 -0700 (PDT)
Date:   Fri, 27 Mar 2020 15:07:04 -0700 (PDT)
Message-Id: <20200327.150704.46582365904452715.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/6] mlxsw: Various static checkers fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327085525.1906170-1-idosch@idosch.org>
References: <20200327085525.1906170-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 15:07:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 27 Mar 2020 11:55:19 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Jakub told me he gets some warnings with W=1, so I decided to check with
> sparse, smatch and coccinelle as well. This patch set fixes all the
> issues found. None are actual bugs / regressions and therefore not
> targeted at net.
> 
> Patches #1-#2 add missing kernel-doc comments.
> 
> Patch #3 removes dead code.
> 
> Patch #4 reworks the ACL code to avoid defining a static variable in a
> header file.
> 
> Patch #5 removes unnecessary conversion to bool that coccinelle warns
> about.
> 
> Patch #6 avoids false-positive uninitialized symbol errors emitted by
> smatch.

Series applied, thanks Ido.
