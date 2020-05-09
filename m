Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688F51CBDB9
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgEIF06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgEIF06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:26:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA1A920736;
        Sat,  9 May 2020 05:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589002017;
        bh=2FbqU8bZl6w9cLuF4MoPItMpUp61yEjmaaPsancdiBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rhxvvpBnzcB5zKzm7pZqXc6VWM5yV8OgUv6yVT/8j9OT40YqRJZjIGI6JyERzHkf0
         3bHLNHHk2UDpT/X6QRnuJ6gtc4LoEVCnhact2U/CZgJi57lqxSpHhMBMRwwmlbNhfY
         ZQRofNb0LM0Y9aBWpdWzlA9fvpdIa6BevMQo7SpA=
Date:   Fri, 8 May 2020 22:26:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     alex.aring@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next] ieee802154: 6lowpan: remove unnecessary
 comparison
Message-ID: <20200508222655.71369682@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e9ce1e47-79aa-aca2-e182-b9063d17fad8@datenfreihafen.org>
References: <1588909928-58230-1-git-send-email-yangyingliang@huawei.com>
        <e9ce1e47-79aa-aca2-e182-b9063d17fad8@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 17:09:43 +0200 Stefan Schmidt wrote:
>On 08.05.20 05:52, Yang Yingliang wrote:
> > The type of dispatch is u8 which is always '<=' 0xff, so the
> > dispatch <= 0xff is always true, we can remove this comparison.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>
> This looks good to me. Thanks for fixing this.
> 
> Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
> 
> Dave, can you apply this directly to your net tree? I have no other 
> ieee802154 fixes pending to fill a pull request.

I'm sitting in for Dave today, applied to net-next, thank you!
