Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC561DA14B
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgESTtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:49:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D658C08C5C0;
        Tue, 19 May 2020 12:49:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EF14128BFAE0;
        Tue, 19 May 2020 12:49:01 -0700 (PDT)
Date:   Tue, 19 May 2020 12:49:00 -0700 (PDT)
Message-Id: <20200519.124900.1271332249104138126.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net-next 0/2] s390/net: updates 2020-05-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519190904.64217-1-jwi@linux.ibm.com>
References: <20200519190904.64217-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 12:49:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 19 May 2020 21:09:02 +0200

> please apply the following patch series to netdev's net-next tree.
> 
> s390 dropped its support for power management, this removes the relevant
> code from the s390 network drivers.

Series applied.
