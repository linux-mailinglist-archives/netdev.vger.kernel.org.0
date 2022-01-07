Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567B2487794
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 13:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbiAGMZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 07:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiAGMZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 07:25:31 -0500
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E197C061245
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 04:25:31 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1641558329; bh=+hpYvDYWFcyKXL3tncDsbh0777dwqI0afOh9vJYiHwc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=LL+hFAIWckLFVZC2fhwYtJpJpUISX+SNzByeieMdwJfbqEUoYnmlmHPQFM5AfjA7G
         8rWqlXpHDCYIw/PRJMGMeAnLFB48gMx3NhE1CBXolwKA/GdtO8FvSoLG3g+/AyNIg8
         66GH91XnqrjpfmIOQ891rZtPqHK3423yy79GhZRVV12bfZ00bRKwoM+8XY+fzdb0Ax
         8thA/iUdnPyqPwC8pDhVJ3nkKgb9QzF5kU2qdseJ9HHnjCvyKgIPgT7FBdgpezmJfh
         hs+xsIXszj16GJynljxUzX5bpnX9Xu95ppGUQe+xkQAght1noaJ2wagQ9Zbe4qmdgy
         jALgtAm5tToHQ==
To:     Kevin Bracey <kevin@bracey.fi>
Cc:     netdev@vger.kernel.org, Kevin Bracey <kevin@bracey.fi>
Subject: Re: [PATCH net-next v2] sch_cake: revise Diffserv docs
In-Reply-To: <20220106215637.3132391-1-kevin@bracey.fi>
References: <87h7aga8es.fsf@toke.dk> <20220106215637.3132391-1-kevin@bracey.fi>
Date:   Fri, 07 Jan 2022 13:25:29 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87czl3ag1y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin Bracey <kevin@bracey.fi> writes:

> Documentation incorrectly stated that CS1 is equivalent to LE for
> diffserv8. But when LE was added to the table, CS1 was pushed into tin
> 1, leaving only LE in tin 0.
>
> Also "TOS1" no longer exists, as that is the same codepoint as LE.
>
> Make other tweaks properly distinguishing codepoints from classes and
> putting current Diffserve codepoints ahead of legacy ones.
>
> Signed-off-by: Kevin Bracey <kevin@bracey.fi>

That's better; thank you for the patch! :)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
