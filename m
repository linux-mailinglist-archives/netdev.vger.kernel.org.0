Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C577A4915E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfFQUaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:30:15 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38601 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFQUaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:30:15 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so15841927edo.5;
        Mon, 17 Jun 2019 13:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/6miJAsvlKZ+NTF37mtgfecOjC+L4l+FZ/tO8y72hcY=;
        b=j+LfTk1cJSVWMXglHnydK2FvbU2cs3ZZ8ZDSuyEvKqfv3CBK3TyXIRfwe5Fykwtsd0
         1iNdJXf52TqlRtAgjvFI+LuNFTOzl4LT2O2iiBi43TMbJdZSDZtYzcUl6raTSPJeqHIK
         tA1aI9ApRivKBRg+oEwNAuAwRj3ndD45f1WYGRNOUvJslo6Soh6AwR0PZtLMBvuvT2F0
         mqmkjF/01cEshq+ANLhA2uR3pjGrXpHzKDrY6tORIN8C8NfN/2mtq1R6JMMmVCevKhlK
         bxvae19fagM9rFMRvnPaNuK3GCQT8j7rFeaaXrstfLiCsTt7Bs8wx24d7ygEBCSB9JtH
         8gFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/6miJAsvlKZ+NTF37mtgfecOjC+L4l+FZ/tO8y72hcY=;
        b=qll6wtRxCxEz8wkFaJXFv9Lpxx4v9lDAWl/lEHsifzHPgPOmTU/zt7095/bjMYLPVi
         /huPyZlpTtw9XdjcwKHHQ82sZ9LvZ41yhQPyfjrKpukco0KUGyGGzQNXZ+izkoEyKucZ
         gmPnoJTnvmAEBbtFNcpEfQkdwVFF8+X83MfYN3T3KAo/x32JUJUhhKJWQVDKAJqFVKH9
         AkzPWUf57TCc6dsTT5tpYakv34rOgx8lNqnBcy3fIN8CTj2yS9+W38/HT6wZbpDa73XD
         D/UR47xVYUsLgX+2WuPCdff8EEUZkuX+SH9XDgb8lYVgxY2QXklrjYmpDcD6zJKqNMs3
         JdEQ==
X-Gm-Message-State: APjAAAUO/pZ3M1bgGNk/VPlPstznxov4b3RaI+r9ucdWpKmF8kTkuKUS
        w2HiZOt9Fj/abbbwYZbyO2MIvzaaRKO516iOhgE=
X-Google-Smtp-Source: APXvYqww7nWizr0FGtjHx8XNgx3Yo2U7sZtEVkvbXpDZvrVllwR5sexNhXcxX8QvfYgLauxPY9yAkyRBDwpJMkOzvIk=
X-Received: by 2002:a50:b3fd:: with SMTP id t58mr68393204edd.31.1560803413120;
 Mon, 17 Jun 2019 13:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190617190837.13186-1-fklassen@appneta.com>
In-Reply-To: <20190617190837.13186-1-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 17 Jun 2019 16:29:37 -0400
Message-ID: <CAF=yD-KQ1dxmNbR8-xoiNTfwHXzO-wQRpz+0ZFN9o36+UE_e6A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/3] UDP GSO audit tests
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 3:09 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> Updates to UDP GSO selftests ot optionally stress test CMSG
> subsytem, and report the reliability and performance of both
> TX Timestamping and ZEROCOPY messages.
>
> Fred Klassen (3):
>   net/udpgso_bench_tx: options to exercise TX CMSG
>   net/udpgso_bench.sh add UDP GSO audit tests
>   net/udpgso_bench.sh test fails on error
>
>  tools/testing/selftests/net/udpgso_bench.sh   |  52 ++++-
>  tools/testing/selftests/net/udpgso_bench_tx.c | 291 ++++++++++++++++++++++++--
>  2 files changed, 327 insertions(+), 16 deletions(-)
>
> --

For the series:

Acked-by: Willem de Bruijn <willemb@google.com>
