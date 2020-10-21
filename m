Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C671294906
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 09:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502024AbgJUHkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 03:40:24 -0400
Received: from mx3.wp.pl ([212.77.101.9]:36306 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgJUHkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 03:40:24 -0400
Received: (wp-smtpd smtp.wp.pl 23640 invoked from network); 21 Oct 2020 09:40:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1603266020; bh=7J4v0YRthy4YkQw5jJP8rQj01iofTsTkYYNFVS9hzQ4=;
          h=From:To:Cc:Subject;
          b=S3UC7jybl+UJOXSMxmWwNVNXUQIlAETCu+A8kjm20Cky8TSKWvjo7KkQkLdWcd0+z
           G6V4gerg3iSaapLDFVV3t7uIKZg2+rxaNZ5BhdWYf3vOnP6Glc0Hlqx565kbpjIQMl
           Toe1TrBFaARqGRAEi6rA9EpWlH0qe2fRrLFvQ2d8=
Received: from ip4-46-39-164-203.cust.nbox.cz (HELO localhost) (stf_xl@wp.pl@[46.39.164.203])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <markov.mikhail@itmh.ru>; 21 Oct 2020 09:40:19 +0200
Date:   Wed, 21 Oct 2020 09:40:18 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     =?utf-8?B?0JzQsNGA0LrQvtCyINCc0LjRhdCw0LjQuyDQkNC70LXQutGB0LDQvdC00YA=?=
         =?utf-8?B?0L7QstC40Yc=?= <markov.mikhail@itmh.ru>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "\"David S. Miller\"" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "illumin@yandex.ru" <illumin@yandex.ru>
Subject: Re: [PATCH v2] rt2x00: save survey for every channel visited
Message-ID: <20201021074018.GA308308@wp.pl>
References: <1603134408870.78805@itmh.ru>
 <20201020071243.GA302394@wp.pl>
 <1603222991841.29674@itmh.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1603222991841.29674@itmh.ru>
X-WP-MailID: d3ddd05d646a03e064a13c2d48fdf2d2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [wQMR]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 07:43:12PM +0000, Марков Михаил Александрович wrote:
> rt2800 only gives you survey for current channel.
> 
> Survey-based ACS algorithms are failing to perform their job when working
> with rt2800.
> 
> Make rt2800 save survey for every channel visited and be able to give away
> that information.
> 
> There is a bug registered https://dev.archive.openwrt.org/ticket/19081 and
> this patch solves the issue.
> 
> Signed-off-by: Markov Mikhail <markov.mikhail@itmh.ru>
>
> ---
> Changes are now aggregated in rt2800lib.c.

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Thanks
Stanislaw
