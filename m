Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E19047FDD9
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 15:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237167AbhL0Op3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 09:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbhL0Op3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 09:45:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25079C06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 06:45:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C241FB80E98
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 14:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA240C36AE7;
        Mon, 27 Dec 2021 14:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640616326;
        bh=D2NoGDaN6evIIcU0Jn7b6sazFlijN8oWpKx4uhS4VIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lCZ7q1LKsSY6Dy/L/Uoo2SIgLSJQtwxlDSYIYJAafsyrrCRNHm5Forh7Fz9lOMoiM
         KoCgb6vJ/WFZ5DZxQ0AC4mnjUjpL+/OJZOE/9Q+aCNXCrrFHxID+lLUd23xrOPHgyI
         hle5y8jOLFyEjSOudI/kndaMsZPYs4t+QS/gvxis=
Date:   Mon, 27 Dec 2021 15:45:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Slade Watkins <slade@sladewatkins.com>
Cc:     Adam Kandur <sys.arch.adam@gmail.com>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH] qlge: rewrite qlge_change_rx_buffers()
Message-ID: <YcnRg9AYfSgC1pBE@kroah.com>
References: <CAE28pkNNsUnp4UiaKX-OjAQHPGjSNY6+hn-oK39m8w=ybXSO6Q@mail.gmail.com>
 <YcnA8LBwH1X/xqKt@kroah.com>
 <152c8d76-af2b-2ea3-4f15-faf2670d8e73@sladewatkins.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152c8d76-af2b-2ea3-4f15-faf2670d8e73@sladewatkins.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 09:15:36AM -0500, Slade Watkins wrote:
> --
> This email message may contain sensitive or otherwise confidential
> information and is intended for the addressee(s) only. If you believe
> to have received this message in error, please let the sender know
> *immediately* and delete the message. Thank you for your cooperation!
> 

Now deleted.
