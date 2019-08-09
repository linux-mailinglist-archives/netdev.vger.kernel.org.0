Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1751887170
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405327AbfHIF1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:27:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56102 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfHIF1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:27:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 199A2142CA477;
        Thu,  8 Aug 2019 22:27:33 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:27:32 -0700 (PDT)
Message-Id: <20190808.222732.563146255819689430.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next] mlxsw: spectrum: Extend to support Spectrum-3
 ASIC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190807104231.16085-1-idosch@idosch.org>
References: <20190807104231.16085-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:27:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed,  7 Aug 2019 13:42:31 +0300

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Extend existing driver for Spectrum and Spectrum-2 ASICs
> to support Spectrum-3 ASIC as well.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied.
