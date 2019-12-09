Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341AD1166FB
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 07:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfLIGgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 01:36:17 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42521 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfLIGgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 01:36:17 -0500
Received: by mail-lf1-f68.google.com with SMTP id y19so9709659lfl.9;
        Sun, 08 Dec 2019 22:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TZRtHTcfvXtQotqGqzJU20iEzWK2qj/gYB6W0njgUJQ=;
        b=uPtOY71VCNniq6MLIYJKVEP9rxMeQHgeUIVBj0nXv+PjCFhVfqebbFGvI44+/2rf1c
         YXoHbKu7p7UIcm212yLkQLXJiqN81PdlTTxfSk0yssZpoCxXE/my0v0SmZdx0CEz0eJc
         K/ozhxyvIHfv4rphvQ/ECaLWbnpMf1rShZlk4coE4eq0Yzjwblyibr8uiaX0BWxDs52e
         5ZfBbPokDWNoC8BaA51rqkjqBbP0lEG98M52Op/h0QCFedmXJmMamVsUF/Lsb4br6vV7
         3O9pT6S1JIiboItYawx5ywGb8ii2q3GHuuhGIrfnE4xJgaH238zU2SVDJETvfChmvlZe
         I46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZRtHTcfvXtQotqGqzJU20iEzWK2qj/gYB6W0njgUJQ=;
        b=J1mxy6bNSElZ8S47PcQFKNPYyQ7TXtj8x/M+euu6Hu47sLQGYWhWjiZpYQaXAKTTGG
         j14RM0mRxog4wucwCN4MXsu94F47rqg6hdl+qrH7+ZpBOJnNSAYrEC8ob9wCLRoeXRcJ
         s5qgnZPKTzgzZtXKQ7TtHbGp7lriwREoZM3JVZ/5yF8NV4Tsdj4SxMCiwu3hmqcA33ng
         c840gktct8AkF8OrINIuy/LJK7k63l77wh1Rr6DZbCXaTNepUM4FhEb1NOAlbdFXGj8O
         939kFREBYfvQZEPaZgH8ECgo1aCbZ0Op1kkl8Ak6r7Uy6x7unOJAh8b+5TolVnVYHPU/
         UpiQ==
X-Gm-Message-State: APjAAAUFdyiyq+05KDVqpnwJ1l7fsxAEc2vonKfq44HmIRK7Vn5jRPN1
        QKVB+shiPNwO7maOLUZtGsDr5f0rUzrwz2QgFj0NAQ==
X-Google-Smtp-Source: APXvYqz7upI7svuNrmizPPmClkYLooqcv0Zdhr+nM9hER9V9adllEGJM9nIQZad9wLy90NCMysFKDPzKXd1M+xmNTt4=
X-Received: by 2002:a19:be93:: with SMTP id o141mr10947350lff.181.1575873375292;
 Sun, 08 Dec 2019 22:36:15 -0800 (PST)
MIME-Version: 1.0
References: <20191208.151711.2227834913032509828.davem@davemloft.net>
In-Reply-To: <20191208.151711.2227834913032509828.davem@davemloft.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 8 Dec 2019 22:36:04 -0800
Message-ID: <CAADnVQKS1ide6NO+SBgzQ+83mpyTX4ph=P_dEWb=C7wabZKYYA@mail.gmail.com>
Subject: so is bpf-next... Re: net-next is OPEN...
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 8, 2019 at 3:17 PM David Miller <davem@davemloft.net> wrote:
>
>
> We're back online:
>
>         http://vger.kernel.org/~davem/net-next.html

bpf-next is open.
Maintainers are on standby to review and accept new features :)
