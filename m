Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6FE5FC93
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfGDRh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:37:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39716 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfGDRh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 13:37:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so6908470wma.4
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 10:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B5nIfwYWmjUNgUUiv6hekzxAO6Dp8+9khx/LeA0BFcs=;
        b=Kc5gVuijZStvTeUxfmwsoWw2Tb/A4W7Er185KF+/Ef2mefoDnMREFsjqljjUFEvn0s
         6OPe7/LeO9t5aFQ/pMvtGRLqSXlmqBuCnWKTIbLd76CsESuzFo0kUVAHL8hTcw7VnwNW
         HEP6zmY/YDSF/1ljQ2ZO7jBnAXZ17R6JjVuaOpcWPOfm8oDWZBN2UKb95oUNOuXtTQ06
         I+XOUuMf8rxYHY/cE2/frOLlBTphSkpP6Zw+lVN6Vf3Lyd4/EaOrFXAL7dVAn6Sphj/I
         NfcgEN6jYSHzwXp53aFZWdSdJpRcFy3TwyTahAnIEr41w/vBFQGKTUoISwEmsXNi3ldT
         /Brw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=B5nIfwYWmjUNgUUiv6hekzxAO6Dp8+9khx/LeA0BFcs=;
        b=YxV57RC3wrIQrFzI6gcoN8toEYq1RqfrfQJMP5sFruJRCR19+vAmRqLtlWE9tz/6Aw
         kcVoMtbzKDn6Kz4ULmyfvn9kQdyI9N+g0Tsdx67PBnPz5shFAU8rRlgc+87rC5KNJ3zV
         zZmuVNVnH2USnpjEVvfI9M4+Kcb2mgu3NoYn3s/DeBZ1URDIC9G4jt8ECzTaWqL0zpLp
         NIeyORiJ2w3iY2w71c1JQrjLVdSJZCeleVm54ZLM2BuFgq8Epb2kV9OZdZT7bDyXg/Tt
         PhQ+bPb7zqh+lJQgN92OpRCsN/SzjfmjFkqxDU6Wf5cVu0zXkfAeH8/Ga4AMwGObkakA
         9y2g==
X-Gm-Message-State: APjAAAVEAu5z0bvSNfFjAjWNvquUJG7iasf8AZF6RTKh1btewZsPT22a
        7pp2rpAr0vwI+yMPaGL48ZOdWQ==
X-Google-Smtp-Source: APXvYqytX0NxwogWuQ3awjhcCBOCzKFYg/arRPGqjwm50OTUKsD0mrx+Cx+r0G3KvgeK4AVA8tMo2Q==
X-Received: by 2002:a1c:2e16:: with SMTP id u22mr433969wmu.80.1562261874602;
        Thu, 04 Jul 2019 10:37:54 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id m9sm6488541wrn.92.2019.07.04.10.37.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 10:37:53 -0700 (PDT)
