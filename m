Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F019743625A
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhJUNIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230444AbhJUNIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:08:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54B0260FE8;
        Thu, 21 Oct 2021 13:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821596;
        bh=+mLSzKOMFevHHTNK1ZvqnU8FThaU5AqVuhwLuwr0Yn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=psYxRlsUeD7F2CDhwSQDlA1uCxX4cBqUm8ZvvnLIdECgLoWdlvko+uQA3xNEjql55
         XIDItym44FSsM7/ER+86s6ixtgQiAXt15nayUcqNOwXP6bNixSAbVrjfJKTQGN4K1g
         yjEDGFJpULScaC5D6wfWT3iltJtdjvc0SNd/ez5ndspMbwfAC7Mk1QjYrD5T3WFoeQ
         ZlAMRoto4QvhY0eFJ4uxBFBr0coBCEHvCKTZxzOEAf6Nz+mtjRI3jhML0AKbYHtZti
         ahl1vWW6CtWzP60RbrKIW+s+sCszERw9Ahr3i75VX0Lj4noGQyuOK/vsgjrCHgIEwL
         rIZWFzgzBsVtg==
Date:   Thu, 21 Oct 2021 06:06:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 04/12] net: usb: don't write directly to
 netdev->dev_addr
Message-ID: <20211021060635.43526d0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <be00cea5-3074-5a27-3e04-97c08ae60fd8@suse.com>
References: <20211020155617.1721694-1-kuba@kernel.org>
        <20211020155617.1721694-5-kuba@kernel.org>
        <be00cea5-3074-5a27-3e04-97c08ae60fd8@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 11:55:00 +0200 Oliver Neukum wrote:
> On 20.10.21 17:56, Jakub Kicinski wrote:
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it got through appropriate helpers.
> >
> > Manually fix all net/usb drivers without separate maintainers.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---  
> 
> this looks good except for catc, which needs a more complicated fix.
> Do you want me to do it and drop it from this patch?

Sure, thanks!
