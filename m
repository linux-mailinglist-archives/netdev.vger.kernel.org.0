Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCD93B7809
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhF2Syn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:54:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38028 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbhF2Syn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 14:54:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E25894F7C60DB;
        Tue, 29 Jun 2021 11:52:13 -0700 (PDT)
Date:   Tue, 29 Jun 2021 11:52:13 -0700 (PDT)
Message-Id: <20210629.115213.547056454675149348.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, tobias@waldekranz.com, roopa@nvidia.com,
        nikolay@nvidia.com, bridge@lists.linux-foundation.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v5 net-next 00/15] RX filtering in DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 29 Jun 2021 11:52:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 29 Jun 2021 17:06:43 +0300

> Changes in v5:
> - added READ_ONCE and WRITE_ONCE for fdb->dst
> - removed a paranoid WARN_ON in DSA
> - added some documentation regarding how 'bridge fdb' is supposed to be
>   used with DSA

Vlad, I applied v4, could you please send me relative fixups to v5?

Thank you.
