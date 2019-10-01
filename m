Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F61C3244
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfJALVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:21:38 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35083 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJALVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:21:38 -0400
Received: by mail-qk1-f195.google.com with SMTP id w2so10801748qkf.2;
        Tue, 01 Oct 2019 04:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T/9aZl1U9GrlNoj5M1zx7ZaXKGBZu2N7Er57Y3lw2mA=;
        b=d6h4dqflK6dJrS3DyVHleQcC9Pg9WDR7VFgEP34yZDHFCiqOD5kl2X1P8zXfTpNPyh
         Bzus2FED9RuFvA7ona/fcHkmbgK7VQfZwXRTQf181PrIkRU/SnVGN3FxTPKh9ApCYmyn
         rfQhblHLMHp980TkwN6gV3EuybMNuh+ZNtZOmyri/ZEq8nXj7HzWRwYbDi3xaA0MHccg
         3se3uEv6CQa38cioAfsForcsnDKsvQgFqGmBQW2McZHT0AfuwydSBx3oozx8be83tnbH
         SqAsoJOUljSjHxW1JqrmfQ+KUEoFVlCVfnxdbH02hfw0EoViaxq82j7set6VWYBACkKb
         c8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T/9aZl1U9GrlNoj5M1zx7ZaXKGBZu2N7Er57Y3lw2mA=;
        b=Z7g8uMTEl+J8PywF+KbEPNWsDbeEhZBhZHg2pp0vWpv1DdVI+s8HcwEYFGZnetT5Bv
         +WmG0VChAm7+L2pHX8DlHxKSjM9ZHWQHN+Dtdz1RwKGiZdayRPzbaaPtvPXX5554bLJ3
         rs7xffLnJAv0Q6TdreYHNol7aZx31+ZA0Ev17G0of3WGSaXXzw7s6SvNZ/2hzQjyzLHA
         Emt+AT9xMcne3h0yx9NWBpTBqgi11O49OVmp03fptKfceJMickCqMmedLysMVqwWf/EV
         cHOkvB46jbM4UE6ZUyBUGd8P6kSwGrlX0QNKvtVAJjMixoy7YzO83Hyu5K8tt221c3Pe
         5bSA==
X-Gm-Message-State: APjAAAUaJvKjpQldVx4p2Pxl4aXTfOoiuB3dPSyrVsmnxQgkY63awnHD
        +HFFjLIcUTicDXvelsZ28noxOB2Ymt0A5P+mS9o=
X-Google-Smtp-Source: APXvYqyl9bVaXSVKnL22wKbGEcI8r30XZN9ZmuFl1zpfV4lXfZCyrG9S9ePOWNXJDXBNtEiWOudM/5L8lfXgPG0eab4=
X-Received: by 2002:a37:a946:: with SMTP id s67mr5524550qke.470.1569928897381;
 Tue, 01 Oct 2019 04:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190917065044.GA173797@LGEARND20B15> <20191001092020.B3C7B60AD9@smtp.codeaurora.org>
In-Reply-To: <20191001092020.B3C7B60AD9@smtp.codeaurora.org>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Tue, 1 Oct 2019 20:21:26 +0900
Message-ID: <CADLLry48nTtopZ9qzSxd7NBOGFV2V8nf7tNDA-8-BeTpDVf9wQ@mail.gmail.com>
Subject: Re: [PATCH] rtlwifi: rtl8723ae: Remove unused 'rtstatus' variable
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     pkshih@realtek.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019=EB=85=84 10=EC=9B=94 1=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 6:20, K=
alle Valo <kvalo@codeaurora.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Austin Kim <austindh.kim@gmail.com> wrote:
>
> > 'rtstatus' local variable is not used,
> > so remove it for clean-up.
> >
> > Signed-off-by: Austin Kim <austindh.kim@gmail.com>
>
> Patch applied to wireless-drivers-next.git, thanks.

Thanks for information.
