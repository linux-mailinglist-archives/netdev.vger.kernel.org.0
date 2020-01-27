Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792F114A159
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgA0J7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:59:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36822 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgA0J7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:59:13 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E36931502D62B;
        Mon, 27 Jan 2020 01:59:10 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:59:09 +0100 (CET)
Message-Id: <20200127.105909.1339289008484675371.davem@davemloft.net>
To:     sven.auhagen@voleatech.de
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH v5] mvneta driver disallow XDP program on hardware
 buffer management
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200125080702.81712-1-sven.auhagen@voleatech.de>
References: <20200125080702.81712-1-sven.auhagen@voleatech.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 01:59:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>
Date: Sat, 25 Jan 2020 08:07:03 +0000

> Recently XDP Support was added to the mvneta driver
> for software buffer management only.
> It is still possible to attach an XDP program if
> hardware buffer management is used.
> It is not doing anything at that point.
> 
> The patch disallows attaching XDP programs to mvneta
> if hardware buffer management is used.
> 
> I am sorry about that. It is my first submission and I am having
> some troubles with the format of my emails.
> 
> v4 -> v5:
> - Remove extra tabs
> 
> v3 -> v4:
> - Please ignore v3 I accidentally submitted
>   my other patch with git-send-mail and v4 is correct
> 
> v2 -> v3:
> - My mailserver corrupted the patch
>   resubmission with git-send-email
> 
> v1 -> v2:
> - Fixing the patches indentation
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Applied and queued up for -stable, thakns.
