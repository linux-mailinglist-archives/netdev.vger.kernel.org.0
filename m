Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C9F4673A6
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379422AbhLCJJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:09:32 -0500
Received: from w4.tutanota.de ([81.3.6.165]:40838 "EHLO w4.tutanota.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243758AbhLCJJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 04:09:31 -0500
Received: from w3.tutanota.de (unknown [192.168.1.164])
        by w4.tutanota.de (Postfix) with ESMTP id EDCD610602DE;
        Fri,  3 Dec 2021 09:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1638522366;
        s=s1; d=tuta.io;
        h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
        bh=mkOXUyfGWMlP4LHyKMKNeglwKfa5K+5tB13b1KziAr4=;
        b=LSMaZx0aRm7xtIWWCyFcC2JXe17W84ey/uBtXEwXsDE1CIjfcWycjxoUPemvctw3
        TKz+Kv2ZdwwRrOU7+XCqgLq0X+J0DZBEFYOSUo4AjWsi0PLwFqMLvShUtKCgtX+oNEt
        KhMdrDE1OmoarpwxCe65Ldjmk5ijfg6TKaubEYzQ2GTxFspN3HB6U/uC5F+/HVx9rL8
        2dl/ICBESK+fcB7I96YyMpSf/EG4Vosbjw7c0RRg8RqFTZGp2hD7GK1Q1wwoAVPoWFy
        GIoRV4NyvxyoNROiCo5+XPbBmsEQeE1Db577egKOQpCwsK894D4ecaXSvFI1R2gT9rs
        +zKehBLtGA==
Date:   Fri, 3 Dec 2021 10:06:06 +0100 (CET)
From:   Adam Kandur <rndd@tuta.io>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Linux Staging <linux-staging@lists.linux.dev>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <MpzXmGP--N-2@tuta.io>
In-Reply-To: <20211203081401.GF9522@kadam>
References: <MpqQpIa--F-2@tuta.io> <20211203081401.GF9522@kadam>
Subject: Re: [PATCH] QLGE: qlge_main: Fix style
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the answer.



Dec 3, 2021, 11:14 by dan.carpenter@oracle.com:

> On Wed, Dec 01, 2021 at 03:39:08PM +0100, Adam Kandur wrote:
>
>>
>>
>
> The original style was better.  Multi-line indents get curly braces for
> readability even though they're not required by the C standard.
>
> regards,
> dan carpenter
>

