Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C884A304AF
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE3WSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:18:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33130 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3WSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:18:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B17CF14DD4FAA;
        Thu, 30 May 2019 15:18:04 -0700 (PDT)
Date:   Thu, 30 May 2019 15:18:04 -0700 (PDT)
Message-Id: <20190530.151804.1553728286012545364.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, dlebrun@google.com, tom@quantonium.net
Subject: Re: [PATCH net-next 1/6] seg6: Fix TLV definitions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559253021-16772-2-git-send-email-tom@quantonium.net>
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
        <1559253021-16772-2-git-send-email-tom@quantonium.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 15:18:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Thu, 30 May 2019 14:50:16 -0700

> TLV constants are defined for PAD1, PADN, and HMAC (the three defined in
> draft-ietf-6man-segment-routing-header-19). The other TLV are unused and
> not correct so they are removed.

Removing macros will break userland compilation, you cannot do this.
