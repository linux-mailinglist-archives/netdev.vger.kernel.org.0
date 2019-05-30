Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B0B302CD
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfE3TbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:31:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58866 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbfE3TbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:31:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFAEF14DA8164;
        Thu, 30 May 2019 12:31:08 -0700 (PDT)
Date:   Thu, 30 May 2019 12:31:08 -0700 (PDT)
Message-Id: <20190530.123108.1504257222843559408.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net 0/2] mlxsw: Two small fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529075945.20050-1-idosch@idosch.org>
References: <20190529075945.20050-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:31:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 29 May 2019 10:59:43 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 from Jiri fixes an issue specific to Spectrum-2 where the
> insertion of two identical flower filters with different priorities
> would trigger a warning.
> 
> Patch #2 from Amit prevents the driver from trying to configure a port
> with a speed of 56Gb/s and autoneg off as this is not supported and
> results in error messages from firmware.

Series applied.

> Please consider patch #1 for stable.

Queued up, thanks.
