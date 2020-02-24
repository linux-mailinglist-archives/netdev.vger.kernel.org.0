Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6316B0A9
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgBXTz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:55:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgBXTz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:55:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3FC5120F5E06;
        Mon, 24 Feb 2020 11:55:28 -0800 (PST)
Date:   Mon, 24 Feb 2020 11:55:28 -0800 (PST)
Message-Id: <20200224.115528.28812023601108523.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 00/16] mlxsw: Introduce ACL traps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 11:55:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 24 Feb 2020 08:35:42 +0100

> This patchset allows to track packets that are dropped in HW by ACL.
> 
> Unlike the existing mlxsw traps, ACL traps are "source traps".
> That means the action is not controlled by HPKT register but directly
> in ACL TRAP action. When devlink user changes action from drop to trap
> and vice versa, it would be needed to go over all instances of ACL TRAP
> action and do change. That does not scale. Instead, resolve this
> by introducing "dummy" group with "thin" policer. The purpose of
> this policer is to drop as many packets as possible. The ones
> that pass through are going to be dropped in devlink code - patch #6
> takes care of that.
> 
> First four patches are preparation for introduction of ACL traps in mlxsw
> so it possible to easily change from drop to trap for source traps
> as well - by changing group to "dummy" and back.

Looks good, series applied, thanks Jiri.
