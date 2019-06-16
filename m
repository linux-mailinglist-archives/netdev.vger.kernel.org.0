Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B89476E7
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfFPVEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:04:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPVEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:04:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD22C151C321C;
        Sun, 16 Jun 2019 14:04:03 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:04:03 -0700 (PDT)
Message-Id: <20190616.140403.421351967333052868.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/17] mlxsw: Improve IPv6 route insertion rate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:04:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David A., please review the ipv6 notification changes.

Thank you.
