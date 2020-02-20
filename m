Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7311A166AAF
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgBTXCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:02:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgBTXCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:02:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F08015BCCC5D;
        Thu, 20 Feb 2020 15:02:48 -0800 (PST)
Date:   Thu, 20 Feb 2020 15:02:47 -0800 (PST)
Message-Id: <20200220.150247.903453014938361659.davem@davemloft.net>
To:     alex.aring@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org
Subject: Re: [PACTH net-next 5/5] net: ipv6: add rpl sr tunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219144137.omzmzgfs33fmb6yg@ryzen>
References: <20200217223541.18862-6-alex.aring@gmail.com>
        <20200217.214713.1884483376515699603.davem@davemloft.net>
        <20200219144137.omzmzgfs33fmb6yg@ryzen>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 15:02:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <alex.aring@gmail.com>
Date: Wed, 19 Feb 2020 09:41:37 -0500

> Can we make an exception here? I can remove it but then I need to
> introduce the same code again when we introduce new fields in UAPI for
> this tunnel.

Ok, please resubmit.
