Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAB71CCCD8
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 20:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgEJSOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 14:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgEJSOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 14:14:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60F9320801;
        Sun, 10 May 2020 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589134478;
        bh=WwBN30P51vXg7WQY6bZLhZOJRsWCwmtP9TBZN7uIZhQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pI2zBJTzs4fs8MD5RXCSBWNvQTJBOXv2uTnUIdc5viZ/7JdszbwLdd+EECVaUxu7K
         /MHurI6PyeVKKB69u6YS4r2l02Mb3zF9vWTb2LGsKdXjH8Vp5M5mpFClv2R6p15ZIb
         Jv3ZCWC3Rjb/v9FG4uHWObC+8VG+EkOct8x0EiP4=
Date:   Sun, 10 May 2020 11:14:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: remove redundant assignment to
 variable status
Message-ID: <20200510111436.66d8838f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509215756.506840-2-colin.king@canonical.com>
References: <20200509215756.506840-1-colin.king@canonical.com>
        <20200509215756.506840-2-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 22:57:56 +0100 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable status is being initializeed with a value that is never read
> and it is being updated later with a new value. The initialization
> is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied the 3 fixes from Saturday to net-next, thanks.
