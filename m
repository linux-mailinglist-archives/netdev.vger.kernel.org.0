Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C734220055
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgGNVyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgGNVyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:54:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E08C061755;
        Tue, 14 Jul 2020 14:54:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 439B915E442E7;
        Tue, 14 Jul 2020 14:54:05 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:54:04 -0700 (PDT)
Message-Id: <20200714.145404.1649791951202238667.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net-next 00/10] s390/qeth: updates 2020-07-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714142305.29297-1-jwi@linux.ibm.com>
References: <20200714142305.29297-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 14:54:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 14 Jul 2020 16:22:55 +0200

> please apply the following patch series for qeth to netdev's net-next tree.
> 
> This brings a mix of cleanups for various parts of the control code.

Series applied, thanks Julian.
