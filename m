Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579FD1361DD
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 21:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgAIUgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 15:36:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgAIUgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 15:36:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6600142612C2;
        Thu,  9 Jan 2020 12:36:09 -0800 (PST)
Date:   Thu, 09 Jan 2020 12:36:07 -0800 (PST)
Message-Id: <20200109.123607.2038626978504581745.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/2] mlxsw: Firmware version updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109192722.297496-1-idosch@idosch.org>
References: <20200109192722.297496-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 12:36:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  9 Jan 2020 21:27:20 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch sets contains two firmware-related updates.
> 
> Patch #1 bumps the required firmware version in order to support 2x50
> Gb/s split on SN3800 systems.
> 
> Patch #2 changes the driver to only enforce a minimum required firmware
> version, which should allow us to reduce the frequency in which we need
> to update the driver.

Series applied, thanks Ido.
