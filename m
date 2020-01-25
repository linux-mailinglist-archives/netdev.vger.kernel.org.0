Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8015D14956D
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 13:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgAYMJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 07:09:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgAYMJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 07:09:49 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3B9E15B02E21;
        Sat, 25 Jan 2020 04:09:46 -0800 (PST)
Date:   Sat, 25 Jan 2020 13:09:39 +0100 (CET)
Message-Id: <20200125.130939.1513446387321588197.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/14] mlxsw: Offload TBF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 04:09:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 24 Jan 2020 15:23:04 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> In order to allow configuration of shapers on Spectrum family of
> machines, recognize TBF either as root Qdisc, or as a child of ETS or
> PRIO. Configure rate of maximum shaper according to TBF rate setting,
> and maximum shaper burst size according to TBF burst setting.
> 
> - Patches #1 and #2 make the TBF shaper suitable for offloading.
> - Patches #3, #4 and #5 are refactoring aimed at easier support of leaf
>   Qdiscs in general.
> - Patches #6 to #10 gradually introduce TBF offload.
> - Patches #11 to #14 add selftests.

Series applied, thank you.
