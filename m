Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D093F9ACE
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 16:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbhH0OYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 10:24:48 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:41484 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230108AbhH0OYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 10:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1630074235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KEjz5evJg2EczOGmSlnq51/PxntQ9pR11olxKUG5rRk=;
        b=cAyXg81SlGRs0E0GALlP2T7npJJxqpDQNwRTlH1B2P9b8ozYThPQU9OjsGi8f9MSDvLchy
        L8Un5INyYHxWSUnj6kW2zq/tiYQhXsKt4FK8sK6V1pgrcbmvnqWI9hhMcur3MnTWde/uMZ
        M2pXl6NhSEIubW8GhEttL/PUK0kiwmQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a1fcabec (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 27 Aug 2021 14:23:55 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id z18so12833763ybg.8;
        Fri, 27 Aug 2021 07:23:55 -0700 (PDT)
X-Gm-Message-State: AOAM533qHEjdwUDlka7FKAyxvRtDGdeYkz1QYtRLibOeElz2mfNUhp/j
        dBhTVtFb4J+oCcIjiSVv/Tb4nyg+5nvkHOhsck8=
X-Google-Smtp-Source: ABdhPJyAAEv+IaW3g9PGOJXFUwNWdyuIi16hioGbKZ45fZSFvFhUo2gxjgBReCrxWL8PXaXjbLJx7mZqXUN1TdnpMxE=
X-Received: by 2002:a25:a109:: with SMTP id z9mr5325821ybh.279.1630074233917;
 Fri, 27 Aug 2021 07:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210826015847.7416-1-lizhijian@cn.fujitsu.com> <20210826015847.7416-4-lizhijian@cn.fujitsu.com>
In-Reply-To: <20210826015847.7416-4-lizhijian@cn.fujitsu.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 27 Aug 2021 16:23:43 +0200
X-Gmail-Original-Message-ID: <CAHmME9qh81gzTTSzVDCxkc2MuLw-PDs7TfnO0=k1smXmK-1Zfg@mail.gmail.com>
Message-ID: <CAHmME9qh81gzTTSzVDCxkc2MuLw-PDs7TfnO0=k1smXmK-1Zfg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] selftests/wireguard: Rename DEBUG_PI_LIST to DEBUG_PLIST
To:     lizhijian@cn.fujitsu.com
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Philip Li <philip.li@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Aug 26, 2021 at 3:54 AM Li Zhijian <lizhijian@cn.fujitsu.com> wrote:
>
> DEBUG_PI_LIST was renamed to DEBUG_PLIST since 8e18faeac3 ("lib/plist: rename DEBUG_PI_LIST to DEBUG_PLIST")

Thanks for the patch. I've queued this up in my wireguard-linux.git
tree for some rounds of CI, and I'll send it back out in the next
series I send to netdev.

Regards,
Jason
