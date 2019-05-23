Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB47B2823F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfEWQM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:12:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbfEWQMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:12:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 542851509A101;
        Thu, 23 May 2019 09:12:25 -0700 (PDT)
Date:   Thu, 23 May 2019 09:12:24 -0700 (PDT)
Message-Id: <20190523.091224.738906988263788675.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com
Subject: Re: [patch net-next v2] devlink: add warning in case driver does
 not set port type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523084335.5205-1-jiri@resnulli.us>
References: <20190523084335.5205-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:12:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 23 May 2019 10:43:35 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Prevent misbehavior of drivers who would not set port type for longer
> period of time. Drivers should always set port type. Do WARN if that
> happens.
> 
> Note that it is perfectly fine to temporarily not have the type set,
> during initialization and port type change.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v1->v2:
> - Don't warn on DSA and CPU ports.

Applied.
