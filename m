Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75040482530
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 17:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhLaQfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 11:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhLaQfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 11:35:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4A6C061574;
        Fri, 31 Dec 2021 08:35:03 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so25628468pjf.3;
        Fri, 31 Dec 2021 08:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5m1mhKGTXBkMGqIwtX2b4pc6VtPiz9J7zq0Uls21qcE=;
        b=pNOuv0DdX0N68zVB6S1zSUzw/L/KO3y/e6Uzas+1wgvXJUlDWsLbHF2yfZ12B74c8E
         63m0XQ2ArB8b9A5HnXRxuVCSbw+Ukp/hxj2e1CnrlA+Wm2qyWNC6PraIYERcbrmb6wV8
         ZagkSZtdVzdlI1NnTP0ceuiP6uFCoe+kD84ulXd2vGl7tCINC+M+V7H4wLhElATQtVhH
         k/TkS2fpSjaIjxuauxBk8Jh+tlsDKK02rUtNaV4z8eOCkByFzBn7v4FtDTnRv8VNXaoM
         SH9Fkau9p8ovbddkO6OucBCbyW1YPYsjB1U/GvWWdniU8UAzNca5ymr2suAruUNjmzgF
         +BgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5m1mhKGTXBkMGqIwtX2b4pc6VtPiz9J7zq0Uls21qcE=;
        b=41qLa8Fp0lSGy13DpFcsMYPc2k1Lq41JnhRIhkNvuP9ghY3dYFQ/m6wsroHvYhvg9i
         FVSI2Cq8zIcJ4V/DYiWKM7TitAtG64SJ9ofQG57tCXk7fiF1Q2ufeXsI4PBuvuhWRl9F
         GTg6rdFfyemQ0kruLyj3Haw+caWeQ04zXhKXPj2HUZydCbbw0LHTV7iq4BgffMUvCIjj
         IV3jOjwmXRf+nfdLAX5++LHrR9ZQUPrEzcR9yEsB4jakWqR25z2QBUV58/QtxZbUox2y
         1/0xmsdMnZfGGtkMAosIei2DWjPXc4IUHX++pStz4aNGnI2XTysdC/lnATVSv1Kmrrhe
         0JuQ==
X-Gm-Message-State: AOAM530mVutnBMAol6eXO9pyRZwBe7+z0nsiB1iJJrUPbxpGj4ii6Tyo
        4mGGPQ+cwId4pSesFPMSK5xNqfZTvZ2TFrO0+gY=
X-Google-Smtp-Source: ABdhPJzOpNjb4xeTy/C0iyH/zW9F9ChMlHNy3SXmZE87WejPmpyXVftwLEZNbSBST3u+d7UEhpdE5LhkQFL4RIQuFkE=
X-Received: by 2002:a17:90a:1f45:: with SMTP id y5mr43945630pjy.138.1640968502621;
 Fri, 31 Dec 2021 08:35:02 -0800 (PST)
MIME-Version: 1.0
References: <a12e914c-4be1-85d9-5242-34855f9eeac@diagnostix.dwd.de>
In-Reply-To: <a12e914c-4be1-85d9-5242-34855f9eeac@diagnostix.dwd.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 Dec 2021 08:34:51 -0800
Message-ID: <CAADnVQJ5MxGkq=ng214aYoH-NmZ1gjoS=ZTY1eU-Fag4RwZjdg@mail.gmail.com>
Subject: Re: bpfilter: write fail messages with 5.15.x and centos 7.9.2009 (fwd)
To:     Holger Kiehl <Holger.Kiehl@dwd.de>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 1:23 AM Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>
> Hello,
>
> hope I am now sending it to the correct list.
>
> Please, what else can I do to solve this?

Turn that kconfig off. It shouldn't be used in production kernels.
