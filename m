Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC79C2D5D6
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 09:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfE2HAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 03:00:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58394 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfE2HAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 03:00:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44A9F1000478F;
        Wed, 29 May 2019 00:00:15 -0700 (PDT)
Date:   Wed, 29 May 2019 00:00:14 -0700 (PDT)
Message-Id: <20190529.000014.920973579137715506.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] macvlan: Replace strncpy() by strscpy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527183855.GA32553@embeddedor>
References: <20190527183855.GA32553@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 00:00:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Mon, 27 May 2019 13:38:55 -0500

> The strncpy() function is being deprecated. Replace it by the safer
> strscpy() and fix the following Coverity warning:
> 
> "Calling strncpy with a maximum size argument of 16 bytes on destination
> array ifrr.ifr_ifrn.ifrn_name of size 16 bytes might leave the destination
> string unterminated."
> 
> Notice that, unlike strncpy(), strscpy() always null-terminates the
> destination string.
> 
> Addresses-Coverity-ID: 1445537 ("Buffer not null terminated")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
