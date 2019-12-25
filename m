Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E43712A672
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 07:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLYGl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 01:41:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59182 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfLYGl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 01:41:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6195154D895C;
        Tue, 24 Dec 2019 22:41:27 -0800 (PST)
Date:   Tue, 24 Dec 2019 22:41:27 -0800 (PST)
Message-Id: <20191224.224127.1299414022630652936.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/6] s390/qeth: fixes 2019-12-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223140326.16488-1-jwi@linux.ibm.com>
References: <20191223140326.16488-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 22:41:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon, 23 Dec 2019 15:03:20 +0100

> please apply the following patch series for qeth to your net tree.
> 
> This brings two fixes for errors during device initialization, deals with
> several issues in the vnicc control code, and adds a missing lock.

Series applied, thanks.
