Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD61E437A6C
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhJVP5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbhJVP5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 11:57:09 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F52C061766;
        Fri, 22 Oct 2021 08:54:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id ec8so3447449edb.6;
        Fri, 22 Oct 2021 08:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDQvFzNmfDK3jhO+7jpcrhMCqkQL2cVQ1kfnY5TX604=;
        b=qpM61jR7LD0bA8EQfDwaSY5OtUgumwtFBfGUsCzN7q0LQZGJ/POfQhRCc8JuOUD6Z7
         sDSL876CMem9SRlsM+VcUMRGUW9ruM+a8adBHCpVnuh4E6cxeWBDhzecQfy7p7mFVgsV
         UgJOFrCrPHjZIYd3nsDgmhDUFybJ0A0B9WyRnYOurgVrzPzOrSiVG8sbeWMbzcra36oN
         D4L0nW/tt30fsZjFKcY7PiJUHK6F0K+d2k8Pnz5OkWUbDP3ujMOvZfOzLxur5p8baUS7
         yhL54zlZ0yZT9Vw5eIVIqMuoshTVmPdlJ87V/h7Xv/rXqU109u++8Jug/mdhCEX4kBGO
         vNHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDQvFzNmfDK3jhO+7jpcrhMCqkQL2cVQ1kfnY5TX604=;
        b=dNVEdca/AzpdiivNVSkSaDBjC9TqXFRKdL+FYdPNnv6ZMGyjHeVFqV9K6y8go44CIc
         yIqJ+/yFrKR3xwHuDy6qFgyCr336WDFKWbRAb0jlj6OrF0sx+p9spjqjwTtZmQvD+Hic
         zVdo2LvTDPVsfYp/+HEGc1hQ5d4u0qOD7svf/gSaCtpTuNaXGDWJSFnwCKqppCPpeIbv
         ECfvClSJl+myIvzGnCmTLAnFF24YWwjUtFyqXI2ZwY44vJjOQobevdkUgPqW8vEcA5Ay
         92NGhB7rCr0+tPMEw/nDHEZQC6kDzMh6ZgFi9c1K6oi3QU+E37eW9juGZGaGBzIj7kKr
         2ogA==
X-Gm-Message-State: AOAM533oK/bZe1M9A3xVxpqqmwKCNyW4Zji982mx/WVyKB/NdRgNIjcT
        qgPMtcjf+F6NJvTQN4vM03ylQvk+v7lJr9sOOvX+HP5z
X-Google-Smtp-Source: ABdhPJx7Qh2wotC8d3QFr/ramxsDE1vs7RPk9exrSbJ8swO5Xt6tf36SeltWuB7PkW4LF5/kmuRqYDUHR5FXPggdjwc=
X-Received: by 2002:a17:906:f0ca:: with SMTP id dk10mr513886ejb.94.1634918089833;
 Fri, 22 Oct 2021 08:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
In-Reply-To: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 22 Oct 2021 18:54:38 +0300
Message-ID: <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
Subject: Re: Unsubscription Incident
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Oct 2021 at 18:53, Lijun Pan <lijunp213@gmail.com> wrote:
>
> Hi,
>
> From Oct 11, I did not receive any emails from both linux-kernel and
> netdev mailing list. Did anyone encounter the same issue? I subscribed
> again and I can receive incoming emails now. However, I figured out
> that anyone can unsubscribe your email without authentication. Maybe
> it is just a one-time issue that someone accidentally unsubscribed my
> email. But I would recommend that our admin can add one more
> authentication step before unsubscription to make the process more
> secure.
>
> Thanks,
> Lijun

Yes, the exact same thing happened to me. I got unsubscribed from all
vger mailing lists.