Subject: Re: [PATCH] tools bpftool: Fix json dump crash on powerpc
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Michael Petlan <mpetlan@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>
References: <20190704085856.17502-1-jolsa@kernel.org>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 mQINBFnqRlsBEADfkCdH/bkkfjbglpUeGssNbYr/TD4aopXiDZ0dL2EwafFImsGOWmCIIva2
 MofTQHQ0tFbwY3Ir74exzU9X0aUqrtHirQHLkKeMwExgDxJYysYsZGfM5WfW7j8X4aVwYtfs
 AVRXxAOy6/bw1Mccq8ZMTYKhdCgS3BfC7qK+VYC4bhM2AOWxSQWlH5WKQaRbqGOVLyq8Jlxk
 2FGLThUsPRlXKz4nl+GabKCX6x3rioSuNoHoWdoPDKsRgYGbP9LKRRQy3ZeJha4x+apy8rAM
 jcGHppIrciyfH38+LdV1FVi6sCx8sRKX++ypQc3fa6O7d7mKLr6uy16xS9U7zauLu1FYLy2U
 N/F1c4F+bOlPMndxEzNc/XqMOM9JZu1XLluqbi2C6JWGy0IYfoyirddKpwzEtKIwiDBI08JJ
 Cv4jtTWKeX8pjTmstay0yWbe0sTINPh+iDw+ybMwgXhr4A/jZ1wcKmPCFOpb7U3JYC+ysD6m
 6+O/eOs21wVag/LnnMuOKHZa2oNsi6Zl0Cs6C7Vve87jtj+3xgeZ8NLvYyWrQhIHRu1tUeuf
 T8qdexDphTguMGJbA8iOrncHXjpxWhMWykIyN4TYrNwnyhqP9UgqRPLwJt5qB1FVfjfAlaPV
 sfsxuOEwvuIt19B/3pAP0nbevNymR3QpMPRl4m3zXCy+KPaSSQARAQABtC1RdWVudGluIE1v
 bm5ldCA8cXVlbnRpbi5tb25uZXRAbmV0cm9ub21lLmNvbT6JAj0EEwEIACcFAlnqRlsCGyMF
 CQlmAYAFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQNvcEyYwwfB7tChAAqFWG30+DG3Sx
 B7lfPaqs47oW98s5tTMprA+0QMqUX2lzHX7xWb5v8qCpuujdiII6RU0ZhwNKh/SMJ7rbYlxK
 qCOw54kMI+IU7UtWCej+Ps3LKyG54L5HkBpbdM8BLJJXZvnMqfNWx9tMISHkd/LwogvCMZrP
 TAFkPf286tZCIz0EtGY/v6YANpEXXrCzboWEiIccXRmbgBF4VK/frSveuS7OHKCu66VVbK7h
 kyTgBsbfyQi7R0Z6w6sgy+boe7E71DmCnBn57py5OocViHEXRgO/SR7uUK3lZZ5zy3+rWpX5
 nCCo0C1qZFxp65TWU6s8Xt0Jq+Fs7Kg/drI7b5/Z+TqJiZVrTfwTflqPRmiuJ8lPd+dvuflY
 JH0ftAWmN3sT7cTYH54+HBIo1vm5UDvKWatTNBmkwPh6d3cZGALZvwL6lo0KQHXZhCVdljdQ
 rwWdE25aCQkhKyaCFFuxr3moFR0KKLQxNykrVTJIRuBS8sCyxvWcZYB8tA5gQ/DqNKBdDrT8
 F9z2QvNE5LGhWDGddEU4nynm2bZXHYVs2uZfbdZpSY31cwVS/Arz13Dq+McMdeqC9J2wVcyL
 DJPLwAg18Dr5bwA8SXgILp0QcYWtdTVPl+0s82h+ckfYPOmkOLMgRmkbtqPhAD95vRD7wMnm
 ilTVmCi6+ND98YblbzL64YG5Ag0EWepGWwEQAM45/7CeXSDAnk5UMXPVqIxF8yCRzVe+UE0R
 QQsdNwBIVdpXvLxkVwmeu1I4aVvNt3Hp2eiZJjVndIzKtVEoyi5nMvgwMVs8ZKCgWuwYwBzU
 Vs9eKABnT0WilzH3gA5t9LuumekaZS7z8IfeBlZkGXEiaugnSAESkytBvHRRlQ8b1qnXha3g
 XtxyEqobKO2+dI0hq0CyUnGXT40Pe2woVPm50qD4HYZKzF5ltkl/PgRNHo4gfGq9D7dW2OlL
 5I9qp+zNYj1G1e/ytPWuFzYJVT30MvaKwaNdurBiLc9VlWXbp53R95elThbrhEfUqWbAZH7b
 ALWfAotD07AN1msGFCES7Zes2AfAHESI8UhVPfJcwLPlz/Rz7/K6zj5U6WvH6aj4OddQFvN/
 icvzlXna5HljDZ+kRkVtn+9zrTMEmgay8SDtWliyR8i7fvnHTLny5tRnE5lMNPRxO7wBwIWX
 TVCoBnnI62tnFdTDnZ6C3rOxVF6FxUJUAcn+cImb7Vs7M5uv8GufnXNUlsvsNS6kFTO8eOjh
 4fe5IYLzvX9uHeYkkjCNVeUH5NUsk4NGOhAeCS6gkLRA/3u507UqCPFvVXJYLSjifnr92irt
 0hXm89Ms5fyYeXppnO3l+UMKLkFUTu6T1BrDbZSiHXQoqrvU9b1mWF0CBM6aAYFGeDdIVe4x
 ABEBAAGJAiUEGAEIAA8FAlnqRlsCGwwFCQlmAYAACgkQNvcEyYwwfB4QwhAAqBTOgI9k8MoM
 gVA9SZj92vYet9gWOVa2Inj/HEjz37tztnywYVKRCRfCTG5VNRv1LOiCP1kIl/+crVHm8g78
 iYc5GgBKj9O9RvDm43NTDrH2uzz3n66SRJhXOHgcvaNE5ViOMABU+/pzlg34L/m4LA8SfwUG
 ducP39DPbF4J0OqpDmmAWNYyHh/aWf/hRBFkyM2VuizN9cOS641jrhTO/HlfTlYjIb4Ccu9Y
 S24xLj3kkhbFVnOUZh8celJ31T9GwCK69DXNwlDZdri4Bh0N8DtRfrhkHj9JRBAun5mdwF4m
 yLTMSs4Jwa7MaIwwb1h3d75Ws7oAmv7y0+RgZXbAk2XN32VM7emkKoPgOx6Q5o8giPRX8mpc
 PiYojrO4B4vaeKAmsmVer/Sb5y9EoD7+D7WygJu2bDrqOm7U7vOQybzZPBLqXYxl/F5vOobC
 5rQZgudR5bI8uQM0DpYb+Pwk3bMEUZQ4t497aq2vyMLRi483eqT0eG1QBE4O8dFNYdK5XUIz
 oHhplrRgXwPBSOkMMlLKu+FJsmYVFeLAJ81sfmFuTTliRb3Fl2Q27cEr7kNKlsz/t6vLSEN2
 j8x+tWD8x53SEOSn94g2AyJA9Txh2xBhWGuZ9CpBuXjtPrnRSd8xdrw36AL53goTt/NiLHUd
 RHhSHGnKaQ6MfrTge5Q0h5A=
Message-ID: <f287a4c6-f9f6-f001-edab-83a7d3a9074e@netronome.com>
Date:   Thu, 4 Jul 2019 18:37:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704085856.17502-1-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-07-04 10:58 UTC+0200 ~ Jiri Olsa <jolsa@kernel.org>
> Michael reported crash with by bpf program in json mode on powerpc:
> 
>   # bpftool prog -p dump jited id 14
>   [{
>         "name": "0xd00000000a9aa760",
>         "insns": [{
>                 "pc": "0x0",
>                 "operation": "nop",
>                 "operands": [null
>                 ]
>             },{
>                 "pc": "0x4",
>                 "operation": "nop",
>                 "operands": [null
>                 ]
>             },{
>                 "pc": "0x8",
>                 "operation": "mflr",
>   Segmentation fault (core dumped)
> 
> The code is assuming char pointers in format, which is not always
> true at least for powerpc. Fixing this by dumping the whole string
> into buffer based on its format.
> 
> Please note that libopcodes code does not check return values from
> fprintf callback, so there's no point to return error in case of
> allocation failure.
> 
> Reported-by: Michael Petlan <mpetlan@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Looks good to me, thank you for the fix!

Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
