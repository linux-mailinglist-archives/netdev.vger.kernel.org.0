Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4916374702
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbhEERhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237767AbhEERfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:35:04 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C41FC06129F;
        Wed,  5 May 2021 10:06:09 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 12so3542395lfq.13;
        Wed, 05 May 2021 10:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dl+yh9sNc333jWtGTEG9CP/9INzN45EOyF45W29H9hA=;
        b=nE1crn01I75fjDxQJVdLWrTj8uvI+4+oTsth9abLfIWitd0x7009n0JLYfl2p1gVof
         xzmfFsbLT3o7E4MPx05r7yyCkmPlzOuk0y5+5wQqHG1zfaVZ1T/c/SMfoPDqFxuBli/0
         1AHEraIB+tARHnLlLSVmaleZ7gNNA1KcMXyKn+scK73jfejdqOf50y4V2y4UWROovtVT
         mir01NOeg1UGhP/MZ0fIIWq5uKqclcKQGHm+Y9mApfRV5pDv8op4YZeT74fBmy9etjyg
         Zu0JnMeniam3V7wrc8qxZpbSuivk5KeBUDAvqEr9dCYGB8kr4PtnvxLRnYrwKEWOXvem
         lbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dl+yh9sNc333jWtGTEG9CP/9INzN45EOyF45W29H9hA=;
        b=ZaQ+uIDBKGx/KoGuyo3NF9Ki2vy0vDqhARHPsosyiCH4ieXqPHQ6ZcKLg49MRySgUC
         ONa4VjlhPQ79MSdPQrEvkF93g2EZhppiAukf/dDYcTSY/TV3bTij8RRuNC0zfDEnolsu
         NCS9YZ3RXYTOhL8u4bdA0umYOoIs35P9VEtGx85fLTnntiNhOS0lUb21vOv4evJf30op
         +tkfnOfIiOQy2vqoYveCO8gD6cl8kJbSASvJ2FYND5EqzOOyDBzsf5pJX1ivx7DDn5k+
         dmBj6a7Kky18TKSIRqIPKvzEllFVDb35ou5VD0ItLkFWvkvCgRthnQUzA6OAIo3qAvQ7
         4AYA==
X-Gm-Message-State: AOAM533w+i3upArMPMPL5qTX9dBiBSNm9oqwPtOHtveuewq8V8rUx7wc
        l/Z+Q4ei+lgYlRts7Fdqpyr/tkCdNXiqBDZbqxj2ehq9dj9Q4GDv
X-Google-Smtp-Source: ABdhPJwZSukiI/7ZoOQqRkcvIOsBPwqYwAGUbUqe/xdz3Kse7Rq5rp9Ys0gSEk7Xv5BXr5RhWcOgpiOsl4NsTYmNI4o=
X-Received: by 2002:a19:257:: with SMTP id 84mr20479166lfc.575.1620234367870;
 Wed, 05 May 2021 10:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <6a526dbf75f6445f3711df0a201a48f8ac3149cd.1620185393.git.sajgloumeau@gmail.com>
 <b636dedea2c2ed230bb3d53f45a523eb0f5dfbc0.1620233954.git.sajgloumeau@gmail.com>
In-Reply-To: <b636dedea2c2ed230bb3d53f45a523eb0f5dfbc0.1620233954.git.sajgloumeau@gmail.com>
From:   Sean Gloumeau <sajgloumeau@gmail.com>
Date:   Wed, 5 May 2021 13:05:56 -0400
Message-ID: <CAFU37zWkS5HjkOVZYOhJt84=4i2GhLrUUO7T2+zvyNmEngCstw@mail.gmail.com>
Subject: Re: [PATCH v2] Add entries for words with stem "eleminat"
To:     Jiri Kosina <trivial@kernel.org>
Cc:     kbingham@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whoops, please ignore the last email. It should have sent with a new subject.

On Wed, May 5, 2021 at 1:04 PM Sean Gloumeau <sajgloumeau@gmail.com> wrote:
>
> Entries are added to spelling.txt in order to prevent spelling mistakes
> involving words with stem "eliminat" from occurring again.
>
> Signed-off-by: Sean Gloumeau <sajgloumeau@gmail.com>
> ---
>  scripts/spelling.txt | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/scripts/spelling.txt b/scripts/spelling.txt
> index 7b6a01291598..4400f71a100c 100644
> --- a/scripts/spelling.txt
> +++ b/scripts/spelling.txt
> @@ -547,6 +547,9 @@ efficently||efficiently
>  ehther||ether
>  eigth||eight
>  elementry||elementary
> +eleminate||eliminate
> +eleminating||eliminating
> +elemination||elimination
>  eletronic||electronic
>  embeded||embedded
>  enabledi||enabled
> --
> 2.31.1
>
