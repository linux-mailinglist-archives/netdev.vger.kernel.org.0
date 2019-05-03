Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B846133A7
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 20:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfECShx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 14:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfECShx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 14:37:53 -0400
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47CC6216FD;
        Fri,  3 May 2019 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556908672;
        bh=UBxcZxzFld3G2g7m8BqdNbaEx6zt7+38GcnBJB/cjpQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hM0cpJzrKnoUOQGImhGa6M0L6Ce0BnUA80fCJnWzjEEdR1fPBR0q0On2aHq1U+n/A
         YbLxKAH0Cl2A3fZ6TixNkY8uwzs+BYGaueQH9W9MYf+qfcuQGv4M+/ilMPdswg0oCW
         YZl5PfkuurrwZE5DAHQWsem5aJjT9s1M+Mrj7pko=
Received: by mail-lj1-f170.google.com with SMTP id c6so628593lji.11;
        Fri, 03 May 2019 11:37:52 -0700 (PDT)
X-Gm-Message-State: APjAAAUnTITf5Vc2TeGQbVqad2l7IEA2msspg4ubrgTycutvCy4emaDo
        PwQmxo+FZBYlDJiUZA78JJQ6GU4a4NV9B6ODy5g=
X-Google-Smtp-Source: APXvYqyYTVh7YDpZFN7xj6hghkJrSFAfXvx2/BjGs2iZoFl5sr2936maY0RBxyzw5eSgEy/Y6NBJ04y+Pvqp+k5GrJ8=
X-Received: by 2002:a2e:4a09:: with SMTP id x9mr5160180lja.19.1556908670459;
 Fri, 03 May 2019 11:37:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190430092832.7376-1-geert+renesas@glider.be>
In-Reply-To: <20190430092832.7376-1-geert+renesas@glider.be>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 3 May 2019 20:37:39 +0200
X-Gmail-Original-Message-ID: <CAJKOXPd5EK2L89roSOMRoH6qtXSjHebnYTAu3KYwsP4dSLO3hA@mail.gmail.com>
Message-ID: <CAJKOXPd5EK2L89roSOMRoH6qtXSjHebnYTAu3KYwsP4dSLO3hA@mail.gmail.com>
Subject: Re: [PATCH -next] mlxsw: Remove obsolete dependency on THERMAL=m
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Apr 2019 at 11:29, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> The THERMAL configuration option was changed from tristate to bool, but
> a dependency on THERMAL=m was forgotten, leading to a warning when
> running "make savedefconfig":
>
>     boolean symbol THERMAL tested for 'm'? test forced to 'n'
>
> Fixes: be33e4fbbea581ea ("thermal/drivers/core: Remove the module Kconfig's option")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

This also fixes olddefconfig, image_name and other targets:
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
