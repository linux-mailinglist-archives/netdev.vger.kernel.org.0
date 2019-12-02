Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C546D10EF5A
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfLBSf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:35:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbfLBSfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 13:35:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADFE220637;
        Mon,  2 Dec 2019 18:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575311725;
        bh=1Sz+zRAX47X852dly94ySsVhbz9r2hBLQ7vJEM0U4Mo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2cB+jUwdOeQIxFeRlNjukBbPZoLK8B3ekUyzFCel6coxmbpaNVdaEqkoOt91xmo4a
         i1wXz2qc8E15lrs+q7RG+2SNWnp9zmkeqlkU6hL4XNsug6HywBg1wZhmzO297TvJMg
         xsN9gUw3hZKyLi1TmSqhzxiz2e/3VJmsVgIjhkV0=
Date:   Mon, 2 Dec 2019 19:35:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     JD <jdtxs00@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Subject: Re: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
Message-ID: <20191202183522.GA734264@kroah.com>
References: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
 <20191101075335.GG14361@gauss3.secunet.de>
 <f5d26eeb-02b5-20f4-14f5-e56721c97eb8@gmail.com>
 <20191111062832.GP13225@gauss3.secunet.de>
 <a1a60471-7395-2bb0-5c6d-290b9af4b7dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1a60471-7395-2bb0-5c6d-290b9af4b7dc@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 12:10:32PM -0600, JD wrote:
> Hello,
> 
> I noticed the patch hasn't been in the last two stable releases for 4.14 and
> 4.19.  I checked the 4.14.157 and 4.19.87 release but the xfrm_state.c file
> doesn't have the patch.
> 
> Any update on or eta when this patch will backported to those two?  Also, I
> suppose 5.3.14 will need it as well.

Sorry, I didn't realize this was already in the stable kernel tree.

I'll go queue it up now...

greg k-h
