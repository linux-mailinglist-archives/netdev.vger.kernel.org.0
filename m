Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0ABE6D74E
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 01:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfGRXes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 19:34:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGRXes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 19:34:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B177A1528C8D5;
        Thu, 18 Jul 2019 16:34:47 -0700 (PDT)
Date:   Thu, 18 Jul 2019 16:34:47 -0700 (PDT)
Message-Id: <20190718.163447.1589002554948899397.davem@davemloft.net>
To:     rogan@dawes.za.net
Cc:     bjorn@mork.no, netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: qmi_wwan: add D-Link DWM-222 A2 device ID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717091433.GA5325@lisa.dawes.za.net>
References: <20190717091134.GA5179@lisa.dawes.za.net>
        <20190717091433.GA5325@lisa.dawes.za.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 16:34:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rogan Dawes <rogan@dawes.za.net>
Date: Wed, 17 Jul 2019 11:14:33 +0200

> Signed-off-by: Rogan Dawes <rogan@dawes.za.net>

Applied.
