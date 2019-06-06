Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B1E369C6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 04:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfFFCGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 22:06:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfFFCGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 22:06:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5E8214022CE5;
        Wed,  5 Jun 2019 19:06:02 -0700 (PDT)
Date:   Wed, 05 Jun 2019 19:06:02 -0700 (PDT)
Message-Id: <20190605.190602.917502036561158709.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com
Subject: Re: [PATCH v2 net-next 0/2] ipv6: tcp: more control on RST
 flowlabels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605145510.74527-1-edumazet@google.com>
References: <20190605145510.74527-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 19:06:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  5 Jun 2019 07:55:08 -0700

> First patch allows to reflect incoming IPv6 flowlabel
> on RST packets sent when no socket could handle the packet.
> 
> Second patch makes sure we send the same flowlabel
> for RST or ACK packets on behalf of TIME_WAIT sockets.

Series applied, thanks Eric.
