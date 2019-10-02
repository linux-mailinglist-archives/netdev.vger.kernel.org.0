Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29D1C8BD8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfJBOuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:50:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfJBOue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:50:34 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 031DF14BBC0F1;
        Wed,  2 Oct 2019 07:50:33 -0700 (PDT)
Date:   Wed, 02 Oct 2019 10:50:31 -0400 (EDT)
Message-Id: <20191002.105031.954501986420666971.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next] net/rds: Use DMA memory pool allocation for
 rds_header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7a388623-b2c5-2ade-69af-2e295784afca@oracle.com>
References: <1569834480-25584-1-git-send-email-ka-cheong.poon@oracle.com>
        <20191001.101615.1260420946739435364.davem@davemloft.net>
        <7a388623-b2c5-2ade-69af-2e295784afca@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 07:50:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Wed, 2 Oct 2019 13:20:22 +0800

> And the i_{recv|send|_hdrs_dma array dereferencing is done
> at send/receive ring initialization and refill.  It is not
> done at every access of the header.

Ok, please add this info to the commit message and resubmit.

Thanks.
