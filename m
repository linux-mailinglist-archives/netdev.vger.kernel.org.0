Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1177132DD5
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgAGR7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:59:49 -0500
Received: from mail-il1-f179.google.com ([209.85.166.179]:45816 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgAGR7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:59:48 -0500
Received: by mail-il1-f179.google.com with SMTP id p8so306128iln.12;
        Tue, 07 Jan 2020 09:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EyfQdFuFKD+ndJyiFY/xMTNyClAbOXuJiQ4/wawRF1g=;
        b=uuE6kL6ruGM027KLhnczR5/Rp49hBaApHnvShJYa6z8p2YD5gcKkRi7ftVFtiN7Wxa
         nL9PE3584MOVQyVd52tr32HoFFeMyPp/vD1whrgbvi2Sd/iP9/axHGwsjN1EYh9xwYNa
         gstq/UE1atkUWFj2XkUpzVZN6S+IerAeN1/lP+sVKGyRoC0iYuFRZGJx3sUtPD3iH/bc
         Vq0wB4olGVI6LuhYJMpXMajDst4A08J3QEIaNKV431RKM0G3JDPRQCPD0ekMyFG/1M0V
         u78JZcFLFAVk0mygL8LiamL0s3RJ11Zu9SsEJoIgRWkC6iMsAZYU0jVrqgd8sQPnHqTa
         12Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EyfQdFuFKD+ndJyiFY/xMTNyClAbOXuJiQ4/wawRF1g=;
        b=uBrjyUMjDgEQL9CxxShmrHvMN0aBN9orGFP+yaJFLebk9z6X16F1HoVTOXxsRN0ItT
         Ov19o/n0dOHmpUEBe7PkFtNz+j5g9pOcQSaKQiFMUVNUorESSFaVEpM5rcn9vWRBOy2E
         aNoaRznsHbKxi6WXy46eatk3mvkf/uYFptLredzKRoa06mfn08jAwtmPc+lmw9BhT9Pk
         vmuSP67yjLeNgPoEEkhARYpBDnLldeZruLRkFM+LgqOdbh+2keua51ZAepwToY1rGl05
         EShmJRXK2J3hXNpRBgAv8Xnhvf8IcjBgXbTVtGqYPeNNRUTry1nV1c2QttuFJFs64KX/
         sdDw==
X-Gm-Message-State: APjAAAUxIUG1gxEOPqXddX9YkUzMb7/ZSjoHUY/0rJXUxkGmAvob6IMK
        tHKE1007FXDsNDYNcDBtX/U=
X-Google-Smtp-Source: APXvYqyT63L/3fFvpHc7D34ANN84SGAdv4YiYFRg7RfLpM/rnD8/yG8jd5dkV9AQLPljJwdpUuZqiw==
X-Received: by 2002:a92:da41:: with SMTP id p1mr260817ilq.65.1578419988037;
        Tue, 07 Jan 2020 09:59:48 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j79sm93853ila.52.2020.01.07.09.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:59:47 -0800 (PST)
Date:   Tue, 07 Jan 2020 09:59:39 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <5e14c70b357dd_67962afd051fc5c0af@john-XPS-13-9370.notmuch>
In-Reply-To: <20191219061006.21980-7-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
 <20191219061006.21980-7-bjorn.topel@gmail.com>
Subject: RE: [PATCH bpf-next v2 6/8] xdp: make cpumap flush_list common for
 all map instances
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> =

> The cpumap flush list is used to track entries that need to flushed
> from via the xdp_do_flush_map() function. This list used to be
> per-map, but there is really no reason for that. Instead make the
> flush list global for all devmaps, which simplifies __cpu_map_flush()
> and cpu_map_alloc().
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---

Consider *map_flush() -> *_flush() change but thats just a small nit
its not too important to me.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
