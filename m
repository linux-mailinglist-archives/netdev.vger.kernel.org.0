Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5187139F77
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 03:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgANCXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 21:23:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbgANCXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 21:23:36 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBA2D2080D;
        Tue, 14 Jan 2020 02:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578968616;
        bh=8qC11/KMmqXc/GC0MinkOZxtZ6Y63gPfMjJ2mdN2JqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=whdjHIow3GDyXp6i5yMB5DnxsnGgo/caKQRwvNZJqUF8UAjS9ARfJUaNsz6qgkU4d
         mm9W2YcqehLdn/MKgDLQ3KDBzeAkoaLSkZNyzXk/nAscdNpP+hOuPVG5QyCySGY+0a
         bI6gva5qPArHV9f8qurlXnapbggm5F6+CrBG3Rzk=
Date:   Mon, 13 Jan 2020 18:23:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     <thomas.lendacky@amd.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd-xgbe: remove unnecessary conversion to bool
Message-ID: <20200113182335.6b0a4e48@cakuba>
In-Reply-To: <20200113131516.142221-1-chenzhou10@huawei.com>
References: <20200113131516.142221-1-chenzhou10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 21:15:16 +0800, Chen Zhou wrote:
> The conversion to bool is not needed, remove it.
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

Applied to net-next, thanks!
