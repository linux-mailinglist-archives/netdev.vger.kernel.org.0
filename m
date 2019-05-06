Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7A814431
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfEFE5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:57:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59852 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfEFE5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:57:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FCF112DED1C2;
        Sun,  5 May 2019 21:57:10 -0700 (PDT)
Date:   Sun, 05 May 2019 21:57:09 -0700 (PDT)
Message-Id: <20190505.215709.2008766174730012036.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/3] mlxsw: spectrum: Implement loopback
 ethtool feature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505064807.27925-1-idosch@idosch.org>
References: <20190505064807.27925-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:57:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun,  5 May 2019 09:48:04 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset from Jiri allows users to enable loopback feature for
> individual ports using ethtool. The loopback feature is useful for
> testing purposes and will also be used by upcoming patchsets to enable
> the monitoring of buffer drops.
> 
> Patch #1 adds the relevant device register.
> 
> Patch #2 Implements support in the driver.
> 
> Patch #3 adds a selftest.

Series applied.
