Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FB915C484
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387991AbgBMPsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:48:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387891AbgBMPr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:47:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0813D15B2C896;
        Thu, 13 Feb 2020 07:47:58 -0800 (PST)
Date:   Thu, 13 Feb 2020 07:47:55 -0800 (PST)
Message-Id: <20200213.074755.849728173103010425.davem@davemloft.net>
To:     manivannan.sadhasivam@linaro.org
Cc:     dcbw@redhat.com, kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate QRTR Nameservice to Kernel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200213153007.GA26254@mani>
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
        <34daecbeb05d31e30ef11574f873553290c29d16.camel@redhat.com>
        <20200213153007.GA26254@mani>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2020 07:47:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Thu, 13 Feb 2020 21:00:08 +0530

> The primary motivation is to eliminate the need for installing and starting
> a userspace tool for the basic WiFi usage. This will be critical for the
> Qualcomm WLAN devices deployed in x86 laptops.

I can't even remember it ever being the case that wifi would come up without
the help of a userspace component of some sort to initiate the scan and choose
and AP to associate with.

And from that perspective your argument doesn't seem valid at all.
