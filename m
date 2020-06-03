Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637211ED5A7
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgFCSA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgFCSAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 14:00:55 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADDFC08C5C0;
        Wed,  3 Jun 2020 11:00:54 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id n24so3871428lji.10;
        Wed, 03 Jun 2020 11:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XwCOTSQnqJFvWW5OIlRcFc+fj7i+u2CyJfkwdIecB3E=;
        b=cOQTTAsLMSnk2EkrvuF2U5V0RD7FQtcrVbPyKKXR8B+vF5nFOr5teLQ3Znk6NQhnHW
         okSxcfYdYKQr7HVMbe0Ac+T69qXZTwRwHy+Ny15lmxWZH4TbE0kpY5WFW7iA5vlRRvpG
         4ltEk7gHx7qkqM9LDb+ybh/QI6Znr+10EiAGx8pNYOU0LnxrnQYiyTI/bmsUm2px2jfQ
         PnbQizwXZn77Aq3ODbNwGj7HxGQYHB/RWUfwz9w1w2dZrNwza2GiZ2VRaVX2fsQn6r+o
         sxKQ/RnvD/rrL9DljQlPTLBr27srl/lYTtpoP9g8w6jwcz/h4XvM4G/ztk9U6ZCWsBYt
         9FCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XwCOTSQnqJFvWW5OIlRcFc+fj7i+u2CyJfkwdIecB3E=;
        b=RKGq94vWyj8GFHsJOIgHWFz1u4JA1JBYshgthv3nrfdX77iOWmsntkH9X13kPNEKM0
         soYk6COA7D6KuyFnKyoTRiFZeLmL94dCFHqglR2Bf41y6h40EXxkoWxdiBmV2glyPs8g
         lbCNXrWhj+2h6xwQdsG2SJ7DNBrP94FUkFz1DrQ6nAzRIQFIAeMOtU8nXX7ZFqO0PQHx
         fZ1cPJLLye0CqKwJuE09bV+P1LANQ2CPx5P+8sC4RZbtdo8u7qI5syWPSqtIx9Z8zm2N
         npfwaoiY8oalNfq7Kr2peV05cGvthDzS1XJzD6YV1lXoCF16fJYPB2A2Gazr4Pj/XPnd
         jqoQ==
X-Gm-Message-State: AOAM533o+SCvaMNNEQ+8lVn7Kut1MgO3Dv2HiiJ1S/smOaWncB7yXKpY
        NfZK+4fuLnJfCuO28RCtw/ategMa+Oqvrn9iXCs=
X-Google-Smtp-Source: ABdhPJxVre4Kn2+dRKYfaVaFcQvl43RbjEHeesXLR9BNoymL7PAqlcTTKv+HsgsBJU21c3THY9j6xTroEuhy8tqKpX4=
X-Received: by 2002:a2e:9b89:: with SMTP id z9mr191392lji.51.1591207253256;
 Wed, 03 Jun 2020 11:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200603153446.8092-1-cneirabustos@gmail.com>
In-Reply-To: <20200603153446.8092-1-cneirabustos@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 3 Jun 2020 11:00:41 -0700
Message-ID: <CAADnVQ+neNvnLt2gp9WbDjhq7RzR4AG3p3jK-jVdMGCAA5kNvA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] fold test_current_pid_tgid_new_ns into into test_progs
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

On Wed, Jun 3, 2020 at 8:35 AM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> folds tests from test_current_pid_tgid_new_ns into test_progs.
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

Please resubmit when bpf-next reopens. Thanks
