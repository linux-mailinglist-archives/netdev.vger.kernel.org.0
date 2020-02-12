Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65C0159E80
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 02:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgBLBHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 20:07:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgBLBHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 20:07:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14659151A1868;
        Tue, 11 Feb 2020 17:07:22 -0800 (PST)
Date:   Tue, 11 Feb 2020 17:07:21 -0800 (PST)
Message-Id: <20200211.170721.1119133630862180946.davem@davemloft.net>
To:     raeds@mellanox.com
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ESP: Export esp_output_fill_trailer function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581409202-23654-1-git-send-email-raeds@mellanox.com>
References: <1581409202-23654-1-git-send-email-raeds@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Feb 2020 17:07:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>
Date: Tue, 11 Feb 2020 10:20:02 +0200

> The esp fill trailer method is identical for both
> IPv6 and IPv4.
> 
> Share the implementation for esp6 and esp to avoid
> code duplication in addition it could be also used
> at various drivers code.
> 
> Change-Id: Iebb4325fe12ef655a5cd6cb896cf9eed68033979
> Signed-off-by: Raed Salem <raeds@mellanox.com>
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

net-next is closed, please resubmit this when it opens back up
