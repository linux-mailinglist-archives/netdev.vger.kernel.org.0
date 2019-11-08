Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6797FF3EF7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbfKHEg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:36:57 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33246 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726281AbfKHEg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:36:57 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 936ED4AB10;
        Fri,  8 Nov 2019 15:36:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-language:x-mailer:content-transfer-encoding
        :content-type:content-type:mime-version:message-id:date:date
        :subject:subject:in-reply-to:references:from:from:received
        :received:received; s=mail_dkim; t=1573187812; bh=CiG6XRYW3SlNtK
        R525Q0q9dYaV26AhlMKV0InFADhwI=; b=neNSfr2cjz9uKM0RKyYSaah3YRgBjY
        RqdMkLBm1Gh5UDR7gV55V+vPEo+zAX4bYZrTazOYRE8urQio8rm4oFXYN6GF6NFU
        KR0q63/vJjJQ9iBu2SCKd2MYNSP673WJOc473EC/P9/JHFI5MW9RamYP6gVHJtox
        ZozPKKOBrgKmQ=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id g_dY7DmBSiKG; Fri,  8 Nov 2019 15:36:52 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id EEB4D4AB12;
        Fri,  8 Nov 2019 15:36:51 +1100 (AEDT)
Received: from VNLAP288VNPC (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 9C1DE4AB10;
        Fri,  8 Nov 2019 15:36:50 +1100 (AEDT)
From:   "Tuong Lien Tong" <tuong.t.lien@dektech.com.au>
To:     "'David Miller'" <davem@davemloft.net>
Cc:     <jon.maloy@ericsson.com>, <maloy@donjonn.com>,
        <ying.xue@windriver.com>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>
References: <20191108014213.32219-1-tuong.t.lien@dektech.com.au> <20191107.200700.707955577326790302.davem@davemloft.net>
In-Reply-To: <20191107.200700.707955577326790302.davem@davemloft.net>
Subject: RE: [net-next 0/5] TIPC encryption
Date:   Fri, 8 Nov 2019 11:36:49 +0700
Message-ID: <1a2e01d595ee$23eae790$6bc0b6b0$@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHp/2WKaQBaVeetud7VXidxs8T4VQEexPnsp07koDA=
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You are right, David.
I am going to resend the v2 series with an update for it.

Thanks/Tuong

-----Original Message-----
From: David Miller <davem@davemloft.net> 
Sent: Friday, November 8, 2019 11:07 AM
To: tuong.t.lien@dektech.com.au
Cc: jon.maloy@ericsson.com; maloy@donjonn.com; ying.xue@windriver.com;
netdev@vger.kernel.org; tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 0/5] TIPC encryption

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Fri,  8 Nov 2019 08:42:08 +0700

> This series provides TIPC encryption feature, kernel part. There will be
> another one in the 'iproute2/tipc' for user space to set key.

If gcm(aes) is the only algorithm you accept, you will need to express
this dependency in the Kconfig file.  Otherwise it is pointless to
turn on the TIPC crypto Kconfig option.

