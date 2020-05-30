Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001521E8C85
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgE3AVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3AVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:21:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A738C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 17:21:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFC0112873741;
        Fri, 29 May 2020 17:21:21 -0700 (PDT)
Date:   Fri, 29 May 2020 17:21:20 -0700 (PDT)
Message-Id: <20200529.172120.1165761751075764286.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net] drivers/net/ibmvnic: Update VNIC protocol version
 reporting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590682757-3814-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1590682757-3814-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 17:21:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Thu, 28 May 2020 11:19:17 -0500

> VNIC protocol version is reported in big-endian format, but it
> is not byteswapped before logging. Fix that, and remove version
> comparison as only one protocol version exists at this time.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied, thanks.
