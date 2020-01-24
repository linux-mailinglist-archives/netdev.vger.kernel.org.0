Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B539F1478FC
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 08:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgAXH25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 02:28:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgAXH24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 02:28:56 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71E67158087E6;
        Thu, 23 Jan 2020 23:28:54 -0800 (PST)
Date:   Fri, 24 Jan 2020 08:28:52 +0100 (CET)
Message-Id: <20200124.082852.34776010407342804.davem@davemloft.net>
To:     sven.auhagen@voleatech.de
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH v4] mvneta driver disallow XDP program on hardware
 buffer management
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124072628.75245-1-sven.auhagen@voleatech.de>
References: <20200124072628.75245-1-sven.auhagen@voleatech.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 23:28:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>
Date: Fri, 24 Jan 2020 07:26:34 +0000

> Recently XDP Support was added to the mvneta driver
> for software buffer management only.
> It is still possible to attach an XDP program if
> hardware buffer management is used.
> It is not doing anything at that point.
> 
> The patch disallows attaching XDP programs to mvneta
> if hardware buffer management is used.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Can you at least say what is changing in each version of the patch
you are posting?

Thank you.
