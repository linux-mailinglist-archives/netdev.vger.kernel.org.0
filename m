Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A973128745
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfLUFAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:00:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56754 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:00:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B37E153C4F64;
        Fri, 20 Dec 2019 21:00:48 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:00:47 -0800 (PST)
Message-Id: <20191220.210047.929455410607980047.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] s390/qeth: fixes 2019-12-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218153228.29908-1-jwi@linux.ibm.com>
References: <20191218153228.29908-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:00:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed, 18 Dec 2019 16:32:25 +0100

> please apply the following patch series to your net tree.
> This brings two fixes for initialization / teardown issues, and one
> ENOTSUPP cleanup.

Series applied, thanks.
