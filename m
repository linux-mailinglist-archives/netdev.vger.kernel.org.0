Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26838383907
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344076AbhEQQGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245465AbhEQQDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 12:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B509760E0B;
        Mon, 17 May 2021 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621267318;
        bh=ePyCIQIDrIZo5z8VdIVCHxWyAkz9/FwYMIPyJzA4Gvw=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=m6ShAZ5d7LBK3RFs0kkAY+LZ5n9s94qJCgU1Vt9fOCh++xndS4LePAh/nfySpek+0
         I2PCjFqE+TZ2F/uC8WArB2Qhmzd8v81bz00SSxJKfFAG8voxXkUa+RBydCPCAIGM46
         FhdwxBJai5waHhsrPNNepS/kDhYtg5vUu0jAHYclzIF6xWR3FNeljSx04w95elJ1XN
         aXLmNz7u12x1julRfp6WcLjl71H8yTAz0qLfSPDo4xXqxgKdyNcaTTDEZayX/l6+zr
         jUvEsCCyzJDIEmauR0NBEaBfbKGFmvpbjVgpjddYILJifV1zQDpRyCoXnHOrI836Tr
         6c52/ZLbnlU4Q==
Date:   Mon, 17 May 2021 09:01:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jim Ma <majinjing3@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] tls splice: check SPLICE_F_NONBLOCK instead of
 MSG_DONTWAIT
Message-ID: <20210517090157.3e37461e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <SY4P282MB2854227891D8F8F8FF2406E5A72E9@SY4P282MB2854.AUSP282.PROD.OUTLOOK.COM>
References: <96f2e74095e655a401bb921062a6f09e94f8a57a.1620961779.git.majinjing3@gmail.com>
        <20210514122749.6dd15b9e@kicinski-fedora-PC1C0HJN>
        <SY4P282MB2854227891D8F8F8FF2406E5A72E9@SY4P282MB2854.AUSP282.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 May 2021 04:58:11 +0000 Jim Ma wrote:
> No, this patch fix using MSG_* in splice.
> 
> I have tested read, write, sendmsg, recvmsg fot tls, and try to
> implement tls in golang. In develop, I have found those issues and
> try to fix them.

To be clear the Fixes tag points to the commit where the issue was
first introduced. AFAICT the issue was there from the start, that
is commit c46234ebb4d1 ("tls: RX path for ktls"). Are you saying that 
it used to work in the beginning and then another commit broke it?

We need the fixes tag to be able to tell how far back (in terms of
LTS releases) to backport.

> An other issue, when before enable TLS_RX in cleint, the server sends
> a tls record, client will receive bad message or message too long
> error. I'm try to fix this issue.

Please reply all and don't top post.
