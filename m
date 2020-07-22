Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E570D229F45
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgGVSba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgGVSba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:31:30 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDE49C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:31:29 -0700 (PDT)
Received: from [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539] (unknown [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 618689154A;
        Wed, 22 Jul 2020 19:31:28 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595442688; bh=XgitfArUYtlltGDG5E/Dt1/pQsnwteNqecyadwb5uCo=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:From;
        z=Subject:=20Re:=20[PATCH=20v2=20net-next=2000/10]=20l2tp:=20cleanu
         p=20checkpatch.pl=20warnings|To:=20Tom=20Parkin=20<tparkin@katalix
         .com>,=20netdev@vger.kernel.org|References:=20<20200722163214.7920
         -1-tparkin@katalix.com>|From:=20James=20Chapman=20<jchapman@katali
         x.com>|Message-ID:=20<0896e429-d7fe-8205-aec3-83b4b658979e@katalix
         .com>|Date:=20Wed,=2022=20Jul=202020=2019:31:28=20+0100|MIME-Versi
         on:=201.0|In-Reply-To:=20<20200722163214.7920-1-tparkin@katalix.co
         m>;
        b=c7cS8Nh+s2aKPo4eQu0hI59RBuImMd7gXxbwXgTKNeYG9yp9ri0HvQxgCl2o1NL32
         wtGPftdH2WZPspRe8U2dzydlbx2cK22HXCJM5PPpwF+7U666GQLzxLMAe/SIYlCEcb
         yrR0Urh6eSsaqi9piiq1BZMLdZbX82ljM8vtxjYII0aAJ5KvmI9ND1Fe+CQj128NjY
         5nQ9a2ejOu4ZrAKF2k9sAgYXDVXZXrKfy9uzJBoYTEuAl9BrpeNoY97u23B3uH5kK/
         K0b2yXFWvb5j01svqlE5HfTaEOIkX+IUnWWmsXBP2rON2lGBTi6a9c0itzeCBAHiVl
         Nen6oKH6jDyYA==
Subject: Re: [PATCH v2 net-next 00/10] l2tp: cleanup checkpatch.pl warnings
To:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
References: <20200722163214.7920-1-tparkin@katalix.com>
From:   James Chapman <jchapman@katalix.com>
Autocrypt: addr=jchapman@katalix.com; prefer-encrypt=mutual; keydata=
 xsBNBFDmvq0BCACizu6XvQjeWZ1Mnal/oG9AkCs5Rl3GULpnH0mLvPZhU7oKbgx5MHaFDKVJ
 rQTbNEchbLDN6e5+UD98qa4ebvNx1ZkoOoNxxiuMQGWaLojDKBc9x+baW1CPtX55ikq2LwGr
 0glmtUF6Aolpw6GzDrzZEqH+Nb+L3hNTLBfVP+D1scd4R7w2Nw+BSQXPQYjnOEBDDq4fSWoI
 Cm2E18s3bOHDT9a4ZuB9xLS8ZuYGW6p2SMPFHQb09G82yidgxRIbKsJuOdRTIrQD/Z3mEuT/
 3iZsUFEcUN0T/YBN3a3i0P1uIad7XfdHy95oJTAMyrxnJlnAX3F7YGs80rnrKBLZ8rFfABEB
 AAHNJEphbWVzIENoYXBtYW4gPGpjaGFwbWFuQGthdGFsaXguY29tPsLAeAQTAQIAIgUCUOa+
 rQIbIwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQINzVgFp/OkBr2gf7BA4jmtvUOGOO
 JFsj1fDmbAzyE6Q79H6qnkgYm7QNEw7o+5r7EjaUwsh0w13lNtKNS8g7ZWkiBmSOguJueKph
 GCdyY/KOHZ7NoJw39dTGVZrvJmyLDn/CQN0saRSJZXWtV31ccjfpJGQEn9Gb0Xci0KjrlH1A
 cqxzjwTmBUr4S2EHIzCcini1KTtjbtsE+dKP4zqR/T52SXVoYvqMmJOhUhXh62C0mu8FoDM0
 iFDEy4B0LcGAJt6zXy+YCqz7dOwhZBB4QX4F1N2BLF3Yd1pv8wBBZE7w70ds7rD7pnIaxXEK
 D6yCGrsZrdqAJfAgYL1lqkNffZ6uOSQPFOPod9UiZM7ATQRQ5r6tAQgAyROh3s0PyPx2L2Fb
 jC1mMi4cZSCpeX3zM9aM4aU8P16EDfzBgGv/Sme3JcrYSzIAJqxCvKpR+HoKhPk34HUR/AOk
 16pP3lU0rt6lKel2spD1gpMuCWjAaFs+dPyUAw13py4Y5Ej2ww38iKujHyT586U6skk9xixK
 1aHmGJx7IqqRXHgjb6ikUlx4PJdAUn2duqasQ8axjykIVK5xGwXnva/pnVprPSIKrydNmXUq
 BIDtFQ4Qz1PQVvK93KeCVQpxxisYNFRQ5TL6PtgVtK8uunABFdsRqlsw1Ob0+mD5fidITCIJ
 mYOL8K74RYU4LfhspS4JwT8nmKuJmJVZ5DjY2wARAQABwsBfBBgBAgAJBQJQ5r6tAhsMAAoJ
 ECDc1YBafzpA9CEH/jJ8Ye73Vgm38iMsxNYJ9Do9JvVJzq7TEduqWzAFew8Ft0F9tZAiY0J3
 U2i4vlVWK8Kbnh+44VAKXYzaddLXAxOcZ8YYy+sVfeVoJs3lAH+SuRwt0EplHWvCK5AkUhUN
 jjIvsQoNBVUP3AcswIqNOrtSkbuUkevNMyPtd0GLS9HVOW0e+7nFce7Ow9ahKA3iGg5Re9rD
 UlDluVylCCNnUD8Wxgve4K+thRL9T7kxkr7aX7WJ7A4a8ky+r3Daf7OhGN9S/Z/GMSs0E+1P
 Qm7kZ2e0J6PSfzy9xDtoRXRNigtN2o8DHf/quwckT5T6Z6WiKEaIKdgaXZVhphENThl7lp8=
Organization: Katalix Systems Ltd
Message-ID: <0896e429-d7fe-8205-aec3-83b4b658979e@katalix.com>
Date:   Wed, 22 Jul 2020 19:31:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2020 17:32, Tom Parkin wrote:
> l2tp hasn't been kept up to date with the static analysis checks offered
> by checkpatch.pl.
>
> This series addresses a range of minor issues which don't involve large
> changes to code structure.  The changes include:
>
>  * tweaks to use of whitespace, comment style, line breaks,
>    and indentation
>
>  * two minor modifications to code to use a function or macro suggested
>    by checkpatch
>
> v1 -> v2
>
>  * combine related patches (patches fixing whitespace issues, patches
>    addressing comment style)
>
>  * respin the single large patchset into a multiple smaller series for
>    easier review
>
> Tom Parkin (10):
>   l2tp: cleanup whitespace use
>   l2tp: cleanup comments
>   l2tp: cleanup difficult-to-read line breaks
>   l2tp: cleanup wonky alignment of line-broken function calls
>   l2tp: cleanup suspect code indent
>   l2tp: add identifier name in function pointer prototype
>   l2tp: prefer using BIT macro
>   l2tp: prefer seq_puts for unformatted output
>   l2tp: line-break long function prototypes
>   l2tp: avoid precidence issues in L2TP_SKB_CB macro
>
>  net/l2tp/l2tp_core.c    | 69 +++++++++++++++++-----------------
>  net/l2tp/l2tp_core.h    | 82 +++++++++++++++++------------------------
>  net/l2tp/l2tp_debugfs.c | 11 ++----
>  net/l2tp/l2tp_eth.c     | 19 ++++------
>  net/l2tp/l2tp_ip.c      | 17 +++++----
>  net/l2tp/l2tp_ip6.c     | 29 +++++++--------
>  net/l2tp/l2tp_netlink.c | 75 ++++++++++++++++---------------------
>  net/l2tp/l2tp_ppp.c     | 20 +++++-----
>  8 files changed, 145 insertions(+), 177 deletions(-)
>
Reviewed-by: James Chapman <jchapman@katalix.com>


