Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3C040D2BB
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 07:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhIPFCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 01:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhIPFCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 01:02:47 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBCFC061764
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 22:01:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j1so3690624pjv.3
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 22:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MTko6+hR5hHl8nMrMUmqN57Vz3neo6Xcub26rTJpWK4=;
        b=m+e7ZRNbAo9otvDsXlY7Gp7If0ssbdQrVZ2DVgYfPpDn1CNdQs6CAk+YxLK1pE70xk
         ym2UfG9KIDHoDFqwMPmxhtWPJN2JMgM5uprz/f69yJMvy92I/xAlxSUn/IzvQe/EPDQ6
         f0Fmqdtw7DMznUzUw1BtmjVLcODDaqOjQ2qhBSMMpKZoDdHXAQwUHqc0DWfYqq3NYPxz
         8+2kT9Y1p7tlmpFPpknhPaxfE0BGZ1SXhrPufME9aPzVvDVKYqQKywGeFRJvqXeTto5G
         3IlESGHpFKxf50z16I4KojAAIgO9hEvl5yK5MNr+K6LjddaZ1azgCzJAE1uhXhARCA55
         TQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MTko6+hR5hHl8nMrMUmqN57Vz3neo6Xcub26rTJpWK4=;
        b=53uwO2BxNNoIVxaJH5aT5XahLjDUF92XU3M+cWDZiqp6SV8FNvu5YfhCElsYAhxszM
         6eSpipQme69g0HBbcJtnI4DKL3i0W/ACS4o659RDyoh6EjISjCo2XuMkRBeyqiHCD2Le
         IHQhIuR5TkQDyx7C63x5ZTo97U6QAD1lnRbqv1eb4f1pdNYaAkSHDMWuTJc/6RvJQwX7
         Y1wBItIF11mX7KB7tSrxxZQdKCseou3tmLdb2iC+nPRhGL6wubz0YPiH2kvpYTBB2LWP
         cf88ELGQ3+43WYbFQkspdkncXrJQzZaRu2Z6OSFaH6ZLMhJGSvipYpdZ2d79TuwCceF1
         Z6Rw==
X-Gm-Message-State: AOAM533hrZKPt0y5H7X4eg8pC18LMKOVhZ1ph8SXz/02xQafUT4dwb/S
        DOc7ag5iPYs1hLZq5D6cAg4XzA==
X-Google-Smtp-Source: ABdhPJwonUznINb9jx3XlRd3H/dYiMOAUcgKuA74sol0t58TtUpa6gyreKcKCu5dsqpiME//R37yGw==
X-Received: by 2002:a17:902:c40e:b0:138:a4d4:cf46 with SMTP id k14-20020a170902c40e00b00138a4d4cf46mr3144720plk.48.1631768486482;
        Wed, 15 Sep 2021 22:01:26 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 13sm1447107pfw.73.2021.09.15.22.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 22:01:26 -0700 (PDT)
Date:   Wed, 15 Sep 2021 22:01:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Document BPF licensing.
Message-ID: <20210915220123.1dff1d98@hermes.local>
In-Reply-To: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
References: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Sep 2021 20:21:04 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> From: Alexei Starovoitov <ast@kernel.org>
>=20
> Document and clarify BPF licensing.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Joe Stringer <joe@cilium.io>
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Dave Thaler <dthaler@microsoft.com>

Looks good, this helps other projects.

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
