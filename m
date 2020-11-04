Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548672A6391
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 12:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgKDLsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 06:48:04 -0500
Received: from mx3.wp.pl ([212.77.101.9]:18165 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbgKDLrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 06:47:24 -0500
Received: (wp-smtpd smtp.wp.pl 6905 invoked from network); 4 Nov 2020 12:47:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1604490441; bh=M9x5+/RYPnJTU7dxjrTIQoQI12g1gmCKqEBPPVpFQig=;
          h=From:To:Cc:Subject;
          b=xc211WkNH2Kc/Rlm/mMtIw1YtXp67pP67K3roIkKQ2RCnpJ/5iDQ425ZygvtDjpop
           JHgzUTxT9f7CA20C9qdWavswzFjcRjpAoc0eU/Qyc4Ty0WCGNG7U9pbJD7oDy+C4Pj
           LdRyAOhTZQUEjHnmYh3FCF8SYMbRe8TzKhDe9EmQ=
Received: from ip4-46-39-164-203.cust.nbox.cz (HELO localhost) (stf_xl@wp.pl@[46.39.164.203])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <kvalo@codeaurora.org>; 4 Nov 2020 12:47:21 +0100
Date:   Wed, 4 Nov 2020 12:47:19 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     =?utf-8?B?0JzQsNGA0LrQvtCyINCc0LjRhdCw0LjQuyDQkNC70LXQutGB0LDQvdC00YA=?=
         =?utf-8?B?0L7QstC40Yc=?= <markov.mikhail@itmh.ru>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "\"David S. Miller\"" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "illumin@yandex.ru" <illumin@yandex.ru>
Subject: Re: [PATCH v2] rt2x00: save survey for every channel visited
Message-ID: <20201104114719.GA75374@wp.pl>
References: <1603134408870.78805@itmh.ru>
 <20201020071243.GA302394@wp.pl>
 <1603222991841.29674@itmh.ru>
 <871rhbpw8b.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871rhbpw8b.fsf@codeaurora.org>
X-WP-MailID: 1679a778b8b3e14e6fb2fb83e25c807e
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [kZPh]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 06:19:32PM +0200, Kalle Valo wrote:
> Марков Михаил Александрович <markov.mikhail@itmh.ru> writes:
> 
> > rt2800 only gives you survey for current channel.
> >
> > Survey-based ACS algorithms are failing to perform their job when working
> > with rt2800.
> >
> > Make rt2800 save survey for every channel visited and be able to give away
> > that information.
> >
> > There is a bug registered https://dev.archive.openwrt.org/ticket/19081 and
> > this patch solves the issue.
> >
> > Signed-off-by: Markov Mikhail <markov.mikhail@itmh.ru>
> 
> Content-Type: text/plain; charset="koi8-r"
> 
> Just so you know I have no idea how patchwork or my scripts handle
> koi8-r. I recommend using utf-8 when submitting patches, but I can
> always try and see what breaks.

I've downloaded the patch from patchwork (using mbox button) and
it applied cleanly for me by 'git am'. So I think there should be
no problems, but if needed I can repost patch using utf-8.

Thanks
Stanislaw
