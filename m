Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220DBEB7D8
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfJaTNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:13:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59542 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfJaTNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:13:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A672014FC9281;
        Thu, 31 Oct 2019 12:13:51 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:13:51 -0700 (PDT)
Message-Id: <20191031.121351.913036685396507892.davem@davemloft.net>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, roy.pledge@nxp.com,
        jakub.kicinski@netronome.com, joe@perches.com
Subject: Re: [net-next v2 00/13] DPAA Ethernet changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
References: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 12:13:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>
Date: Thu, 31 Oct 2019 16:37:46 +0200

> v2: remove excess braces
> 
> Here are some more changes for the DPAA 1.x area.
> In summary, these changes use pages for the receive buffers and
> for the scatter-gather table fed to the HW on the Tx path, perform
> a bit of cleanup in some convoluted parts of the code, add some
> minor fixes related to DMA (un)mapping sequencing for a not so
> common scenario, add a device link that removes the interfaces
> when the QMan portal in use by them is removed.

Series applied, thanks.
