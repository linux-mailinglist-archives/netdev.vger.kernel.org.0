Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940A286F1A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405171AbfHIBHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:07:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729418AbfHIBHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:07:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6195F1425E497;
        Thu,  8 Aug 2019 18:07:18 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:07:17 -0700 (PDT)
Message-Id: <20190808.180717.1293887697093806627.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     corbet@lwn.net, linux-dog@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: docs: replace IPX in tuntap documentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805223003.13444-2-stephen@networkplumber.org>
References: <20190805223003.13444-1-stephen@networkplumber.org>
        <20190805223003.13444-2-stephen@networkplumber.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:07:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Mon,  5 Aug 2019 15:30:03 -0700

> IPX is no longer supported, but the example in the documentation
> might useful. Replace it with IPv6.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied.
