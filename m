Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DEC17286E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgB0TPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:15:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43876 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbgB0TPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:15:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9E69120F5E02;
        Thu, 27 Feb 2020 11:15:33 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:15:33 -0800 (PST)
Message-Id: <20200227.111533.1664441216015449433.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/8] s390/qeth: updates 2020-02-27
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227170816.101286-1-jwi@linux.ibm.com>
References: <20200227170816.101286-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 11:15:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 27 Feb 2020 18:08:08 +0100

> please apply the following patch series for qeth to netdev's net-next
> tree.
> 
> This adds support for ETHTOOL_RX_COPYBREAK, along with small cleanups
> and fine-tuning.

Series applied, thanks Julian.
