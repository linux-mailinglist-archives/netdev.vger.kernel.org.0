Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41492C1842
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgKWWNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbgKWWNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:13:24 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF1DC0613CF;
        Mon, 23 Nov 2020 14:13:24 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id z5so5461339ejp.4;
        Mon, 23 Nov 2020 14:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aedbDIe0kppDqmpQwJUwG3Q1C8jUFeud8NZUBAa8548=;
        b=Uz4lpSpKnskHiXRtTu7qNQ9uA1Gl4wJ5kPr5PLlxDJWqzxD9qf8KL/Rq1DD8l0A8qo
         8hYDKVSrGQJCM2WwhHHMD1NYd4GtO+NKyk3lWUU6QY9/hdvJtSifr+odSyODjvDaa+oh
         iZEXv6aeEeDhGeD9dG3KCu6X+DJd5wpXB6H6hH31I+twnDPidkf0dkHXEgbwmT0Aut4p
         zaQn08pz9M5cdBKK9Xj6+AdQa8zBkdj4nfsTi+3dB0s10fCU4cH5xtlpyevEb0AUkH7R
         5jPU/5pX7T29yTptylZOba00FKOe//sEyZIu8CQc7cKA8N0Hb3ywGu/VbgirbGtnpV9V
         A0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aedbDIe0kppDqmpQwJUwG3Q1C8jUFeud8NZUBAa8548=;
        b=fdtjSJAFj7EbRKtM0Qy1lxYYgu/7TJWCcxROsXVhhBCFqfhJ4+UCC/72jdJI5GSHWP
         dVH2k85WaOsjzpG5gwj0DDAe8nLb6OMFg6bbyEN3WtZvyjuwuYG3td+QaBvfJ0/Tfasr
         ndJNZdq5Zc7jQG2QC6kJwcXhNPSpx34q3+XspE8VdU1KN7KHcnXHROqbhOjbM3kd5F9V
         tD7KEw+OoK/aMBWicQ23KFoI+pcoIbJRJdIFRByKNhF3vYv+3rLImmCyCzfhkJfOVDBx
         gFnEelemtGznx8ITyD1Y40YZhRb1FagKzbEj6WD2JoBh883mOn9ypsnOY2pAp2Jk/Bzw
         /RVQ==
X-Gm-Message-State: AOAM530l+9yxyOa7UCQJnH/uKApKK+mcXZfaj3nELUT8o9BhN8xLn1k9
        nMlfTUH7mSJiGXGoFdYAe8QdRhfqf7Q5Vob756zNqJeG
X-Google-Smtp-Source: ABdhPJz7V34lDsd/RDVixOE5qqAwGLH8CPXpTForzS8a+k1NYY4CNM2oS1AExuK/BnRPQoOFL9b0ctTdid4fhG99t2o=
X-Received: by 2002:a17:906:bce6:: with SMTP id op6mr1599498ejb.2.1606169602846;
 Mon, 23 Nov 2020 14:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 23 Nov 2020 23:13:11 +0100
Message-ID: <CAFBinCBhWKzQFwERW9cy7T4JdOdFwNOqn2qPqFpqdjbat=-DwA@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15] net: phy: add support for shared
 interrupts (part 3)
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ioana,

On Mon, Nov 23, 2020 at 4:38 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
[...]
> Ioana Ciornei (15):
>   net: phy: intel-xway: implement generic .handle_interrupt() callback
>   net: phy: intel-xway: remove the use of .ack_interrupt()
>   net: phy: icplus: implement generic .handle_interrupt() callback
>   net: phy: icplus: remove the use .ack_interrupt()
>   net: phy: meson-gxl: implement generic .handle_interrupt() callback
>   net: phy: meson-gxl: remove the use of .ack_callback()
I will check the six patches above on Saturday (due to me being very
busy with my daytime job)
if that's too late for the netdev maintainers then I'm not worried
about it. at first glance this looks fine to me. and we can always fix
things afterwards (but still before -rc1).


Best regards,
Martin
