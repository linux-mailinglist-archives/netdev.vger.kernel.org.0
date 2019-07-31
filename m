Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E677D1A0
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbfGaW7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:59:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbfGaW7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:59:11 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9625E1264F782;
        Wed, 31 Jul 2019 15:59:10 -0700 (PDT)
Date:   Wed, 31 Jul 2019 18:59:10 -0400 (EDT)
Message-Id: <20190731.185910.13720278779676577.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 0/3] net: devlink: Finish network namespace
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730085734.31504-1-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 15:59:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 30 Jul 2019 10:57:31 +0200

> Devlink from the beginning counts with network namespaces, but the
> instances has been fixed to init_net. The first patch allows user
> to move existing devlink instances into namespaces:
 ...

I read this thread and see there will be a v3.
