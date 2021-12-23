Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A59147E8FD
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 22:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350324AbhLWVTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 16:19:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40356 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbhLWVTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 16:19:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40DD061F91;
        Thu, 23 Dec 2021 21:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA63C36AE9;
        Thu, 23 Dec 2021 21:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640294345;
        bh=RHwR7WJnTDGHXUR+NlikicbsjnB3cUEtRLcjjNBCDdI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ms47wMwQ5bSMZzlGNt1qIns2K5kVThKoXd7e938Yd+RYxGappMdZ9P9hGHax/vz0c
         so3KAjEt9dAtJ1+Jr4sxu1o+7Nj/tBwFtkeq1ZWaEpu6+IIuAGo0ng1lfSvR4CdlJB
         8LIsm9OOuMseMIMRf7LUulx2OfCAua1Rnq0HRKpnt+P4QnFoHI4KbpoQnOTvPHzDm7
         pHgiavo3NAJACrgVglfxzthKmVe5DmWsSvX8neOfCRgytf8Gq6h/uwaIRKLqOA33tm
         AxCB2aJi6bXQBnzQ1y0Wi5bULn/DUeWIt+/Ag18gm9iRxaaIOcgLiK4D9XuspQIUPN
         NWKsE2mbCbjiA==
Received: by mail-ed1-f43.google.com with SMTP id z29so26038699edl.7;
        Thu, 23 Dec 2021 13:19:05 -0800 (PST)
X-Gm-Message-State: AOAM5330ESLaUH5UIVAUgCWbJso4y4FtV4a1zVGizZG1SfIWKVt4SZLc
        gSTFXfglANfZJo+x9hDVpoGS2NKYqiyrL76rxg==
X-Google-Smtp-Source: ABdhPJzi5ldYUkBvCrQJ/P23jc2Mhr2nETWi9GjrXsmkOXNTU7ndvABfAN+OgXiAUuPyp+SfEtlmtIzFARpBZb0X6rw=
X-Received: by 2002:a17:907:3d94:: with SMTP id he20mr3155428ejc.14.1640294343703;
 Thu, 23 Dec 2021 13:19:03 -0800 (PST)
MIME-Version: 1.0
References: <20211223110755.22722-1-zajec5@gmail.com> <20211223110755.22722-4-zajec5@gmail.com>
In-Reply-To: <20211223110755.22722-4-zajec5@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 23 Dec 2021 17:18:52 -0400
X-Gmail-Original-Message-ID: <CAL_JsqK2TMu+h4MgQqjN0bvEzqdhsEviBwWiiR9hfNbC5eOCKg@mail.gmail.com>
Message-ID: <CAL_JsqK2TMu+h4MgQqjN0bvEzqdhsEviBwWiiR9hfNbC5eOCKg@mail.gmail.com>
Subject: Re: [PATCH 3/5] dt-bindings: nvmem: allow referencing device defined
 cells by names
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 7:08 AM Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
>
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> Not every NVMEM has predefined cells at hardcoded addresses. Some
> devices store cells in internal structs and custom formats. Referencing
> such cells is still required to let other bindings use them.
>
> Modify binding to require "reg" xor "label". The later one can be used
> to match "dynamic" NVMEM cells by their names.

'label' is supposed to correspond to a sticker on a port or something
human identifiable. It generally should be something optional to
making the OS functional. Yes, there are already some abuses of that,
but this case is too far for me.

Rob
