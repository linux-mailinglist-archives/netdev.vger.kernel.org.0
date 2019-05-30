Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51182304A8
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE3WPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:15:06 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39480 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3WPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:15:05 -0400
Received: by mail-ot1-f68.google.com with SMTP id k24so2097914otn.6;
        Thu, 30 May 2019 15:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=esfrFMZGksDh8a9cO+oFEVkOyToxeVgjGVajp0t5uMA=;
        b=Y23YeQnfD1/sKRcMRK7dwclwxqaFymC4hspELPhsRKcDnjEBoo3VN2yKMrvMOKOX1k
         WaaQj6/lWw1aLzecTdVt2kNAGd2dIGkQwLA4E0jl7LSixaXpbhL2VEoES4L99QbiaE8P
         zKrVAuUc3rOQ2RJSRm40SKE8iSkqzHqdByAmROMzI+bmc7o3Xoc1E2Ltig6zUeFvpIfD
         I5oSMzn1A3xOp/qTPfYu6IhXVZaIQXaP7UYcJ3+5Viw/IEJF63lZudMzybSYNp5zmHM0
         7npv9vMs8q+gj6kL4yye7oHTKwTSgmGrkaStr7WL2cCB+aqc3JvlPAMZ41zQPnLsIJnQ
         IJsA==
X-Gm-Message-State: APjAAAXrG0WwjQEzqDCUN8nwnQNfvGc1ihwQ5LeFcSyNIyqC3ATj30Q+
        MwIvpJxBRrA6gAVUATTChDHUMXkOjmw=
X-Google-Smtp-Source: APXvYqxcssZ2P726W5gBRmhRvrYfu4C+5mgIylIxWUkzEgFEHV/bxNfuEDDuDgdEKlYEqEYy0qG5WQ==
X-Received: by 2002:a05:6830:1d5:: with SMTP id r21mr4580794ota.155.1559254504513;
        Thu, 30 May 2019 15:15:04 -0700 (PDT)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com. [209.85.167.171])
        by smtp.gmail.com with ESMTPSA id u70sm1414875oif.16.2019.05.30.15.15.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 15:15:03 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id v25so5656745oic.9;
        Thu, 30 May 2019 15:15:03 -0700 (PDT)
X-Received: by 2002:aca:ea05:: with SMTP id i5mr3971031oih.51.1559254503293;
 Thu, 30 May 2019 15:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com> <20190530.150844.1826796344374758568.davem@davemloft.net>
In-Reply-To: <20190530.150844.1826796344374758568.davem@davemloft.net>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Thu, 30 May 2019 17:14:51 -0500
X-Gmail-Original-Message-ID: <CADRPPNTn7onrpyicx_ytdaDG4q3v4t494zYetkHrT808RsOByA@mail.gmail.com>
Message-ID: <CADRPPNTn7onrpyicx_ytdaDG4q3v4t494zYetkHrT808RsOByA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
To:     David Miller <davem@davemloft.net>, arm@kernel.org
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Netdev <netdev@vger.kernel.org>, madalin.bucur@nxp.com,
        Roy Pledge <roy.pledge@nxp.com>, camelia.groza@nxp.com,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 5:09 PM David Miller <davem@davemloft.net> wrote:
>
> From: laurentiu.tudor@nxp.com
> Date: Thu, 30 May 2019 17:19:45 +0300
>
> > Depends on this pull request:
> >
> >  http://lists.infradead.org/pipermail/linux-arm-kernel/2019-May/653554.html
>
> I'm not sure how you want me to handle this.

One suggestion from the arm-soc maintainers is that after this pull
request is merged by arm-soc tree.  You can also merge this pull
request and then apply the patches.

Regards,
Leo
