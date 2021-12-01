Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD21546516D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbhLAPZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhLAPZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:25:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBF1C061574;
        Wed,  1 Dec 2021 07:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBB8CB81DF7;
        Wed,  1 Dec 2021 15:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27437C53FCC;
        Wed,  1 Dec 2021 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638372121;
        bh=QmaCV33LLonvayOIfKos2kBeGWCzaCQv4he5dRr8XVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QH/6xbEm9CwEw6IZPRwDxZhHvrDdet19zcqwwcxzDrsfW95G3DzWWkZqcd/4h9/vL
         pkRHnEh6mBRgze0CUPmc+0nUyqP/V6TZqqlQINMDvN21c6ZfQUROxvp3e/6ElQlWtQ
         9HE9mUYA3HVpW5tbNYnQ6YQsKG2HwpZ61iWUV+8++xTdT+VP9kXrAWMcQjDGpuI/w5
         KHhgpMnzyuVAXkycL3d1srLi8UnZ1QhxMBbel0xyYIxKL67WCW2/3NDD/i6iSDEZby
         oerKFc2bel7Nn3v1VYYXKb4epL1TvS6UPkS9jiFceDhid+l1X5tapsEwph+RvC/BYy
         Kl9ataYhTM4Qg==
Date:   Wed, 1 Dec 2021 07:22:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: Re: [PATCH 01/15] skbuff: introduce skb_pull_data
Message-ID: <20211201072200.0188716c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BD3EDAD7-9B40-4F75-B5E6-E90887D48F95@holtmann.org>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
        <20211201000215.1134831-2-luiz.dentz@gmail.com>
        <20211130171105.64d6cf36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CABBYNZJGpswn03StZb97XQOUu5rj2_GGkj-UdZWdQOwuWwNVXQ@mail.gmail.com>
        <20211130182742.7537e212@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BD3EDAD7-9B40-4F75-B5E6-E90887D48F95@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 08:22:51 +0100 Marcel Holtmann wrote:
> >> I cross posted it to net-dev just in case you guys had some strong
> >> opinions on introducing such a function,  
> > 
> > Someone else still may, I don't :)
> >   
> >> it was in fact suggested by Dan but I also didn't find a better name
> >> so I went with it, if you guys prefer we can merge it in
> >> bluetooth-next first as usual.  
> > 
> > Going via bluetooth-next sounds good!  
> 
> if you are ok with this going via bluetooth-next, then I need some sort
> of ACK from you or Dave.

Acked-by: Jakub Kicinski <kuba@kernel.org>
