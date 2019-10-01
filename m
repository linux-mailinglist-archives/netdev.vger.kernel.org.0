Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2002AC42FB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfJAVvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:51:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfJAVvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:51:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF28811F5F8BB;
        Tue,  1 Oct 2019 14:51:38 -0700 (PDT)
Date:   Tue, 01 Oct 2019 14:51:35 -0700 (PDT)
Message-Id: <20191001.145135.250803701681433413.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 0/7] net: introduce alternative names for
 network interfaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 14:51:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 30 Sep 2019 11:48:13 +0200

> This patchset introduces alternative names for network interfaces.
> Main goal is to:
> 1) Overcome the IFNAMSIZ limitation (altname limitation is 128 bytes)
> 2) Allow to have multiple names at the same time (multiple udev patterns)
> 3) Allow to use alternative names as handle for commands

Ok, let's see where this goes.

Series applied, thanks Jiri.
