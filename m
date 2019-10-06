Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0508CD388
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfJFQax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:30:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfJFQax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 12:30:53 -0400
Received: from localhost (unknown [8.46.76.29])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5E77145AE067;
        Sun,  6 Oct 2019 09:30:47 -0700 (PDT)
Date:   Sun, 06 Oct 2019 18:30:39 +0200 (CEST)
Message-Id: <20191006.183039.308145593425594458.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 0/2] netdevsim: allow to test reload failures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191006063002.28860-1-jiri@resnulli.us>
References: <20191006063002.28860-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 06 Oct 2019 09:30:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sun,  6 Oct 2019 08:30:00 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Allow user to test devlink reload failures: Fail to reload and fail
> during reload.

Series applied.
