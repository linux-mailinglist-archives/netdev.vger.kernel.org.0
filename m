Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB75F6AD4
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfKJSfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:35:48 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38435 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKJSfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 13:35:48 -0500
Received: by mail-qt1-f195.google.com with SMTP id p20so13211255qtq.5;
        Sun, 10 Nov 2019 10:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M+7XtFRR1aFUJ5RUHT/ta5/osbGsH0+8LVuCJxRQH00=;
        b=o9jZzuVpAgavEg97GZZ/1x1Kg5DDDTb0pR9b5BhIKP7Mm2EgFRcidzXXWGeIl7afmk
         tb6qVJrSB6C3dY1p6WeW3N2c56cocVJHB4fSpkdtZEXTCN0aRdAPrIgskNv5dU6cQV7E
         G9B/jkhV8qgUZBwslMr0OkrnwguduEHk3uotr2grtUTWIw3l9mPFf0TbxJg3Jx43MlK4
         /QUNTmqaPYBHx+dvWytUPTCkuNioJU2v4IOupVTrZx222YOwt6Dy5aMNk2FKfScGEGDb
         re23njS/wtWf+v8iv6p+BMgchSzbzHn59lYTxsp5raQROkQrbpXTGheSdI2OSOvjSHIp
         AG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M+7XtFRR1aFUJ5RUHT/ta5/osbGsH0+8LVuCJxRQH00=;
        b=Yg1Fpyg4yaFytb1GzlE8iuBILsPTr3SEef7yic67WJdu4vtumzBIGGT8Gdf9JcRqp+
         m5fWQH69heYUoTC4AmNNQ+05HaX38vzbL3l17gcKM5PXMfGO/vOTtLGBm9PUXwjv2hal
         +1UlF4rXCVIHbBBX0q7QFbdqQSx3L7ZwuqUn1/V1/smBqG3ieAnrtIAybAZqsaKjVUxu
         6GUGqS/v/3yGGRkSQUTRWRTPfDxJMpW7Oes7emmpNOj2/JcLxaJvddQrT2leurYkqMCo
         8RbRTR9v1lE8FEzRtaG5dGuEoBDxzP+lW43P9JsoqJbj5+U2pg6TPXYsc2MIhjWuN5BG
         I5CA==
X-Gm-Message-State: APjAAAVGI3MzIlGINMS0Kc5Yhpqdtd/CyJWj4GMa1UQvhiOi2pFLA6zj
        dVh7eO8hZoaZs5MsUot2M9sQJlRukoVk3BRH7zOmNF1x5Dk=
X-Google-Smtp-Source: APXvYqxM/HK7YEbXQUxq2BrqICxpBhgxJ/H1ynd7F+hb8D9ZieLu1E1M2Xw1lpJMYHsJXxUFHLM92JJ7VwyRqs9LN90=
X-Received: by 2002:ac8:17ce:: with SMTP id r14mr22870237qtk.301.1573410945893;
 Sun, 10 Nov 2019 10:35:45 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-6-git-send-email-magnus.karlsson@intel.com> <7C1BBFA7-8811-46CE-BDCF-3F93F5AB1C6F@gmail.com>
In-Reply-To: <7C1BBFA7-8811-46CE-BDCF-3F93F5AB1C6F@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sun, 10 Nov 2019 10:35:07 -0800
Message-ID: <CALDO+SZx+TbDH-PhpF52ypPmgg6EovSnjXw33SbxqFsdYU78cg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] xsk: extend documentation for Rx|Tx-only
 sockets and shared umems
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 3:03 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>
>
> On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:
>
> > Add more documentation about the new Rx-only and Tx-only sockets in
> > libbpf and also how libbpf can now support shared umems. Also found
> > two pieces that could be improved in the text, that got fixed in this
> > commit.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Tested-by: William Tu <u9012063@gmail.com>
