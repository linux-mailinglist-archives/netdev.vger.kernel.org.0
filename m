Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BA019E9E
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfEJN6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 09:58:54 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37274 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbfEJN6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 09:58:54 -0400
Received: by mail-io1-f66.google.com with SMTP id u2so3446783ioc.4
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 06:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=tARtAJ75r+C1SflLPDFn0S6TToZW7I3sK8MmsA4NLs0=;
        b=H023J6b9z4r+K5E8Pl8UsS8bWaNGih2NRh7mK5sb75hTL49dJyYM99OqD9I4Bbvoak
         dReKUpunxU4qLAX69jTveyfy4lI2jjHRJj5pKHFV0w57KNA2lRR5jnqL3bowvYZI9S5r
         Lt+fRbtXhSoWuIcodTozURPa94xdLT2WboFcUKW2sFYpUYasN1Qke4iZvJwYtqnESfuS
         G32sGHLPFCSt19zLrLKqBBMIVH+878on+LxBZgxu5GCNFUvbm3wnLMC/CEDdcOgCtMz6
         phKF6Edcn2tQFgLm8L4KtKpjnIBO5E4d29DtxTJLovKSD179OIeuJCzPQ9ofZPLSdkJ6
         DrMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=tARtAJ75r+C1SflLPDFn0S6TToZW7I3sK8MmsA4NLs0=;
        b=RaYlfienpLgpOJ13zl8/nMODy8bnQJ7EpC3lfKJ30PeiRYsRxtQslYPOihWG5eMZ5L
         cCWdg2QLspuaCFxpq8FhXZhbeyiN0HUvrqbY2XnylrodBrTpJCGZUpVIoW6KGsgIXOBR
         HvBzCc5YYFkKue3EVFY5YqjtsKgdP9jPt4ngsh/jgAkuIQFhhSlXXFkkHKgpj8RUJVrD
         qYLMs+9Kznt0OWLSlJ3WuVp9wQZ/1wnlMAi2PegXu5Vc4shGsYDqpGZZxTZuzPh3bN9C
         0JedfjL7iX+jIfOWOzyD5hPbSZ2l2zJYWQr/uWsmgfFbV6JlNtAZ96+rlZq1um387ymF
         tcwg==
X-Gm-Message-State: APjAAAXRz8p5SaYizpAlGpsY4SOQlRKXxZ+hyS0mzo0J8mKParepxXs3
        IkWGrbgnQWy2Qg3D+d03e+g=
X-Google-Smtp-Source: APXvYqyCOg7HcHl5X7OllKvsE1BYEsUAH5JFcmyYo/1gKMFiUU2uuxXXkCGu+eRWO+mbXVSRjGWoEw==
X-Received: by 2002:a5d:9e09:: with SMTP id h9mr7169992ioh.250.1557496733820;
        Fri, 10 May 2019 06:58:53 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c126sm2504837itc.3.2019.05.10.06.58.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 06:58:53 -0700 (PDT)
Date:   Fri, 10 May 2019 06:58:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Message-ID: <5cd58396644c1_61292af501ab05c450@john-XPS-13-9360.notmuch>
In-Reply-To: <20190509231407.25685-2-jakub.kicinski@netronome.com>
References: <20190509231407.25685-1-jakub.kicinski@netronome.com>
 <20190509231407.25685-2-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net 1/2] net/tls: remove set but not used variables
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> Commit 4504ab0e6eb8 ("net/tls: Inform user space about send buffer avai=
lability")
> made us report write_space regardless whether partial record
> push was successful or not.  Remove the now unused return value
> to clean up the following W=3D1 warning:
> =

> net/tls/tls_device.c: In function =E2=80=98tls_device_write_space=E2=80=
=99:
> net/tls/tls_device.c:546:6: warning: variable =E2=80=98rc=E2=80=99 set =
but not used [-Wunused-but-set-variable]
>   int rc =3D 0;
>       ^~
> =

> CC: Vakul Garg <vakul.garg@nxp.com>
> CC: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> ---
>  net/tls/tls_device.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> =


Acked-by: John Fastabend <john.fastabend@gmail.com>=
