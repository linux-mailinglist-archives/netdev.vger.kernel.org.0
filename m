Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EF83E26F7
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244263AbhHFJNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244111AbhHFJNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:13:39 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90082C061798;
        Fri,  6 Aug 2021 02:13:23 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628241201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hqVQBmaEF2fDEHUUbwaYPLD3q9fwnxrg3znPjsP3I54=;
        b=YkflkaAvMPaIO3ZqTrNGRkrJaHGtFAKsF2y95PY5C/qIilBv9+zekavF/hbes4KxycBAql
        6OkLDeDoHv9NXhCQoPqdJA2g9SZ4do21CqTfF6/HNw02Ir7IRudHrCJIdQbRWMI0j1C6G0
        d/mbkUgEybNjlrD7tDUEYA88Z8g14Gs=
Date:   Fri, 06 Aug 2021 09:13:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <a9ed105aa609b619492044da3e22ff65@linux.dev>
Subject: Re: [PATCH net-next] net: Remove redundant if statements
To:     "Matthieu Baerts" <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4b175501-50c1-fedf-1eaf-05c0de67c3c8@tessares.net>
References: <4b175501-50c1-fedf-1eaf-05c0de67c3c8@tessares.net>
 <20210806063847.21639-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

August 6, 2021 4:58 PM, "Matthieu Baerts" <matthieu.baerts@tessares.net> =
wrote:=0A=0A> Hi Yajun,=0A> =0A> Thank you for sharing this patch.=0A> =
=0A> On 06/08/2021 08:38, Yajun Deng wrote:=0A> =0A>> The if statement al=
ready move into sock_{put , hold},=0A>> just remove it.=0A> =0A> I was wo=
ndering in which subtree you had 'sock_put' checking the socket=0A> point=
er but then I realised you sent another patch just before adding=0A> this=
 check: "net: sock: add the case if sk is NULL"=0A> =0A> Please next time=
 send them in the same series to clearly indicate that=0A> this is the 2n=
d patch (2/2) and it depends on patch 1/2.=0A> =0AOK, Thank you for your =
advice.=0A=0A> Related to the modification in MPTCP part: it looks OK but=
 we do a few=0A> other calls to 'sock_put()' where we don't need to check=
 if the socket=0A> is NULL or not.=0A> =0A> In other words, if your patch=
 "net: sock: add the case if sk is NULL" is=0A> accepted, then the modifi=
cation in "net/mptcp/subflow.c" is OK for us.=0A> =0A> Cheers,=0A> Matt=
=0A> --=0A> Tessares | Belgium | Hybrid Access Solutions=0A> www.tessares=
.net
