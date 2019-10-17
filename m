Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29473DB779
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394529AbfJQT2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:28:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393438AbfJQT2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:28:02 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEF8514049CA3;
        Thu, 17 Oct 2019 12:28:01 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:28:01 -0400 (EDT)
Message-Id: <20191017.152801.1290816893027120794.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     jakub.kicinski@netronome.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net 0/2] dpaa2-eth: misc fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
References: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:28:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Wed, 16 Oct 2019 10:36:21 +0300

> This patch set adds a couple of fixes around updating configuration on MAC
> change.  Depending on when MC connects the DPNI to a MAC, both the MAC
> address and TX FQIDs should be updated everytime there is a change in
> configuration.
> 
> Changes in v2:
>  - used reverse christmas tree ordering in patch 2/2
> Changes in v3:
>  - add a missing new line
>  - go back to FQ based enqueueing after a transient error

Series applied, thanks.
