Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B901B16208C
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 06:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgBRFvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 00:51:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgBRFvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 00:51:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B81715B47880;
        Mon, 17 Feb 2020 21:51:39 -0800 (PST)
Date:   Mon, 17 Feb 2020 21:51:38 -0800 (PST)
Message-Id: <20200217.215138.30487653437477925.davem@davemloft.net>
To:     hauke@hauke-m.de
Cc:     linux@rempel-privat.de, netdev@vger.kernel.org, jcliburn@gmail.com,
        chris.snook@gmail.com
Subject: Re: [PATCH 3/3] ag71xx: Run ag71xx_link_adjust() only when needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217233518.3159-3-hauke@hauke-m.de>
References: <20200217233518.3159-1-hauke@hauke-m.de>
        <20200217233518.3159-3-hauke@hauke-m.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 21:51:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 18 Feb 2020 00:35:18 +0100

> +		if (ag->duplex != phydev->duplex ||
> +		    ag->speed != phydev->speed) {
> +			status_change = 1;
> +		}

A single statement basic block should not be enclosed in curly
braces.

Thank you.
