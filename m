Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 238F7F9926
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKLSyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:54:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47708 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLSyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:54:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCAD9154CC5AC;
        Tue, 12 Nov 2019 10:54:21 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:54:21 -0800 (PST)
Message-Id: <20191112.105421.1175237105425742696.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, shalomt@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next v2 0/7] mlxsw: Add extended ACK for EMADs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112064830.27002-1-idosch@idosch.org>
References: <20191112064830.27002-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 10:54:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 12 Nov 2019 08:48:23 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Shalom says:
> 
> Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
> the driver and device's firmware. They are used to pass various
> configurations to the device, but also to get events (e.g., port up)
> from it. After the Ethernet header, these packets are built in a TLV
> format.
> 
> Up until now, whenever the driver issued an erroneous register access it
> only got an error code indicating a bad parameter was used. This patch
> set adds a new TLV (string TLV) that can be used by the firmware to
> encode a 128 character string describing the error. The new TLV is
> allocated by the driver and set to zeros. In case of error, the driver
> will check the length of the string in the response and report it using
> devlink hwerr tracepoint.
 ...

Series applied, thank you.
