Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65E7CE2C2
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfJGNJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:09:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52444 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfJGNJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:09:28 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D430C14022B34;
        Mon,  7 Oct 2019 06:09:27 -0700 (PDT)
Date:   Mon, 07 Oct 2019 15:09:26 +0200 (CEST)
Message-Id: <20191007.150926.1778843925346606216.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next] net: devlink: fix reporter dump dumpit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191007072831.11932-1-jiri@resnulli.us>
References: <20191007072831.11932-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 06:09:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon,  7 Oct 2019 09:28:31 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> In order for attrs to be prepared for reporter dump dumpit callback,
> set GENL_DONT_VALIDATE_DUMP_STRICT instead of GENL_DONT_VALIDATE_DUMP.
> 
> Fixes: ee85da535fe3 ("devlink: have genetlink code to parse the attrs during dumpit"
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks.
