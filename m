Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EE9264BF4
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgIJRzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgIJRyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:54:39 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7764CC061573;
        Thu, 10 Sep 2020 10:54:36 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u21so9337831ljl.6;
        Thu, 10 Sep 2020 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gqF3JhrN6mkG5GJQl4SSfW7ZOq5CVu9Tyiyt1djrPOI=;
        b=FF0HjUMTb4vljjTpUHoOXaFUNcWxhyq2McdoZ8I0iHYOCy1vqW4a05Hbs9qIIjJp7d
         FsttDJaKdH4pvXY9H5ugSBQrwdBTi+CZUbSCyXYAp/BIWBOSclfGvRWElPcxs+6w9Otc
         +DQeFk9duVGfZ+ombx5u7BMB+xsGDuv4FzQT3W2McTtU+uL+q3tiMOWASW5phNAdxf91
         AFtlOV7DZsGP+sJg2lWBtiG4qvMKkn9GE+KzKjblUOOdb0dIUEkFyIHaO1/pSw27Fh7L
         kQ49ZV71d7BF6Sca+03NCVHbLNHwYQC+ihpJVfQipul5c3fKIRYy4M6fvGTR9YFrOoC0
         rk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gqF3JhrN6mkG5GJQl4SSfW7ZOq5CVu9Tyiyt1djrPOI=;
        b=FBIwO7BfsTI3WyakWTWyfQJ+JN8tO64kLmAiEqP00spUN27bhW9AwOuwMRnfEj8pwU
         QdVOgrnq2vvdiFW0acZlXUChya9PnSIHYCNYDBPwcHDtho1QRUvKZeipLqhlDrMNRKQu
         Fb2vIGtD+RFkYOVAzqoLoGC7Qg0eIy+rnpU4u1jQPvNBMPoUfwTOH1aBqsFAA89tNHJG
         ljyAvWatQXlCRTUDdRYImUgqmFOB2GfPt8a+6HqrEDj/nkwPjPH3bptjV8T6JCJnSlBX
         1WyC62pZ/astc+UkylpOejCTaQbKGD06eWsI2qaAVCpRWdHkl1AcRjJke+M+n56OMegA
         S8gw==
X-Gm-Message-State: AOAM532jeS9m277D6xPPIpAOY84aMUkDovVpG7PQQhsJwNssrnVOZvfV
        oN5mXmPQOeEf/DZnkfmcw5vwUUjJAjQ1B/ay/zk=
X-Google-Smtp-Source: ABdhPJw1ivHY+xUiwDvcHNKQDjtBRr9oD7QWBo9HvoSP6fsZBOZJ46jUFOo25YweDrDyNK5MD3Qu27OuNiTrbsiNL2Y=
X-Received: by 2002:a2e:4554:: with SMTP id s81mr5276372lja.121.1599760469972;
 Thu, 10 Sep 2020 10:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200908132201.184005-1-chenzhou10@huawei.com> <CAEf4BzanC5xCLjq8tOyZKQ=ojhcyDYBhJkGVTcqCB-=uLctUvw@mail.gmail.com>
In-Reply-To: <CAEf4BzanC5xCLjq8tOyZKQ=ojhcyDYBhJkGVTcqCB-=uLctUvw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 10:54:18 -0700
Message-ID: <CAADnVQ+pFhuJ+KPPB6y9uDLsM7toMWSCFP5=m2rz7M1i7Ov0yw@mail.gmail.com>
Subject: Re: [PATCH -next] bpf: Remove duplicate headers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Chen Zhou <chenzhou10@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 4:05 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Sep 8, 2020 at 1:07 PM Chen Zhou <chenzhou10@huawei.com> wrote:
> >
> > Remove duplicate headers which are included twice.
> >
> > Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> > ---
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
