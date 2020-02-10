Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23171577D7
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbgBJNC7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Feb 2020 08:02:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729313AbgBJNCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 08:02:55 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B4A0C14DD5521;
        Mon, 10 Feb 2020 05:02:53 -0800 (PST)
Date:   Mon, 10 Feb 2020 14:02:49 +0100 (CET)
Message-Id: <20200210.140249.727550899805828159.davem@davemloft.net>
To:     bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        larsm17@gmail.com, aleksander@aleksander.es
Subject: Re: [PATCH net,stable] qmi_wwan: re-add DW5821e pre-production
 variant
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200208145036.27696-1-bjorn@mork.no>
References: <20200208145036.27696-1-bjorn@mork.no>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Feb 2020 05:02:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Sat,  8 Feb 2020 15:50:36 +0100

> Commit f25e1392fdb5 removed the support for the pre-production variant
> of the Dell DW5821e to avoid probing another USB interface unnecessarily.
> However, the pre-production samples are found in the wild, and this lack
> of support is causing problems for users of such samples.  It is therefore
> necessary to support both variants.
> 
> Matching on both interfaces 0 and 1 is not expected to cause any problem
> with either variant, as only the QMI function will be probed successfully
> on either.  Interface 1 will be rejected based on the HID class for the
> production variant:
 ...
> And interface 0 will be rejected based on too few endpoints for the
> pre-production variant:
 ...
> Fixes: f25e1392fdb5 ("qmi_wwan: fix interface number for DW5821e production firmware")
> Link: https://whrl.pl/Rf0vNk
> Reported-by: Lars Melin <larsm17@gmail.com>
> Cc: Aleksander Morgado <aleksander@aleksander.es>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Applied and queued up for -stable.
