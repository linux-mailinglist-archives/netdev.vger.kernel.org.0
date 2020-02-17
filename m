Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB338161D30
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgBQWKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:10:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgBQWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:10:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68A7315AA10A1;
        Mon, 17 Feb 2020 14:10:49 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:10:48 -0800 (PST)
Message-Id: <20200217.141048.111506203898917128.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     lorenzo@kernel.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: Re: [PATCH net-next 0/5] add xdp ethtool stats to mvneta driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217105825.51e6c9cd@carbon>
References: <cover.1581886691.git.lorenzo@kernel.org>
        <20200216.200457.998100759872108395.davem@davemloft.net>
        <20200217105825.51e6c9cd@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:10:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 17 Feb 2020 10:58:25 +0100

> And I have issues with the patches...

We can fix them up in follow-on patches, the merge window isn't tomorrow :-)
