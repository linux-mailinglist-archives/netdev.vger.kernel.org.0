Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F2F2110FF
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbgGAQrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732161AbgGAQrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:47:14 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A21EC08C5C1;
        Wed,  1 Jul 2020 09:47:14 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w73so9807989ila.11;
        Wed, 01 Jul 2020 09:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cgXOYeOBav3lpCc6RnkxnTtxmQ18prKpm12TGEbwf+o=;
        b=hzE0PsmcjXmfaB3rUYvH7zJ6hDATURfLwN+3G+b5VACszlph4RLjh3fdr9km+bIy6W
         T+P/x8649noHlVIIyegFH72mxYYGAc/IAOLGfeVlWSfwxwIUvIm3SMXyx6g4wOlzyIgU
         pWRGx7S+jTL1gHJNAW2zwQ55R00XUnHqt6dgO6YProoBoS6rgTuSo+uAVr3D3eG+3Doh
         FPA1QRbHBGvyYDiPWWWC1BC+Q748dlZzVN2foYrSFETFTOQzwJBe4Ut3Xt5PA/QnKJ2s
         bwG8TVjIdibU3DJTeFiegHt5nhrepQbNCuqcvaDQSj/bknwnyMtGOewtkwtrbX6/xSl1
         sKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cgXOYeOBav3lpCc6RnkxnTtxmQ18prKpm12TGEbwf+o=;
        b=iJrfcqcqIVcxNq70d3kl4hyttsZAbBeCuv/IS7ClH49S2JW4exMgQxTS3gVeuVY1Ao
         25mP3oYg3jXkIKa/W38/AttHfQDueSZRFmk96yTb9M21KRNUJr23CYY8NSYoShK2jZqY
         CREz12KgPhmONTDHRgHDlZsQgImkm7/FPj2mPhO4e6QvGahZ7XGKNNMdjIm/mPRpKM61
         VyyaI6rfyN61wxHapnlMe6tbo8N74kO4YEA6d+UJXKxex9GLtszUK9VCO2wyD3JG3UAK
         0NqE3hi23YczXdoneBCVBZAeVBHZdmE1/XD66eY49pGYjYoSJDDIc47PUU7nELZmJtLz
         TT9w==
X-Gm-Message-State: AOAM532XgYFGqkyc1L7EXV3DWteB5JhBmBHqUwUk0ea7estpsshGZgSv
        qbgMz7NTGAqB2ezwDCYYsvDusJSUkLI9PsedY8o=
X-Google-Smtp-Source: ABdhPJxQMuxh0yObmiT7znRD89rOc/Jnm1QPfqG6yx5gFLYz5iKQuXIQ8XqSVqRPYiFMJCAeJGIkuiVVAgkzhYE0vQ0=
X-Received: by 2002:a92:5ecf:: with SMTP id f76mr9021204ilg.6.1593622033598;
 Wed, 01 Jul 2020 09:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
 <20200701125938.639447-5-vaibhavgupta40@gmail.com> <20200701085805.4dac84fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200701085805.4dac84fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Wed, 1 Jul 2020 22:15:35 +0530
Message-ID: <CAPBsFfBb5Z6xVpo3A-0M0BDqgWqLFaQWcT0j7S+Q2wz375BZ4g@mail.gmail.com>
Subject: Re: [PATCH v1 04/11] ena_netdev: use generic power management
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 at 21:28, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  1 Jul 2020 18:29:31 +0530 Vaibhav Gupta wrote:
> > With legacy PM, drivers themselves were responsible for managing the
> > device's power states and takes care of register states.
> >
> > After upgrading to the generic structure, PCI core will take care of
> > required tasks and drivers should do only device-specific operations.
> >
> > Compile-tested only.
> >
> > Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
>
> This one produces a warning on a W=3D1 build:
>
> drivers/net/ethernet/amazon/ena/ena_netdev.c:4464:26: warning: =E2=80=98e=
na_pm_ops=E2=80=99 defined but not used [-Wunused-const-variable=3D]
>   4464 | static SIMPLE_DEV_PM_OPS(ena_pm_ops, ena_suspend, ena_resume);
I forgot to bind it inside "static struct pci_driver ena_pci_driver" :
      .driver.pm =3D &ena_pm_ops,

I am sending v2 of this particular patch.

--Vaibhav Gupta
