Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F033DF353
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhHCQxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhHCQxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:53:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D21E960ED6;
        Tue,  3 Aug 2021 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628009592;
        bh=2EAGW3b+DZMDZ2u8w0aWR4rvoCIMqFD6EImNxcjzpbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HUlEldRoMcIXo4dBxX2BNQK/3h0e7d7262IpF/jo0aYIy5Q82oxoQ+dxdCEANxbLe
         m7gge0L2/W680xFOJRE7XgA7rWmJ7No+/tY3sDlG+NcLKi9Yar016IhffpCET9s9il
         IfXE1JjeNV4jmkzbKnYIwGJBRzW989JD1OjcOb+E=
Date:   Tue, 3 Aug 2021 18:53:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com, davem@davemloft.net,
        Petko Manolov <petkan@nucleusys.com>
Subject: Re: [PATCH net v2 2/2] Remove the changelog and DRIVER_VERSION.
Message-ID: <YQl0dsbcSXS3qN8k@kroah.com>
References: <20210803161853.5904-1-petko.manolov@konsulko.com>
 <20210803161853.5904-3-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803161853.5904-3-petko.manolov@konsulko.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 07:18:53PM +0300, Petko Manolov wrote:
> From: Petko Manolov <petkan@nucleusys.com>
> 
> These are now deemed redundant.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>
> ---
>  drivers/net/usb/pegasus.c | 30 ++----------------------------
>  1 file changed, 2 insertions(+), 28 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
