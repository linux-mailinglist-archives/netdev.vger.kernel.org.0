Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2FA16AA8A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgBXPz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:55:57 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36616 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBXPz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:55:57 -0500
Received: by mail-yb1-f195.google.com with SMTP id u26so4845439ybd.3
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 07:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6vmZOW17TKww8E6P65jjDzaaV0K6x6f5otSPwAxh3jU=;
        b=B91xCYuQuDcJQ3wq/v214S79eHxJYZa3rQrEtapWrsoVGXz/M/UUIVT4bBTqlil367
         gJuaf0/IFZpTOCqpEY/yFi1gcSxUZQF2yq/n4UAY4jJ4hUEqtjbmdGuxqfZlYM754O52
         PgiZ+v53jfe88EOHmh6e0K115uaJb+QBG/DX99R1qfHGl02IRlodP57o0Jv1TVtrnmFX
         Z1W1AhwdtKAz9bKl/rTfJrFO561muV1n/IQhE5V5F8yW/n+Tj+oqsYTcAva0VQ4UMEbk
         rLL4Fxsa39BUOU7hIw6biyRcVWv1bFaVA2PbtLflLoyjqYY+PPi3/jTrS7ba7npDjYbM
         z+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6vmZOW17TKww8E6P65jjDzaaV0K6x6f5otSPwAxh3jU=;
        b=kKjcT6BJrFRDXUrBlM61WrBP01QDaMj+nUflVjPQgRquhOrK98kfQJnHbA0YLDy6AC
         DWnQo/fvLXqvCeSTpkVCjcCLw5i9yJ7M+FFqgsc/iomgwRk7FY+DC6KayfUyP38IXamL
         i+bxF2X2N2RKFu/hlAgTpmu+MOUXNKD1Lcm+0/pNIlOSCWM0mSy+knmudvY9DA3KJI+r
         r+oS/O88rLReQonUXqVfJioGxldBxCn5celISvVYrazUV3At2C0x49sg6agE6NUxg9Dv
         gLUt+q5VpZn3CQliXV56ZXXhdA1jCDNUo5b8TxD/GWPcuV035Jeh0W8jCYlSg6QLNRol
         jKKA==
X-Gm-Message-State: APjAAAWzNSccaa/eUBrE3ik0OuTUywlbP8RCWu/y0onj+kM3fM6JHMao
        9YuxU3/Cp0k1rRyqEj84HGWQnYo0
X-Google-Smtp-Source: APXvYqyjP2M23BWT/zclAUp0+KJtmBIaYrmR5sxJpZPbHazhBRICc0tT615WpIfhfidOLm290t7C+Q==
X-Received: by 2002:a25:8205:: with SMTP id q5mr46053019ybk.73.1582559755770;
        Mon, 24 Feb 2020 07:55:55 -0800 (PST)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id a202sm5053090ywe.8.2020.02.24.07.55.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:55:54 -0800 (PST)
Received: by mail-yw1-f52.google.com with SMTP id h126so5396901ywc.6
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 07:55:54 -0800 (PST)
X-Received: by 2002:a0d:ca8f:: with SMTP id m137mr38071841ywd.354.1582559754074;
 Mon, 24 Feb 2020 07:55:54 -0800 (PST)
MIME-Version: 1.0
References: <cover.1582518033.git.martin.varghese@nokia.com> <80f53936b703211830f7965f69268faa939bfcdd.1582518033.git.martin.varghese@nokia.com>
In-Reply-To: <80f53936b703211830f7965f69268faa939bfcdd.1582518033.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Feb 2020 10:55:17 -0500
X-Gmail-Original-Message-ID: <CA+FuTScHDXw4te_5-svJNOBfQ2FJyHBnpXyi05uhtnGHi2X+nA@mail.gmail.com>
Message-ID: <CA+FuTScHDXw4te_5-svJNOBfQ2FJyHBnpXyi05uhtnGHi2X+nA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com, eli@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 12:28 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The Bareudp tunnel module provides a generic L3 encapsulation
> tunnelling module for tunnelling different protocols like MPLS,
> IP,NSH etc inside a UDP tunnel.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Acked-by: Willem de Bruijn <willemb@google.com>
