Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F41E16208A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 06:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgBRFsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 00:48:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgBRFsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 00:48:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEF9A15B47879;
        Mon, 17 Feb 2020 21:48:40 -0800 (PST)
Date:   Mon, 17 Feb 2020 21:48:40 -0800 (PST)
Message-Id: <20200217.214840.486235315714211732.davem@davemloft.net>
To:     festevam@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next] net: fec: Use a proper ID allocation scheme
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217223651.22688-1-festevam@gmail.com>
References: <20200217223651.22688-1-festevam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 21:48:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 17 Feb 2020 19:36:51 -0300

> Instead of using such poor mechanism for counting the network interfaces
> IDs, use a proper allocation scheme, such as IDR.
> 
> This fixes the network behavior after unbind/bind.

What about:

1) unbind fec0
2) unbind fec1
3) bind fec0

It doesn't work even with the IDR scheme.
