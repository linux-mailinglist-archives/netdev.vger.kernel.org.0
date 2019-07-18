Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3816D263
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbfGRQwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:52:37 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38047 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRQwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:52:37 -0400
Received: by mail-lf1-f68.google.com with SMTP id h28so19697282lfj.5;
        Thu, 18 Jul 2019 09:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=msbWUMjaCYaeI+P4QPRR4G+PLwfYrUtOEdjRRhRs8og=;
        b=W9OTgOWhyZ7CZ+ZkvnsG1LJ0eXh+ID7kS7urAeOAzeQWiyE6XD8i38jHVyeNT0q2Z2
         nOclhxk4LztvqoroRO0hn+sd0fYbhYbMhoedaaX9YZx2MAYKb3Y7flfXimD8UdPSuV9g
         KeGjuGLYLHhFiNv1lsbPXzxwh+3TZWLJbgtlLUyaBpH90s085clpNJrI4Od+dqTwDKxc
         /TNx6CwOUV0R2yh8AHYQTaE4K916DLo29Rs+whWjMfug6WyNJ9bdtGxifl8H05DLQAhv
         Y5fCWODDxQa4a/F/PcokY/O5i4zx5F6WdzJKGcq0QoLTHYuM1IkehuHTyVnEHC7ymwUV
         rfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=msbWUMjaCYaeI+P4QPRR4G+PLwfYrUtOEdjRRhRs8og=;
        b=F9lV7OVcjDGIgxnpoAtgb2qeVUh9vKvV5xN40iluDzcNRHJxwStMKa5BbsBjQgvOUh
         8LF+Y7pghk5pSivgNqPDec3k75zvxYSY6WlCvbLdmmd02+8XNgQPy/1vL0DfH/NnmOQc
         jKIbW9nG9/nOwviRgli624t1+bsrxjhs1cH2HJfCjNmae1KOrJP9BhrkVXReIBVIKz1C
         CUVTDhkUGMOOqHPe8kOKVjmOExI5NCKwEjleXygEDU/dzRw9zAQnVsd/EQsFCywNgL/K
         yB2XTj+gFZ+UteAw0hBOhnATbEu1rBiGEUseepq+zrDQdbNWwqQ/tsW1i4q126ehLnAq
         bxEw==
X-Gm-Message-State: APjAAAW0hZfba1SuE/hibUctqAHGUdu7OdVjWmzjAXhHRiXrfknKYs0Z
        /lWBMx7OHNj0u7CMGToVc0tcLaj4IFmByhwbAjs=
X-Google-Smtp-Source: APXvYqykUCdgoXyNEBAmDUL8YztRIX9tovJrHvYZtEhZmx25YAGdLqPvUOFBKjN4aW4qJn8POWC1aDXCVzUONyoVht0=
X-Received: by 2002:a19:cbd3:: with SMTP id b202mr21894063lfg.185.1563468755252;
 Thu, 18 Jul 2019 09:52:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190718143428.2392-1-TheSven73@gmail.com> <1563468471.2676.36.camel@pengutronix.de>
In-Reply-To: <1563468471.2676.36.camel@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 18 Jul 2019 13:52:23 -0300
Message-ID: <CAOMZO5A_BuWMr1n_fFv4veyaXdcfjxO+9nFAgGfCrmAhNmzV5g@mail.gmail.com>
Subject: Re: [PATCH] net: fec: generate warning when using deprecated phy reset
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 1:49 PM Lucas Stach <l.stach@pengutronix.de> wrote:
>
> Am Donnerstag, den 18.07.2019, 10:34 -0400 schrieb Sven Van Asbroeck:
> > Allowing the fec to reset its PHY via the phy-reset-gpios
> > devicetree property is deprecated. To improve developer
> > awareness, generate a warning whenever the deprecated
> > property is used.
>
> Not really a fan of this. This will cause existing DTs, which are
> provided by the firmware in an ideal world and may not change at the
> same rate as the kernel, to generate a warning with new kernels. Not
> really helpful from the user experience point of view.

I agree. I don't think this warning is useful.
