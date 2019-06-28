Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F3E5A2BE
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfF1Run (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:50:43 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46469 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF1Run (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:50:43 -0400
Received: by mail-lj1-f196.google.com with SMTP id v24so6794495ljg.13;
        Fri, 28 Jun 2019 10:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jI8gwBEu6dDG7Kr6XIrekH/tMjZltib+4iVniKLZRUI=;
        b=J2PHdGTIyFxxfRx2UTWBPh97xzQVNbXYKy7oLSL2KGIRYKjFIUX7kv3i5n5wo8KXCk
         TIFwkcZUdVsU+RnnksEdYpdc35zzyJJJZfjILAbEqb+tK3SuY8mW9X2MbQ1SVKsrv1Bi
         tDiRlT8r7iHip02eRxas0p5L4SIVpCdNBYd7lqdgcSss7Atl9KAgptxrd4BNXIbQoco4
         hVI6PD/lC/LJMXvgAWpv4V8HltYLfD3TuRtHQ89Y4/xnOmlZlJEtjg8JasV/+G9JLR2/
         7A2E4bO62kzqXqAi7P9GghFzS5QDD9bY/P8twhXT9Jj+Mj9C0MdIRF5EoEDJD4TPNbna
         ZYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jI8gwBEu6dDG7Kr6XIrekH/tMjZltib+4iVniKLZRUI=;
        b=FGpbAOXNnsko+8UUTg8jM2sKQV6pyUUjGdJusC9AnOhEDxcT7k/n164LnBTfQIigRT
         hgsaCsmH5AL9bxdKBmRKwZP60h385A3+dye3Uqii3aIOrg/V61+tGG4zD7B4IEcGcjCU
         id6Iuzd55YbwzlOYmvICa93r/lPVdpzmcdaJiJVLPJBnifYRqa6qwOxOcQq3xQz6ODRd
         mQyJ73pnF7XwTkWnjkZthmJdgYog/PO/nElfZUERJ3xxUSeU2ZhQEpGLru+tx/NCP3Ag
         5KQpLhjgY6gXMoLPY/F+qx3SQURf4Inr617Bt5HHbfOQaLW/IfQHB2o0Da/iJ8jT2csz
         ne0A==
X-Gm-Message-State: APjAAAXl3Uf8QFqXlzgtHbpBGATZ0JYW9lPEf86Ca+T2rdHmQnGHUWX7
        GdwiVanXVlwkaqgNszQZEZqmw+Crn/7oOsBeZqEQPw==
X-Google-Smtp-Source: APXvYqzd0aPE3yJu70GTxGM1a6KqWx9XbmEILScqFxQH+bS3SBsE+gIp3LzTCV/msKDf1LxluCckoyw+v4vm2kmCKR0=
X-Received: by 2002:a2e:9a82:: with SMTP id p2mr7065714lji.64.1561744240622;
 Fri, 28 Jun 2019 10:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190627202417.33370-1-brianvv@google.com> <20190627221434.tz2fscw2cjvrqiop@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190627221434.tz2fscw2cjvrqiop@ast-mbp.dhcp.thefacebook.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 10:50:29 -0700
Message-ID: <CABCgpaU3jtge4JJG=k0XqLXcPzjMUHaQ7eMAwm6svaLnO+n+yg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v2 0/6] bpf: add BPF_MAP_DUMP command to
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> was it with kpti and retpoline mitigations?

No, it wasn't. Will get back with new numbers.
