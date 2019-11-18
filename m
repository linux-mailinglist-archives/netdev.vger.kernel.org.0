Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B0100612
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 14:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKRNDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 08:03:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32790 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbfKRNDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 08:03:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574082196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/QRLHU74v2oa2JWIWl0HhvTQ4gOOEbuByxl6xxO27+Q=;
        b=Xl7To/nh2PsUlWyOCt4VAHM9d+4qg1d5QO0dsM/O4oVI9CThRqbjXnYs+JqyyumxRsGmq3
        hNUHO+tg5l5O0pGbN4aNLv2ThYhLFDrNavhW1oIKn79or5RQaCox8dN/BdOSadqSPC4CaO
        S7m0kOVypMQKEbL7DQRdX8+Ag7ElqAA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-7fvf5KS0PY2zCnMoYagAJg-1; Mon, 18 Nov 2019 08:03:15 -0500
Received: by mail-lj1-f198.google.com with SMTP id u6so3258421ljg.8
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 05:03:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iZ+zQEixGxKYqEe3LvF9b/lANTSE9z1m4u41Jw+cA1g=;
        b=QcrBnBdE2zXMrBW+EsN/076hpZbSO5HGFeQVAZGrHolHi9w+yjfhqYxviMK6c/r6gx
         NZi0IREwyIVZmfE6Kbk+DiVSIDlVSYFStQ/QD34NrMR1hgOFpmvusGeyeHEfZnRqrIrb
         f2SiUYk4yKO4zwCc1af22jQtmcR9o7yXnW+Y+dMGs36ElxFv0DDZ7LJR/VXKivMO2Syf
         uE8is0dShi04QSwryZPTU2FaiPZnI2f2YEqofEhTd3xavloV5UTAjokfP9CG/svf+cp+
         ta+dcBpbyp8rKQ6v7Hkducy5+aMhOwYJYDNwfS9RqfQHgsEh+C7dij2311P+Pfb5QK8p
         9xfw==
X-Gm-Message-State: APjAAAWl8VkiOBjRldX1BeDzUcJu6mQWoCklzBUU2eeLrAdysRhawcmo
        y1N1VXObB5KZE3tw+fojlnt2YEJyMGJpgIanltE6W4WoROU8lIiOjFm4WJ9knIMrhPyd0viE5/q
        lnXPcIzKoxGqsZ4fUXddzpg4bLH8SCyTq
X-Received: by 2002:ac2:4d17:: with SMTP id r23mr21304612lfi.56.1574082192839;
        Mon, 18 Nov 2019 05:03:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPW9BKT9zPAmX+PDWEyi+oZVlbQwpuiVcIRdI/4gdD4oQ1n3zpvDXa5LUcwgOz5UbAHEJbFEThSQaP57zJrCM=
X-Received: by 2002:ac2:4d17:: with SMTP id r23mr21304598lfi.56.1574082192643;
 Mon, 18 Nov 2019 05:03:12 -0800 (PST)
MIME-Version: 1.0
References: <9b97a07518c119e531de8ab012d95a8f3feea038.1574080178.git.marcelo.leitner@gmail.com>
In-Reply-To: <9b97a07518c119e531de8ab012d95a8f3feea038.1574080178.git.marcelo.leitner@gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 18 Nov 2019 14:02:36 +0100
Message-ID: <CAGnkfhwziVRE_LdXWm6UAFhva4jZTpioFUYdms1pfBm9rYZeKg@mail.gmail.com>
Subject: Re: [PATCH net] net/ipv4: fix sysctl max for fib_multipath_hash_policy
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
X-MC-Unique: 7fvf5KS0PY2zCnMoYagAJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 1:46 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Commit eec4844fae7c ("proc/sysctl: add shared variables for range
> check") did:
> -               .extra2         =3D &two,
> +               .extra2         =3D SYSCTL_ONE,
> here, which doesn't seem to be intentional, given the changelog.
> This patch restores it to the previous, as the value of 2 still makes
> sense (used in fib_multipath_hash()).
>

Nice catch.
Somehow a chunk in 363887a2cdfeb was partially reverted.

Acked-by: Matteo Croce <mcroce@redhat.com>

--=20
Matteo Croce
per aspera ad upstream

