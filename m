Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B534541D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfFNFlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:41:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfFNFlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:41:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A90F914DD924D;
        Thu, 13 Jun 2019 22:41:43 -0700 (PDT)
Date:   Thu, 13 Jun 2019 22:41:43 -0700 (PDT)
Message-Id: <20190613.224143.1849754420406466041.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 00/13] s390/qeth: updates 2019-06-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 22:41:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 11 Jun 2019 18:37:47 +0200

> please apply the following patch series for qeth to net-next.
> This brings all sorts of cleanups and minor improvements,
> primarily for the control IO path.

Series applied.
