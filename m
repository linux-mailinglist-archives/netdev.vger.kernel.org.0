Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D5B18AA71
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 02:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCSBsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 21:48:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSBsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 21:48:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 712901571E57C;
        Wed, 18 Mar 2020 18:48:00 -0700 (PDT)
Date:   Wed, 18 Mar 2020 18:47:59 -0700 (PDT)
Message-Id: <20200318.184759.14306085103059756.davem@davemloft.net>
To:     carmine.scarpitta@uniroma2.it
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahmed.abdelsalam@gssi.it, david.lebrun@uclouvain.be,
        dav.lebrun@gmail.com, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, paolo.lungaroni@cnit.it,
        hiroki.shirokura@linecorp.com
Subject: Re: [v2,net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB
 table
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318231635.15116-2-carmine.scarpitta@uniroma2.it>
References: <20200318231635.15116-1-carmine.scarpitta@uniroma2.it>
        <20200318231635.15116-2-carmine.scarpitta@uniroma2.it>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 18:48:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Date: Thu, 19 Mar 2020 00:16:34 +0100

> This is useful for use-cases implementing a separate routing table
> per tenant.

We have this capability already, it is called VRF.

I'm not adding yet another way to do the same exact thing.

Sorry.
