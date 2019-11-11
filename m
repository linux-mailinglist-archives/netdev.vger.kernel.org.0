Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C302F9A58
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfKLUMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:12:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfKLUMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:12:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6150154D23BE;
        Tue, 12 Nov 2019 12:12:07 -0800 (PST)
Date:   Mon, 11 Nov 2019 14:41:43 -0800 (PST)
Message-Id: <20191111.144143.1922066976980512193.davem@davemloft.net>
To:     mschiffer@universe-factory.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next 2/2] bridge: implement get_link_ksettings
 ethtool method
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8e414e98928aba7f11ea997498fb18af05434f5f.1573321597.git.mschiffer@universe-factory.net>
References: <cover.1573321597.git.mschiffer@universe-factory.net>
        <8e414e98928aba7f11ea997498fb18af05434f5f.1573321597.git.mschiffer@universe-factory.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:12:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <mschiffer@universe-factory.net>
Date: Sat,  9 Nov 2019 18:54:14 +0100

> +		if (cmd->base.speed == (__u32)SPEED_UNKNOWN ||
> +		    cmd->base.speed < ecmd.base.speed) {
> +			cmd->base.speed = ecmd.base.speed;
> +		}

Curly braces are unnecessary for single line statements, so please remove.
