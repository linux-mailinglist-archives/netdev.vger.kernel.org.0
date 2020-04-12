Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682091A5FE9
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgDLSrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgDLSrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:47:12 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8E5C0A3BF0;
        Sun, 12 Apr 2020 11:47:13 -0700 (PDT)
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5DCD206DA;
        Sun, 12 Apr 2020 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586717233;
        bh=+9FXfKaVjMENl17bJC9ZRMemISlZT/4AT+8ce9SdLCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S/IwGsSJVCkmnJ7UN1vu2Z3MyPqtgd0sDwH7wRpwnDcq27/vryNIJTPmBqNBaI+zz
         vnElP2Uo5LLdLpCElOFAw3X5n0i4bODviYbpWlxr/gUpRR0UUtUKDsPUNp+F3+0lHr
         8nsnYDVBUE41bvV8BVNhipcTGCI+FT+yjbr+MZp0=
Date:   Sun, 12 Apr 2020 11:47:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jon Mason <jdmason@kudzu.us>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: neterion: remove redundant assignment to variable
 tmp64
Message-ID: <20200412114711.2599fd9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200410191150.75588-1-colin.king@canonical.com>
References: <20200410191150.75588-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Apr 2020 20:11:50 +0100 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable tmp64 is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
