Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F05282785
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgJDAFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgJDAFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:05:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA6BC0613D0;
        Sat,  3 Oct 2020 17:05:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23E4211E3E4CA;
        Sat,  3 Oct 2020 16:48:52 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:05:38 -0700 (PDT)
Message-Id: <20201003.170538.1607088552412478587.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 1/2] net/smc: send ISM devices with unique
 chid in CLC proposal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002150927.72261-2-kgraul@linux.ibm.com>
References: <20201002150927.72261-1-kgraul@linux.ibm.com>
        <20201002150927.72261-2-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:48:52 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Fri,  2 Oct 2020 17:09:26 +0200

> When building a CLC proposal message then the list of ISM devices does
> not need to contain multiple devices that have the same chid value,
> all these devices use the same function at the end.
> Improve smc_find_ism_v2_device_clnt() to collect only ISM devices that
> have unique chid values.
> 
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Series applied, but could you send a proper patch series in the future
with a "[PATCH 0/N] ..." header posting?  It must explain what the
patch series does at a high level, how it is doing it, and why it is
doing it that way.

Thank you.
