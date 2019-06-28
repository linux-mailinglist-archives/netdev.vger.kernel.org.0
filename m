Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D64B5A6D6
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfF1WVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:21:45 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37332 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1WVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:21:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so3669958pfa.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tkMDCrFzdOeqv8yBbIkGI5b+jU1pKgPTVqNTvO/wIXk=;
        b=nqus5gaoT6zVaKESv4+fl/QJFT7Fkm11ZWh22pEwLvRy7lVTNnSI/MjXDZK1PnqRm3
         HGqUMKXqXJuNegHQECLsp/NauX3kIuW9F2IwqfyqhebRqBbQ/ic7lEmM5iZtiID4N65R
         +VdzDzwB43eQIDFyVuEVURyCJ+B6riei3oHEvNWGBPV3PIo1+jv2oVdQwgY7bogb34B9
         dL2sgITodrkn62v5F02LekzfcEYQb+CvWOP3CYrTaSP23nHYo2U6dZe2vFr4bHDF9Z7c
         iPoOTzaiuji7nQ46KsYoG8Lw1TNvtiCYLeIM3nD0n7sdnx2TLcNdByy/W3U+wnm37PTq
         phPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkMDCrFzdOeqv8yBbIkGI5b+jU1pKgPTVqNTvO/wIXk=;
        b=BpsQO+v9VrWIUaRTZsDydwsd/snHclUjvUpzsx/xZxwLF5e33d+xUredtxTp/8LmSX
         y21cvbMP+qbWMRx/8zPqcv4gitCDYoINpe64GPe9peHgN3H8MYg1bMiyN+ESgOIAlpqB
         lX8KWTqFYJZr4sJyoZuIDy1LK/QwnjvDgobI38VeUfwlN/nOuVoIJK4iEgUdnja+l3hU
         CkftCnh1PM0OqcMC2RbhY3Iilen5k6SMPUhofSJolAxa0g0gaYWJUqSlRWhFAtiQdJm8
         4+IRBR7/zyKl8q1QwVkBOrdHY9Bv2sfkj66vkKuc5IRBVxZyERCNfXxKHn8601jwgr3z
         gugQ==
X-Gm-Message-State: APjAAAUscw+bJzEI7Qw3bao14SfKhRDsxJmbSEJY9KNdhRcHs0bVU8hZ
        5mmsj/NTwbkMVObRLeVRYx31CA==
X-Google-Smtp-Source: APXvYqx3PPLMlqKuRROB0w1RrK/0hcJrnvD0WscHLb0Mas4qJHW59SGsaBr6K6kIVBzmHg2UKtpC2g==
X-Received: by 2002:a17:90a:ac11:: with SMTP id o17mr16084115pjq.134.1561760504746;
        Fri, 28 Jun 2019 15:21:44 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s16sm3187396pfm.26.2019.06.28.15.21.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 15:21:44 -0700 (PDT)
Date:   Fri, 28 Jun 2019 15:21:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH iproute2 v2 1/2] devlink: fix format string warning for
 32bit targets
Message-ID: <20190628152143.1378fad8@hermes.lan>
In-Reply-To: <7a72ae0f9519e6a445d9712399d989fed648e6eb.1561660639.git.baruch@tkos.co.il>
References: <7a72ae0f9519e6a445d9712399d989fed648e6eb.1561660639.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 21:37:18 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> 32bit targets define uint64_t as long long unsigned. This leads to the
> following build warning:
>=20
> devlink.c: In function =E2=80=98pr_out_u64=E2=80=99:
> devlink.c:1729:11: warning: format =E2=80=98%lu=E2=80=99 expects argument=
 of type =E2=80=98long unsigned int=E2=80=99, but argument 4 has type =E2=
=80=98uint64_t {aka long long unsigned int}=E2=80=99 [-Wformat=3D]
>     pr_out("%s %lu", name, val);
>            ^
> devlink.c:59:21: note: in definition of macro =E2=80=98pr_out=E2=80=99
>    fprintf(stdout, ##args);   \
>                      ^~~~
>=20
> Use uint64_t specific conversion specifiers in the format string to fix
> that.
>=20
> Cc: Aya Levin <ayal@mellanox.com>
> Cc: Moshe Shemesh <moshe@mellanox.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Both patches applied.
