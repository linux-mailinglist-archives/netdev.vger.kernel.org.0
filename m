Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056D824C787
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 00:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgHTWDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 18:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgHTWDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 18:03:43 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F2DC061385;
        Thu, 20 Aug 2020 15:03:42 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id c15so1727435lfi.3;
        Thu, 20 Aug 2020 15:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HyfoJqdx4JRXJSnuQxhQSeHkU0B04tOxieZdt0XuPTs=;
        b=Wy5U8h1ktp/m4AWIM/OZJ+Mr211orAakiukyu6vXkSDlKocgxFhZIGya9ZhM0gqBBc
         eaLH71mdaAxXeKae7SlEn4tN0vY3x3KFa5U6aU4jnT5Su0LBiQY2/38XCVyeRV5fJlox
         wm40Apzn1iA8O2jhoKHzBpAgqp0Ub4XQWN0ao2qz/bJfrfVFM4Mr3MKU3vkZGeXzcZzw
         n/y7kFI/0xTtOuEmg1blvWQa4YbTmszISa++OUqdoZQJ9xQrVpi+72MVX9otlU8wzPRD
         Qbmijx++zmQJEu5a8S+QBpqCkqeDap7j4zNiuREzScajadLIBmSVRzhxUq/xDVAXNELy
         c2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HyfoJqdx4JRXJSnuQxhQSeHkU0B04tOxieZdt0XuPTs=;
        b=cRdRrmiI76qLimKkRm+lbtV5DTFL/gY6W+aaeZIZ2Xvmfxcd//lxR12XWpmDcNgvY1
         D4o9Hh9nOlXaMGdFXDMKKskzYj0HZq6IUGeI5dJY11GaP+K0foQj0278MG7jvdj5WY51
         7Yu1DX0qKf6sZ8zlRgCNiVmYrBsz/GCQ7kwG7Y1+Kjthj4mkpLhHL+l/+tSHbJT8N/ri
         zYNg+Rl1zBCMzGN8UnpCoW2uJA3BZD93iDziN6RDUIZPVrt+ZXdkpbYOwMRmLM33e5LO
         gRwgfzoO8xIIKbaw95f2sq1hexbHtsoubWaeLdjInI2+3hwHmcNQ8VYrVSdvWiBMy+ID
         KVBA==
X-Gm-Message-State: AOAM533sg8OTzXZpPY5S3ElH8riUSoOwf+DObmOFDFTaA2ERs1In1R2o
        xoRSNQhVK/wbSww+5J2Cj79gTpWN++fQvhW+huk=
X-Google-Smtp-Source: ABdhPJw5fleQISNrT8ABcXnZoOCRAGXHd6yt2I+b7JCtjXSq8CwPswgJEFTKxQoLhUFCrlpTAL0E6rA8LqIN5qk8G4E=
X-Received: by 2002:ac2:59c5:: with SMTP id x5mr222795lfn.174.1597961021154;
 Thu, 20 Aug 2020 15:03:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200820142644.51939-1-cneirabustos@gmail.com>
In-Reply-To: <20200820142644.51939-1-cneirabustos@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Aug 2020 15:03:29 -0700
Message-ID: <CAADnVQJpZc93YBoMgrUS=qAuD2Sa+=yEKzu7iM+=t5GFYBLSEA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next] bpf/selftests: fold test_current_pid_tgid_new_ns
 into test_progs.
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 7:27 AM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds both tests into test_progs.
>
> Changes from V5:
>  - Fold both tests into test_progs.
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

It doesn't apply. Pls rebase.
