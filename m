Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5D5C9335
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfJBVAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:00:51 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33389 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728224AbfJBVAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:00:51 -0400
Received: by mail-qk1-f196.google.com with SMTP id x134so188217qkb.0;
        Wed, 02 Oct 2019 14:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l2G9O3+7DE5ORGmJzqwNWuob8bmZuBAoV+/WACKCtxs=;
        b=PqKyNe0HJDJwzpXYI7RGCYMVcUblYmEqT4OWb30FIoZltu0o+RMYx/Gb3baGrqGS3g
         mVljnER95IW2N2tnFeMn1Dj7cGAT6b0XFbd9dA6moidNYLADlZVY6lqksopFzZS9oYkV
         cMtSZTBXZpQCH4vnJdN4+SIuERvvsWDXcG587w+FaxUldgdlrtWBrrwCsOGVXv1ZgtOv
         rlhqy99Ad811wELKe/e5VhjNhLIx+ctHAnz4nC5u1vK3PM8GxEhF8XJEPu6zSWjnA6Qb
         f7OLWX2SuoEZhT0NWHk7UQWMS9PTO7qLzzUnfxGy1qKArmjRAaK02/uBnAzEV6+SR88G
         3c4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l2G9O3+7DE5ORGmJzqwNWuob8bmZuBAoV+/WACKCtxs=;
        b=Ob4WDHkCgzvlkKlkpf7aJujvqWldXAqr9hNaVnrspeQzk36nLfy9fwb7cmL+ZVkLJ6
         6uiKjgzOmF6Z5TW/5SPg2Kxk/q90cL5vmV1bbMOowGOA4FX117j8YZYV3MxW/uxHvF5x
         /5tERBdXZrNx8XeQJ2Syad7HNxWF1o6QZz3JTP8FNq2himDBcyK7vGe8KN/9XWOfdQNm
         3dpd/FJYwlLf4OsmCguTxDD57mI4mqhLZX+hyACXerG+kqb7ha6+WrmSWWV8llImwEjZ
         DlP037mRJIj4fLff0o6DdnJFt3GAFAF8pFJ7qSUYaHpAlxI006a1FycH4yaQnG0wwJrC
         en+Q==
X-Gm-Message-State: APjAAAWqfZrGIA56p74wTaiuBAGR5zk0LXNrhAShFgSHfhyw76Vkywdp
        iVCUE7JfUZGCtlVrRkmkA299mGn2iHvXiCjhhhU5fwqu
X-Google-Smtp-Source: APXvYqwlobP00MVIwQMUvNwKFieiAiOZXuLaxRQJSvhcyj/XBI+p3EqeAbFYEDFDF1NGG2Qhh9ekretR5ePfDpmsZpk=
X-Received: by 2002:a05:620a:49b:: with SMTP id 27mr822091qkr.89.1570050048688;
 Wed, 02 Oct 2019 14:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191001113307.27796-1-bjorn.topel@gmail.com> <20191001113307.27796-3-bjorn.topel@gmail.com>
In-Reply-To: <20191001113307.27796-3-bjorn.topel@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 2 Oct 2019 14:00:37 -0700
Message-ID: <CAPhsuW627h-Sf8uCpaE4eyu+wpkOPK+6eXkOhwMBnvFVVDQdKQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] samples/bpf: fix build by setting HAVE_ATTR_TEST to zero
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        adrian.hunter@intel.com, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 4:36 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> To remove that test_attr__{enabled/open} are used by perf-sys.h, we
> set HAVE_ATTR_TEST to zero.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Song Liu <songliubraving@fb.com>
