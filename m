Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF1F34EDF4
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhC3Qdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbhC3Qdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:33:41 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72330C061574;
        Tue, 30 Mar 2021 09:33:41 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id q29so24637447lfb.4;
        Tue, 30 Mar 2021 09:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UFy3jM0f6ak9qovolyhNeWkPsyrWEmyNv65AWugmHdY=;
        b=heYfM+1WsOlG+zpvIh4FaRgw0pmukeGBJywiE0EJY9kxPKY2gj4/5+nTwvFWrfiTk5
         Uo0w6WB0tR/fIwwTKNGj5nAYt2B9qautGSB8E/tokzwEmgmVf3oGjGdfdqIO9QgCiDWZ
         pSLqa+XFLr1E0Z7doU2jt7AMBL0+7gC9DqeiAzoQEdzLG68uvu+f8JY52NeNJaaw/fQg
         PDtgy0iAErwxEXHfmmO2gADr5f9a71O03bbSjHTHQ+YuQx4srFNAdhbrTu4vRBj6DBuv
         lTeROsH6/6Set3XcNwNnWT998GO2+mmGha+lkENxa3zP10NJGoxnn758Nvo1mfPtL2XZ
         QYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UFy3jM0f6ak9qovolyhNeWkPsyrWEmyNv65AWugmHdY=;
        b=Er3dkTTVRt5Q8p4+1y402KTyru/LK6IAMgKOuBVTRt08kNiPzuLZxuU8LB/fHsGXoV
         +UAc71Y1we6VMRw7S6U9frlym1BxNFo433eaaIeQS0c+uzERPtTFA5ZDml82fzPxHIpx
         B22yB6AHer6dSp221tB/KDO9+crhe+3E5r4InwMdNbNRWtR4+pnIL3zYPoKmrpn8kCF8
         LE2qjAwmwFgOYQTmtqELip84AqVW/kb48AdFC/NHnuDdt6rAgDHrBhfR4NwDpBF9sEmA
         lh+LQdpJW6iRrYGMry0z1xxUOJZw8+2Zm9GjkzU8m3iSvXA+WilDvogpoQEp2lc7BOSg
         onXQ==
X-Gm-Message-State: AOAM530iDe3S7eEjrMTeEI+JQEA8MqYMqE6DOSyIg/0UtWYMrFcTaqPx
        LKjAv/nnKd33/5qMGjwQj1jSyNXIHP+zz5Tav1o=
X-Google-Smtp-Source: ABdhPJwakWnoalmCuIszSD8J4Fc3DWFhzx/lO0v1nkS+hdsVn54IUASGSWS6pg4pK6WMQhk+x9mzMqPrVlcY46gVaeY=
X-Received: by 2002:ac2:5b5a:: with SMTP id i26mr20306926lfp.182.1617122019535;
 Tue, 30 Mar 2021 09:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210330054143.2932947-1-kafai@fb.com>
In-Reply-To: <20210330054143.2932947-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Mar 2021 09:33:28 -0700
Message-ID: <CAADnVQKdP+WLo9CSGDJkLpReaG2ibrUZvtnqU+y6iqEgaCQP=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] bpf: Update doc about calling kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 10:41 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This set updates the document about the bpf program calling kernel
> function.  In particular, updates are regarding to the clang
> requirement in selftests and kfunc-call not an ABI.

Applied.
