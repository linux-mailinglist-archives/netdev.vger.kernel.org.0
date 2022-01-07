Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0523487B8F
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348602AbiAGRkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:40:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59084 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240245AbiAGRkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:40:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2F57B82665;
        Fri,  7 Jan 2022 17:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AA1C36AEB;
        Fri,  7 Jan 2022 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641577232;
        bh=VLwKf3ATaUz5mtFG1e07pkxhzZK/26Mq/+1dQv9vypw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oSolu8oeDUzMnYsUXzih+phxME++IYu3u/BKFS23Ca3DBfEMeAe4E1yvjvlQbX4eK
         STJtKGiQkdG0Wsqr4okLAnenBpVvlGAM7vGD2H4kulnwznnRrGNSVypzOsfZOGly+k
         POFBn08w8140W6sKeBROUyM4FTOlaxfNdworuEmrqGsEKHytykqazE3Z2ZCDR+Yhdw
         N9d9i4mmwTNBMT9ZoloDyPMeUV1jgTIfbVK9jpOt6ZONwSSL7nHHGgVFS23hZeMgxa
         k3NwHWPaElI3uFpeVTf9CayXM6hGtxQkhjV9hRQz4YqfoLno9XbQK64ogZjo0IvDbX
         qGiOHJrUr5X4g==
Received: by mail-yb1-f180.google.com with SMTP id p5so11502286ybd.13;
        Fri, 07 Jan 2022 09:40:32 -0800 (PST)
X-Gm-Message-State: AOAM532XmA13GpgGj3VCe9OGlygg9IysUubwdpJoTofrdWFCbQWlizkt
        h63BYYryYb4ECdI+IN7fJJag3KK6Sqy2DsTA0nM=
X-Google-Smtp-Source: ABdhPJyPb3DJNPVYqFGGYFgovT8G52jAJ9roqxfYTp31t0blJhptUs+/yHUvwTrDOCo2QtLafD/ed3/GO9r0MxM/MgU=
X-Received: by 2002:a25:8e10:: with SMTP id p16mr72019278ybl.219.1641577231541;
 Fri, 07 Jan 2022 09:40:31 -0800 (PST)
MIME-Version: 1.0
References: <20220107152620.192327-1-mauricio@kinvolk.io>
In-Reply-To: <20220107152620.192327-1-mauricio@kinvolk.io>
From:   Song Liu <song@kernel.org>
Date:   Fri, 7 Jan 2022 09:40:20 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5ueryw6195bvR=eMZpCXdYjsyMyO_kKwjFBz4BiC6cag@mail.gmail.com>
Message-ID: <CAPhsuW5ueryw6195bvR=eMZpCXdYjsyMyO_kKwjFBz4BiC6cag@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: Use IS_ERR_OR_NULL() in hashmap__free()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 7:26 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io> =
wrote:
>
> hashmap__new() uses ERR_PTR() to return an error so it's better to
> use IS_ERR_OR_NULL() in order to check the pointer before calling
> free(). This will prevent freeing an invalid pointer if somebody calls
> hashmap__free() with the result of a failed hashmap__new() call.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>

Acked-by: Song Liu <songliubraving@fb.com>
