Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4520742DB3
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387846AbfFLRvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:51:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387793AbfFLRvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:51:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3FAA1527DCD5;
        Wed, 12 Jun 2019 10:51:16 -0700 (PDT)
Date:   Wed, 12 Jun 2019 10:51:14 -0700 (PDT)
Message-Id: <20190612.105114.943734766905038441.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: lock mutex in
 port_fdb_dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612164247.29921-1-vivien.didelot@gmail.com>
References: <20190612164247.29921-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 10:51:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Wed, 12 Jun 2019 12:42:47 -0400

> During a port FDB dump operation, the mutex protecting the concurrent
> access to the switch registers is currently held by the internal
> mv88e6xxx_port_db_dump and mv88e6xxx_port_db_dump_fid helpers.
> 
> It must be held at the higher level in mv88e6xxx_port_fdb_dump which
> is called directly by DSA through ds->ops->port_fdb_dump. Fix this.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied.
