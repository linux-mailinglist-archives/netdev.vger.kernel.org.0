Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355CDB267D
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfIMULd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 16:11:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388568AbfIMULd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 16:11:33 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06E911539B81C;
        Fri, 13 Sep 2019 13:11:30 -0700 (PDT)
Date:   Fri, 13 Sep 2019 21:11:29 +0100 (WEST)
Message-Id: <20190913.211129.1266866051992239581.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 0/3] net: devlink: move reload fail
 indication to devlink core and expose to user
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912084946.7468-1-jiri@resnulli.us>
References: <20190912084946.7468-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 13:11:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 12 Sep 2019 10:49:43 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> First two patches are dependencies of the last one. That moves devlink
> reload failure indication to the devlink code, so the drivers do not
> have to track it themselves. Currently it is only mlxsw, but I will send
> a follow-up patchset that introduces this in netdevsim too.

Series applied.
