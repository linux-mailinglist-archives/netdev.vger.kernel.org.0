Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96D7198306
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgC3SJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:09:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgC3SJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:09:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5641615C494E0;
        Mon, 30 Mar 2020 11:09:35 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:09:34 -0700 (PDT)
Message-Id: <20200330.110934.1554363546518268403.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com
Subject: Re: [patch net-next] net: devlink: use NL_SET_ERR_MSG_MOD instead
 of NL_SET_ERR_MSG
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200328182529.12041-1-jiri@resnulli.us>
References: <20200328182529.12041-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:09:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat, 28 Mar 2020 19:25:29 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> The rest of the devlink code sets the extack message using
> NL_SET_ERR_MSG_MOD. Change the existing appearances of NL_SET_ERR_MSG
> to NL_SET_ERR_MSG_MOD.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.
