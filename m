Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 325E112D62B
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfLaEen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:34:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50528 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaEen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:34:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A11EB1404841F;
        Mon, 30 Dec 2019 20:34:42 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:34:42 -0800 (PST)
Message-Id: <20191230.203442.69341487993928315.davem@davemloft.net>
To:     vijaykhemka@fb.com
Cc:     sam@mendozajonas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au,
        linux-aspeed@lists.ozlabs.org, sdasari@fb.com
Subject: Re: [net-next PATCH] net/ncsi: Fix gma flag setting after response
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227224349.2182366-1-vijaykhemka@fb.com>
References: <20191227224349.2182366-1-vijaykhemka@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:34:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vijay Khemka <vijaykhemka@fb.com>
Date: Fri, 27 Dec 2019 14:43:49 -0800

> gma_flag was set at the time of GMA command request but it should
> only be set after getting successful response. Movinng this flag
> setting in GMA response handler.
> 
> This flag is used mainly for not repeating GMA command once
> received MAC address.
> 
> Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>

Applied.
