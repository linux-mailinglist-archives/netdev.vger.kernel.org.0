Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9902B19E156
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgDCXNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:13:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36470 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgDCXNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 19:13:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E507F121938E8;
        Fri,  3 Apr 2020 16:13:32 -0700 (PDT)
Date:   Fri, 03 Apr 2020 16:13:32 -0700 (PDT)
Message-Id: <20200403.161332.275661443627820251.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 1/2] mlxsw: spectrum_flower: Do not stop at
 FLOW_ACTION_PRIORITY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200403130010.2471710-2-idosch@idosch.org>
References: <20200403130010.2471710-1-idosch@idosch.org>
        <20200403130010.2471710-2-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Apr 2020 16:13:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri,  3 Apr 2020 16:00:09 +0300

> Fixes: cc2c43406163 ("mlxsw: spectrum_flower: Offload FLOW_ACTION_PRIORITY")

This is not a valid SHA1 ID.
