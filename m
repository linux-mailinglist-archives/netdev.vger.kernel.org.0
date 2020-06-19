Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9402000BC
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgFSD2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgFSD2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:28:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B39C06174E;
        Thu, 18 Jun 2020 20:28:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C597120ED49C;
        Thu, 18 Jun 2020 20:28:00 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:27:59 -0700 (PDT)
Message-Id: <20200618.202759.2208335891359562794.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net 0/2] s390/qeth: fixes 2020-06-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200617145453.61382-1-jwi@linux.ibm.com>
References: <20200617145453.61382-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:28:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed, 17 Jun 2020 16:54:51 +0200

> please apply the following patch series for qeth to netdev's net tree.
> 
> The first patch fixes a regression in the error handling for a specific
> cmd type. I have some follow-ups queued up for net-next to clean this
> up properly...
> 
> The second patch fine-tunes the HW offload restrictions that went in
> with this merge window. In some setups we don't need to apply them.

Series applied, thanks.
