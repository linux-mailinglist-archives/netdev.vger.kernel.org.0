Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A06A22B54F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgGWSAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgGWSAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:00:04 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EF6CC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:00:04 -0700 (PDT)
Received: from [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539] (unknown [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 89B078AD73;
        Thu, 23 Jul 2020 19:00:02 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595527202; bh=qSc9RjtpnKYPjEf7tC9i22iwLP1vjuB+Wy32HVvR31Y=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:From;
        z=Subject:=20Re:=20[PATCH=20net-next=200/6]=20l2tp:=20further=20che
         ckpatch.pl=20cleanups|To:=20Tom=20Parkin=20<tparkin@katalix.com>,=
         20netdev@vger.kernel.org|References:=20<20200723112955.19808-1-tpa
         rkin@katalix.com>|From:=20James=20Chapman=20<jchapman@katalix.com>
         |Message-ID:=20<5546fc8d-4c5e-c009-455d-4349833fd8c5@katalix.com>|
         Date:=20Thu,=2023=20Jul=202020=2019:00:02=20+0100|MIME-Version:=20
         1.0|In-Reply-To:=20<20200723112955.19808-1-tparkin@katalix.com>;
        b=j0fSRrcWSHoe66gVTkD6fecz0lXUdbXFmhNgyI6OdPImsaXFpf9nRU66E2m09smOA
         PWMMNjTo4GLBsUCTmBwsNCx/RIbzD/Pked/bEsIdqE7grpHPhodv6FGVjjDc7ee6Mp
         SNNryAML4qyOnsBPva6EkDw3WdDaLX57OCJLHGZt2TsL852rySYFa7Rs0ah+HFeu9B
         MGv+VcOfDCxmUADMEfqIGNaaxiu0PDGu/dyo5Mm5rfrfsxZzHeLo+H3cYaAsg9KQg3
         coggtJGSuwOYtG+ircvAmWkrNzHz6hPOiqSganxv7lIz/fByY3ATpcqnFxQcIpJQgx
         WTYwoKP64wmKg==
Subject: Re: [PATCH net-next 0/6] l2tp: further checkpatch.pl cleanups
To:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
References: <20200723112955.19808-1-tparkin@katalix.com>
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
Message-ID: <5546fc8d-4c5e-c009-455d-4349833fd8c5@katalix.com>
Date:   Thu, 23 Jul 2020 19:00:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723112955.19808-1-tparkin@katalix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/07/2020 12:29, Tom Parkin wrote:
> l2tp hasn't been kept up to date with the static analysis checks offered
> by checkpatch.pl.
>
> This patchset builds on the series "l2tp: cleanup checkpatch.pl
> warnings".  It includes small refactoring changes which improve code
> quality and resolve a subset of the checkpatch warnings for the l2tp
> codebase.
>
> Tom Parkin (6):
>   l2tp: cleanup comparisons to NULL
>   l2tp: cleanup unnecessary braces in if statements
>   l2tp: check socket address type in l2tp_dfs_seq_tunnel_show
>   l2tp: cleanup netlink send of tunnel address information
>   l2tp: cleanup netlink tunnel create address handling
>   l2tp: cleanup kzalloc calls
>
>  net/l2tp/l2tp_core.c    |  30 +++---
>  net/l2tp/l2tp_debugfs.c |  20 ++--
>  net/l2tp/l2tp_ip.c      |   2 +-
>  net/l2tp/l2tp_ip6.c     |   2 +-
>  net/l2tp/l2tp_netlink.c | 206 ++++++++++++++++++++++------------------
>  net/l2tp/l2tp_ppp.c     |  59 ++++++------
>  6 files changed, 169 insertions(+), 150 deletions(-)
>
Reviewed-by: James Chapman <jchapman@katalix.com>


