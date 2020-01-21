Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF11434DC
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 01:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgAUAsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 19:48:04 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:38726 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbgAUAsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 19:48:04 -0500
Received: by mail-io1-f42.google.com with SMTP id i7so1000801ioo.5;
        Mon, 20 Jan 2020 16:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=muGQKO5jcbVtHtfxPoG4PyZ3XF34eZZhDHliWSoD5WM=;
        b=PkTqZ7XfeCblc7He33zGQcrlb2wmjuKLebwQZPxDO01Q9XlzUM5/ABDn7sF3OTp0ws
         wfX55eCIeKn3ps+CvQwJjDHTcDV0RGtb0dG221T8ExndHur5jcIWzsMCWfa845ZCVaLN
         +4UbhBNShcLh1Ro4oceNDfTSBiTuP6TSPlhuMRb8H1zMxA9CAae/+8ovwCO/9q4dr4Zk
         oIY9iyIQYcVaEjXHTzCnXJpYOTQ9ZRRkikZtBIhfGK0m4OmQ6T9Xi17bLN8VTU3y0Ih6
         224dPUh1wYKx5ztzG7vLZLZesQdajpEjCAnB7yBIEs3Y5rfWRLOisEfRU/NQyEmeXAiO
         YxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=muGQKO5jcbVtHtfxPoG4PyZ3XF34eZZhDHliWSoD5WM=;
        b=dBs9M5pHE23iPt40YvJaAXHZf7mBJZBiAWDzs706Ciu7d5EQUps1/5/TuV696Yg8e3
         QZ8GVdpr0R/hIN4tOY+nDpxKW1722Tb3BVkNcX+2SXcoMHjpojmXwXm7ImwpVku+DJiS
         abWQjVu5hM89qSsfER9CyIku1IX1rz9NMry0NIl6Zdn3W7rRM9xdnxJw0nVLQeghsHjD
         h/W+89jexYw3xcV5zsRsyLnn8G1/NabkyHfQJX85J1DDg/El7tnST7mqAxSXk5qyjinE
         bZkOvuHRUUk3WRHO7S1bQmbYBcwcyxqPrGDThgvlaa4LdgXMRM4NiNyEKtdKwWTamWdy
         wDsw==
X-Gm-Message-State: APjAAAU/Img7KfC+ZfjHb8Y86oHawFWgIyRSS+iW+XdNh2vLaWC5hTiO
        76QQUQ4WF5c1UDYoMOFRHrI=
X-Google-Smtp-Source: APXvYqzOtFbkyneRwVMD42JhnDwJq1KSFx3XbwWbTQPiIJd/82lOaRVC9QTgY83Q8ig80sjrT2RmiA==
X-Received: by 2002:a02:c90a:: with SMTP id t10mr1343221jao.25.1579567683413;
        Mon, 20 Jan 2020 16:48:03 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a6sm12314327iln.87.2020.01.20.16.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 16:48:02 -0800 (PST)
Date:   Mon, 20 Jan 2020 16:47:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Message-ID: <5e264a3a5d5e6_20912afc5c86e5c4b5@john-XPS-13-9370.notmuch>
In-Reply-To: <20200120092917.13949-1-bjorn.topel@gmail.com>
References: <20200120092917.13949-1-bjorn.topel@gmail.com>
Subject: RE: [PATCH bpf-next] xsk, net: make sock_def_readable() have external
 linkage
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

> XDP sockets use the default implementation of struct sock's
> sk_data_ready callback, which is sock_def_readable(). This function is
> called in the XDP socket fast-path, and involves a retpoline. By
> letting sock_def_readable() have external linkage, and being called
> directly, the retpoline can be avoided.
> =

> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  include/net/sock.h | 2 ++
>  net/core/sock.c    | 2 +-
>  net/xdp/xsk.c      | 2 +-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> =


I think this is fine but curious were you able to measure the
difference with before/after pps or something?=
