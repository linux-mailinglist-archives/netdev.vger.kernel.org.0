Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0147012090D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfLPO4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:56:49 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42791 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728008AbfLPO4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:56:49 -0500
Received: by mail-lf1-f67.google.com with SMTP id y19so4440416lfl.9;
        Mon, 16 Dec 2019 06:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bkfrfJ4drpqKNSromaaooF3QoO5ljkSvB5blBgfp6BY=;
        b=XMZV9LWvV83bL3b0DnFakQ391BhFxKUl8+olYlSlyP7/eMuUfJGrbPb32B1pO9y1u4
         AVqyIFUVtrowSj/K1u4flXZf9dLDErX/3dsdlJ5T/jdcYZaDeIQ3lJHaxjWrhVMOaRL7
         f58j9aj+hi88qMrm+hBfgFO0XLaYwJ7xvUX46SLlWoyxp7oVoB/CsgWiN515iGvItV3h
         7jcWSOrfzYvZ+xRX5Co0BvgnwiDTnerBF9PtVHmSYIfzvJ70EpzV45fxPkl5d53B+QG2
         Ex27nJueNO/caSKU+FGkoC2p5QouwCHtP1zCafOGgG61zS/WL6PUEl/kvpT4ZcL8f3v5
         29lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bkfrfJ4drpqKNSromaaooF3QoO5ljkSvB5blBgfp6BY=;
        b=laqkq7jhTYhl+tqA42fzE6jo0/FOX6lhY7SV4JZZyHIN1bEi/+g34D1TlHtePgaf/7
         B+EJlmOGc8UcQmnhsbVYVQjYQ8t7Pg/GDYNXtfpz2kC4aaIN1kqucrVzqD9OXynT8cLi
         /KYJEEQZ98EHcf//uEnNMzZ7CT22Zk35gbEQWdOuYuLPEUvW/q5fhD2sJ7rfWuN1pwq4
         IytZc9yLAZchY73igvCx3dyuVepxMEo7iR+K/GplAV/LVExDdsTnNBXPQIaECznoFAeT
         RuVvQwm+FHPAq60quwATnLP49Xv/sCdDVaPOloredm8zH8UXkQl4bTbD75Iicd7p2cJk
         v3pw==
X-Gm-Message-State: APjAAAXw8iykkziIZwKVAfeQbFdkSoakUBiXeqiz2oNnRxoyTrfjIxk2
        0QQDRytX9Np6FSMs686N44ornlD4g6KDPoIFJaA=
X-Google-Smtp-Source: APXvYqyxQGTuERj1wFYkfSjcSZwQpqUsjM6Iq1Fv3i1yXOiEkFmdd0ET18P7lTlyrASXfhiAjAj6DHXV9N6RFR+9L/I=
X-Received: by 2002:a19:888:: with SMTP id 130mr17094711lfi.167.1576508207397;
 Mon, 16 Dec 2019 06:56:47 -0800 (PST)
MIME-Version: 1.0
References: <20191216071619.25479-1-prashantbhole.linux@gmail.com>
In-Reply-To: <20191216071619.25479-1-prashantbhole.linux@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 16 Dec 2019 06:56:34 -0800
Message-ID: <CAADnVQL2V98OOiCfnorWg4oKtj95QUxftkeYo4ZxLN-eYjEMPQ@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: reintroduce missed build targets
To:     Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 11:17 PM Prashant Bhole
<prashantbhole.linux@gmail.com> wrote:
>
> Add xdp_redirect and per_socket_stats_example in build targets.
> They got removed from build targets in Makefile reorganization.
>
> Fixes: 1d97c6c2511f ("samples/bpf: Base target programs rules on Makefile.target")
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>

Applied. Thanks
