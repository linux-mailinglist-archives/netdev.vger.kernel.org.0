Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F1E433EFD
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhJSTJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234876AbhJSTJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 15:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A4D76101A;
        Tue, 19 Oct 2021 19:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634670445;
        bh=HaUgFa7ZDveIyObp/cXpK7mjo1xVVWIUnROJaQjyCDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lv4ZuE2dNjZ7BhmzM/CwPcZ1HTJZ0DpCuwSRiGqEfX9gBxoo3yXHirGGg34++hx54
         VL5nIzqRGK+AmEcTwDp9sr+jn/dlNSjjaA3RMXtl16t0rzryHftQHAGSX0D74ktK4D
         cdF0AQAyStQHXno4+ecCMwMW7sgWDyVfW7PGc1U6f9k3pAPpAUJEjPYYCSZkyn36SK
         jwxSvhlZljt0fO4urkF7uZFVkJ2DHpaFt5qCo26PX2RlEiAfjgH/nNlE3AnlyRZLgX
         Aa7qD2G0M8HK1evEUL4qHTMkIMuiCpqoAZrURiZ2G6txLyOKIL+mxkrihNlmiz2BDN
         VMkYKI+Zbz5KQ==
Date:   Tue, 19 Oct 2021 12:07:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kumar Thangavel <kumarthangavel.hcl@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        patrickw3@fb.com, Amithash Prasad <amithash@fb.com>,
        velumanit@hcl.com, sdasari@fb.com
Subject: Re: [PATCH v2] Add payload to be 32-bit aligned to fix dropped
 packets
Message-ID: <20211019120724.50776b81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211019144127.GA12978@gmail.com>
References: <20211019144127.GA12978@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 20:11:27 +0530 Kumar Thangavel wrote:
> +	payload = ALIGN(nca->payload, 4)

This is missing a semicolon.
