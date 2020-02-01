Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F24F14FA52
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgBATll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:41:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgBATll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:41:41 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D219205F4;
        Sat,  1 Feb 2020 19:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580586100;
        bh=bXDptipJNoM2F1DfQwu3uLE7B64j6EcI8B3qmYqGXk4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gs8GNlvvQRTzcmxYSLcFJYE3pUf9hfJBJp1zEd5gqkVhCW+wzvzBBhQ68idOa3+yQ
         YrxALgCPkf7k56lGNqmFIc/chMpEP8FUOpFcIiSEaFnKYbecMG4Zq6zoMT+ueieb1i
         UFVNlGuPuBDejcjVXhOQkIlkl7JpNJiXXn9ex4Us=
Date:   Sat, 1 Feb 2020 11:41:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] octeontx2-pf: Fix an IS_ERR() vs NULL bug
Message-ID: <20200201114139.725a6f95@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200131050241.aoqatlxubobkmi4y@kili.mountain>
References: <20200131050241.aoqatlxubobkmi4y@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 08:02:41 +0300, Dan Carpenter wrote:
> The otx2_mbox_get_rsp() function never returns NULL, it returns error
> pointers on error.
> 
> Fixes: 34bfe0ebedb7 ("octeontx2-pf: MTU, MAC and RX mode config support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied
