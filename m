Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F61350FB6
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 09:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhDAHB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 03:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbhDAHB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 03:01:27 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9118DC0613E6;
        Thu,  1 Apr 2021 00:01:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w18so769955edc.0;
        Thu, 01 Apr 2021 00:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RfyP1xiGI0VpUoYZLnJKoM6XTKZ7fkZlrS16zaUSR6g=;
        b=rqLBX5P2cgwitwagfOy/0gCQ9NoS3CwVGbOo94AyfwnQmvxu7eicPdSg3kCWXsTqjJ
         oWpEdTPoLXxX829vz9WII0BI38rVeN6RFJjV5zwYi4BlP/GeADHlOvhvT2+0gpRJidka
         nDNN12uA116WyVU7a+QqzCKVEMxbsuiUBYEf5v525Gd/tJ8DUaSp3L5IoGouL/F/HHr/
         ABDVDgjNomSvmAyJdxjXZTNYPxy/be4zQTK5HfcpGIFKw1UxH/EETFVImnyajv3xQRfP
         3ez3ycNrtZRvaa3U2A6/lXcxcNxlsOq2U3fVwHqg0OgOq6E3Y7OaY9zwUpnY041jE6y3
         Vbuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RfyP1xiGI0VpUoYZLnJKoM6XTKZ7fkZlrS16zaUSR6g=;
        b=A8kKCifawOe+b9KauvT8mQh9Covxa7Us259SpynpEvRuVmwf5VXajoiJzKxI40BM8E
         jFMPT71tqEN13vMMGhg4Vc31nd5nKvRGeIQtP1l2mE6+yL1bNtrza70XQnfNSjCJNHb0
         YtmDZdKDEJ5rSr7aupU1aniae3jDInRDX1dsFZhZp3OFTN9+Sp0Fe6txldDojbhK1eoY
         VnTMBSe7RJIkjk/ftTi7fnUtJpoE3FLZU9irWlJpZ9PFY4yGLAumHwiUOkgqcfg8sD/i
         ca4E3kv8p9jqZi6WkOoAXF1DX/yaD+zoeoPiwaxnla5tOORK2iWgjC34Z3SH9kd6WrTs
         QjhQ==
X-Gm-Message-State: AOAM533DLe7IwLs4juUfHvQmPaHdBBIgj4/IQhGxLL8sSjnZUy/IgGUC
        BSeIdgCvCW7C1GtDRDGiLjeWUnU5beT03g==
X-Google-Smtp-Source: ABdhPJx1rOsRL6ERpIo6ABY/A+PeZ5Ux5v8owULBf+BYHys10hI2pN3YeP87FYoweTZOzT/JP44ccg==
X-Received: by 2002:a05:6402:614:: with SMTP id n20mr8085285edv.58.1617260485397;
        Thu, 01 Apr 2021 00:01:25 -0700 (PDT)
Received: from ?IPv6:2a02:908:2612:d580:40bf:92ad:5605:7d95? ([2a02:908:2612:d580:40bf:92ad:5605:7d95])
        by smtp.googlemail.com with ESMTPSA id e26sm3184802edj.29.2021.04.01.00.01.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Apr 2021 00:01:23 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ...,
 ...)
From:   Norman Maurer <norman.maurer@googlemail.com>
In-Reply-To: <4ba2450c-413a-0417-e805-2486ab562df8@gmail.com>
Date:   Thu, 1 Apr 2021 09:01:22 +0200
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        davem@davemloft.net
Content-Transfer-Encoding: quoted-printable
Message-Id: <85D1EA5E-BC43-45AD-B714-C35EE5CB2AF6@googlemail.com>
References: <20210325195614.800687-1-norman_maurer@apple.com>
 <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
 <CF78DCAD-6F2C-46C4-9FF1-61DF66183C76@apple.com>
 <2e667826f183fbef101a62f0ad8ccb4ed253cb75.camel@redhat.com>
 <71BBD1B0-FA0A-493D-A1D2-40E7304B0A35@googlemail.com>
 <4ba2450c-413a-0417-e805-2486ab562df8@gmail.com>
To:     David Ahern <dsahern@gmail.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 1. Apr 2021, at 02:18, David Ahern <dsahern@gmail.com> wrote:
>=20
> On 3/31/21 7:10 AM, Norman Maurer wrote:
>> Friendly ping=E2=80=A6=20
>>=20
>> As this missing change was most likely an oversight in the original =
commit I do think it should go into 5.12 and subsequently stable as =
well. That=E2=80=99s also the reason why I didn=E2=80=99t send a v2 and =
changed the commit message / subject for the patch. For me it clearly is =
a bug and not a new feature.
>>=20
>>=20
>=20
> I agree that it should be added to net
>=20
> If you do not see it here:
>  https://patchwork.kernel.org/project/netdevbpf/list/
>=20
> you need to re-send and clearly mark it as [PATCH net]. Make sure it =
has
> a Fixes tag.
>=20

Done: =
https://lore.kernel.org/netdev/20210401065917.78025-1-norman_maurer@apple.=
com/

Thanks a lot of the review and help.

Bye
Norman


