Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F31162089
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 06:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgBRFrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 00:47:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58472 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgBRFrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 00:47:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2789F15B47870;
        Mon, 17 Feb 2020 21:47:14 -0800 (PST)
Date:   Mon, 17 Feb 2020 21:47:13 -0800 (PST)
Message-Id: <20200217.214713.1884483376515699603.davem@davemloft.net>
To:     alex.aring@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org
Subject: Re: [PACTH net-next 5/5] net: ipv6: add rpl sr tunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217223541.18862-6-alex.aring@gmail.com>
References: <20200217223541.18862-1-alex.aring@gmail.com>
        <20200217223541.18862-6-alex.aring@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 21:47:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <alex.aring@gmail.com>
Date: Mon, 17 Feb 2020 17:35:41 -0500

> +struct rpl_iptunnel_encap {
> +	struct ipv6_rpl_sr_hdr srh[0];
> +};

We're supposed to use '[]' for zero length arrays these days.
