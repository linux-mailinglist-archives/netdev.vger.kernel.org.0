Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC91CC5B6
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbfJDWPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:15:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59536 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730367AbfJDWPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 18:15:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E14914A6FD4C;
        Fri,  4 Oct 2019 15:15:35 -0700 (PDT)
Date:   Fri, 04 Oct 2019 15:15:34 -0700 (PDT)
Message-Id: <20191004.151534.1526685419014118626.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        andrew@lunn.ch, mlxsw@mellanox.com
Subject: Re: [patch net-next] net: devlink: don't ignore errors during
 dumpit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004095012.1287-1-jiri@resnulli.us>
References: <20191004095012.1287-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 15:15:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri,  4 Oct 2019 11:50:12 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, some dumpit function may end-up with error which is not
> -EMSGSIZE and this error is silently ignored. Use does not have clue
> that something wrong happened. Instead of silent ignore, propagate
> the error to user.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.
