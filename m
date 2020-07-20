Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4C022607D
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGTNLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTNLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 09:11:45 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF485C061794;
        Mon, 20 Jul 2020 06:11:44 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g13so12841676qtv.8;
        Mon, 20 Jul 2020 06:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3cui7NTSv7/kxnwczpZltAgKV4Z+Rc/nVHOHoo00mt0=;
        b=uNRe80qDgULTIFXx4OHuYhkc0Mpj53lEAjIFOUYGUnu52k6u5XpbNzpADcrAj0TwhH
         PtwJgfCjC7RnjsHiFKPUsKfB3wrHmwAYnYsXriN6INNNR8F2yLyKUqJVV0lGR87bQaC5
         tiRlIvqeO2GfTOc7ZyeEQ3vrX7jI36egwEP8OeWMJuOdLHzYINcGTKvNPXRAoTM7KA03
         gXwNxtBed+6vnedhvVlPZyWoEKvvCLjJfryO7BO7nSSYOHdsjLWfQOEKc0UMahq3mofn
         HVRztVJmh+fxfT3g4X3EpUEoiPltJZJOCc2XXsGznYjzE0Fl6IdUwNKc50Hrpsz8HVPe
         uUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3cui7NTSv7/kxnwczpZltAgKV4Z+Rc/nVHOHoo00mt0=;
        b=e2J6IMy+Pl1y7tZFkHpFvHtQ9MffJmi3sD12OAIOI6npMEOCCnB274f8D5M2UCULEH
         qon6d0/4q7RDJgpylSdBdWN1KievkwXe9hj/36zbhWzddWO0GF6/8BaPf6vwiWwpCsJI
         y3M/KpQUTOqYJVEuUvhpGWZtsO81I5+pR8/WFJ1krAgampu1H60mXSPux3jIvJWEVxje
         1L+6XJPkn/utsg3aqgabWnyRVC565uqPJ9oPa2X3OhWJwR+kiyjQa6hXmoVBliib2vs4
         iNqIJFGeJjf0BT50NvShCY3/qeCPwLRX5v7LGNznW7lKYSHf+dQyaPtMg4/bYglKQwTm
         MT/Q==
X-Gm-Message-State: AOAM530iwx4GuVX5EevIYPOySdgH8WiFtkkCTf5HkLA4Jlc4mYZ6XmV5
        3iCzi04vDw5eXq3kDuhGiDFkwLkt6ms=
X-Google-Smtp-Source: ABdhPJzkTvyvK2oiUrfiK08SdQcxW/halGCzgjN0K8Lo2vmt1zrrynU7udSjN8SZNGSXjGsqZBRI2w==
X-Received: by 2002:ac8:5411:: with SMTP id b17mr23502044qtq.238.1595250704133;
        Mon, 20 Jul 2020 06:11:44 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:97d4:431e:ed87:df3d:c941])
        by smtp.gmail.com with ESMTPSA id h18sm9409224qkh.61.2020.07.20.06.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:11:42 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5B162C50C5; Mon, 20 Jul 2020 10:11:40 -0300 (-03)
Date:   Mon, 20 Jul 2020 10:11:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for v5.9] sctp: Replace HTTP links with HTTPS ones
Message-ID: <20200720131140.GC2491@localhost.localdomain>
References: <20200719202644.61663-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200719202644.61663-1-grandmaster@al2klimov.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 10:26:44PM +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  Continuing my work started at 93431e0607e5.
>  See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>  (Actually letting a shell for loop submit all this stuff for me.)
> 
>  If there are any URLs to be removed completely
>  or at least not (just) HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also: https://lkml.org/lkml/2020/6/27/64
> 
>  If there are any valid, but yet not changed URLs:
>  See: https://lkml.org/lkml/2020/6/26/837
> 
>  If you apply the patch, please let me know.
> 
>  Sorry again to all maintainers who complained about subject lines.
>  Now I realized that you want an actually perfect prefixes,
>  not just subsystem ones.
>  I tried my best...
>  And yes, *I could* (at least half-)automate it.
>  Impossible is nothing! :)

The subject prefix is right for sctp, but the patch tag should have
been "PATCH net-next" instead. :-)

Thankfully, they can fix it for us.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
