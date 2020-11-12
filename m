Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20FC2AFDEA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKLFcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgKLCDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 21:03:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AEC3207BB;
        Thu, 12 Nov 2020 02:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605146623;
        bh=dsFE2d+nP/NjvsnIOYfb1Gt95Gz0Pm9ISrbr3xNcD7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DKC1TVnwWlqWbgExParU8DFTtAsn1hjlGDhSVsh36jFkjowJFsNk3lkHZ/FbD/ymG
         UYejBGOWssrieo+jtemUPx2DBuiAbPlNgjsFNH5Pc3NXo5NOXc25knyjcryaMCrPIW
         gAb844QtyjqxE1wHdDp+gFEb0SjYQ1iaorqBr+ok=
Date:   Wed, 11 Nov 2020 18:03:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jan Kasprzak <kas@fi.muni.cz>
Cc:     Wang Hai <wanghai38@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] cosa: Add missing kfree in error path of cosa_write
Message-ID: <20201111180342.326ed7a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110163809.GE26676@fi.muni.cz>
References: <20201110144614.43194-1-wanghai38@huawei.com>
        <20201110163809.GE26676@fi.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 17:38:09 +0100 Jan Kasprzak wrote:
> Wang Hai wrote:
> : If memory allocation for 'kbuf' succeed, cosa_write() doesn't have a
> : corresponding kfree() in exception handling. Thus add kfree() for this
> : function implementation.
> 
> Acked-By: Jan "Yenya" Kasprzak <kas@fi.muni.cz>

Applied, thanks!

> That said, COSA is an ancient ISA bus device designed in late 1990s,
> I doubt anybody is still using it. I still do have one or two of these
> cards myself, but no computer with ISA bus to use them.

Maybe we can move it out to staging or just remove it?
