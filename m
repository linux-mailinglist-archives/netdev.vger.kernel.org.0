Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CF919FB26
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgDFRPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:15:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgDFRPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 13:15:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8C3815DA2268;
        Mon,  6 Apr 2020 10:15:29 -0700 (PDT)
Date:   Mon, 06 Apr 2020 10:15:28 -0700 (PDT)
Message-Id: <20200406.101528.341697434340865081.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net v2 0/2] mlxsw: spectrum_flower: Do not stop at
 FLOW_ACTION_{VLAN_MANGLE, PRIORITY}
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200405065022.2578662-1-idosch@idosch.org>
References: <20200405065022.2578662-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Apr 2020 10:15:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun,  5 Apr 2020 09:50:20 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> The handlers for FLOW_ACTION_VLAN_MANGLE and FLOW_ACTION_PRIORITY end by
> returning whatever the lower-level function that they call returns. If
> there are more actions lined up after one of these actions, those are
> never offloaded. Each of the two patches fixes one of those actions.
> 
> v2:
> * Patch #1: Use valid SHA1 ID in Fixes line (Dave)

Series applied and patch #2 queued up for -stable, thanks.
