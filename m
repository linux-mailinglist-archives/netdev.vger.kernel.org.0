Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7E3A9F57
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbfIEKPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:15:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732839AbfIEKPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:15:04 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31818153878EF;
        Thu,  5 Sep 2019 03:15:03 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:15:01 +0200 (CEST)
Message-Id: <20190905.121501.265250732304897732.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next] rocker: add missing init_net check in FIB
 notifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190904074047.840-1-jiri@resnulli.us>
References: <20190904074047.840-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:15:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Wed,  4 Sep 2019 09:40:47 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Take only FIB events that are happening in init_net into account. No other
> namespaces are supported.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.
