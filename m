Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5E656F5B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfFZRKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:10:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38112 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfFZRKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:10:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D10D314BEAFC3;
        Wed, 26 Jun 2019 10:10:44 -0700 (PDT)
Date:   Wed, 26 Jun 2019 10:10:42 -0700 (PDT)
Message-Id: <20190626.101042.1721198902020079543.davem@davemloft.net>
To:     ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        kgraul@linux.ibm.com, zhp@smail.nju.edu.cn, yuehaibing@huawei.com
Subject: Re: [PATCH net 0/2] net/smc: fixes 2019-06-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626154750.46127-1-ubraun@linux.ibm.com>
References: <20190626154750.46127-1-ubraun@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 10:10:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>
Date: Wed, 26 Jun 2019 17:47:48 +0200

> here are 2 small smc fixes for the net tree.

Looks good, series applied, thanks.
