Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB551C6174
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgEET6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728135AbgEET6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:58:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A99BC061A0F;
        Tue,  5 May 2020 12:58:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A31C01280966A;
        Tue,  5 May 2020 12:58:06 -0700 (PDT)
Date:   Tue, 05 May 2020 12:58:05 -0700 (PDT)
Message-Id: <20200505.125805.2022273480111353321.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/2] log state changes and cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505130121.103272-1-kgraul@linux.ibm.com>
References: <20200505130121.103272-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 12:58:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Tue,  5 May 2020 15:01:19 +0200

> Patch 1 adds the logging of important state changes to enable SMC-R 
> users to detect SMC-R link groups that are not redundant and require
> user actions. Patch 2 is a contribution to clean up an unused inline 
> function.

Please use an appropriate subsystem prefix in your Subject lines for
patch series intro emails, just like you would do for the patches
themselves.

Series applied, thank.
