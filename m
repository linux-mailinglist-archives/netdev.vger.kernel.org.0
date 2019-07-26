Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2677736E
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfGZV1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:27:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55398 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfGZV1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:27:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A966612B8C6FA;
        Fri, 26 Jul 2019 14:27:13 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:27:13 -0700 (PDT)
Message-Id: <20190726.142713.1263306307404533175.davem@davemloft.net>
To:     sergej.benilov@googlemail.com
Cc:     venza@brownhat.org, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH] sis900: add support for ethtool's EEPROM dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725194806.17964-1-sergej.benilov@googlemail.com>
References: <20190725194806.17964-1-sergej.benilov@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:27:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergej Benilov <sergej.benilov@googlemail.com>
Date: Thu, 25 Jul 2019 21:48:06 +0200

> Implement ethtool's EEPROM dump command (ethtool -e|--eeprom-dump).
> 
> Thx to Andrew Lunn for comments.
> 
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>

Applied to net-next.
