Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB854311900
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhBFCwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhBFCm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:42:58 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A724C08EE23;
        Fri,  5 Feb 2021 16:36:21 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id d85so8822627qkg.5;
        Fri, 05 Feb 2021 16:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=soHf/mVkpp4EzKMqVWUbreRz7Dg6N9YiICzzPMnFLgM=;
        b=Y9A7DrF+GRyVSqLlIWAqpZjRpK1BnR9AU2oy9l86xnICu0C06khdlyvebXTfsufVp3
         qFSv0lMNhC1k5+7lThnQodAGRE763h5hO88FyePg4nrSXHNeiEfBumRk6AWZPimWkqkx
         qpucA2uG8pS3xPePjOBfBdzdAh2BRp2r9/sjSEL4yFkSyvjsn8e1T9bGXEaW4RqBpFgW
         6cak4g6ZOB0CZkxYIVnu68wmId3mTHWLJlx/4HDFfrhCcR4NwZDykcxtCAgmmHgWOix+
         YTvstD48fvj7uMBiYjruR3sYmtxebP5PUMajHbfyZ8bhIIxnGmXnwwnxKYbXqNrCGHbg
         YQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=soHf/mVkpp4EzKMqVWUbreRz7Dg6N9YiICzzPMnFLgM=;
        b=jgczVR/sUodzDmuXZOWRE/ugDdYr3d6hc/IA7Rzp3BxksOOuYIWFmZ5K0G7D9zpYR+
         nrUFIyqrlO7cz34+DKy9p9d3bv4JQG45UKjq/+X6DBok0QQQwWvxFhhEweIHqsFjzc7S
         ymJ4YJqKaJsrlxSQmghrESG0rhemIiPSUtt2f8K7Qwp7tc39Ua6zIlQFwM+qVzcs6xuR
         5lUDF4ZfebKMSP3a5EqfRqzS09zc4IGGbavsPQgTfjwoD3SBx5xYKGHABw2dw4VGd8E3
         LR57T9JoNztEHVEUXEKSIZu9JIyjawEw2eO4bAeJKMovNx2NTTW1Zzjpg2N9z1scSDRZ
         28GA==
X-Gm-Message-State: AOAM530AJ7gADb9+udc1dqiZvHNxzCzd/rAf47bwdU++gr8lcgpFAdpa
        MslHOq4YmNV1C9urm6v8Dis=
X-Google-Smtp-Source: ABdhPJwGuyt+FQ9iasR9NXAGsXzScwo1mYEEWKSB1Fesweuwl/pT6uyUcJFKwh24uzoUC4vYfVxNxw==
X-Received: by 2002:ae9:ed04:: with SMTP id c4mr6833524qkg.289.1612571780538;
        Fri, 05 Feb 2021 16:36:20 -0800 (PST)
Received: from Gentoo ([156.146.58.50])
        by smtp.gmail.com with ESMTPSA id z23sm6931551qkb.13.2021.02.05.16.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 16:36:19 -0800 (PST)
Date:   Sat, 6 Feb 2021 06:06:46 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     pmladek@suse.com, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] lib:  Replace obscene word with a better one :)
Message-ID: <YB3knt9yx4CQ5Q+g@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, pmladek@suse.com,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, rdunlap@infradead.org
References: <20210205121543.1315285-1-unixbhaskar@gmail.com>
 <20210205145109.24498541@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UxWCXiFroMay8coY"
Content-Disposition: inline
In-Reply-To: <20210205145109.24498541@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UxWCXiFroMay8coY
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 14:51 Fri 05 Feb 2021, Steven Rostedt wrote:
>On Fri,  5 Feb 2021 17:45:43 +0530
>Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
>> s/fucked/messed/
>
>Rules about obscene language is about new code coming into the kernel. We
>don't want to encourage people to do sweeping changes of existing code. It
>just causes unwanted churn, and adds noise to the git logs.
>
>Sorry, NAK.
>
You are spot on Steven.Thanks, man!
>-- Steve

--UxWCXiFroMay8coY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmAd5JoACgkQsjqdtxFL
KRVJjwf9HiNq6piH7OOkVeCIFZ612OrZ09mEwQcxP8AN0TtxgI7eNH0k73SM4zMx
8OsmrJRLv1+2dD5Uuzv825rUldYu7+TBYxdy7/RsLd8diK5y2f7fl5SbfytzkWIG
DxzPBvwCJAFv1To3AkzA1v4DIPuUhHpYcesaZPgyOr8XVm+R8IlOQ/fkihN4IDxh
HLhlNCyP0FA/dMjS58ZJ9ZP/pyr7ivf1ufsou5bHTDcswmnsH40/D09wiLxBuQTt
+n8vON8abYdMtQK2bsvy6EMMZOBQUD7NA/yeszv7A/5za7QrSoj2TEaqx5+uSVod
pS00qbw3qijXtJlgJwsbloLxM2jyRQ==
=lyJS
-----END PGP SIGNATURE-----

--UxWCXiFroMay8coY--
