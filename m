Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AB43D265B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhGVOV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232517AbhGVOVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 10:21:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C87926135A
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626966148;
        bh=9nLVB+c3neINhbsnZQONtsVA5xdOJV/aTggKYTV1lhI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Gh8DmuBdBcZIuTjNjc81ZSTtU9m0X2vm0KY1AupIgI8vNCWBoM4CWSL9lXd25voQh
         QxuRHIRZlmlWagQIBUnQUkANOaKQqvErtoD931Xhx1PT/ctkKK7cMz+CJfX8ppVuOr
         7Kd2tFNdwN3egrFiciFhWfX2ka4SUno2DDUqPHC91UNla8CDFTKvpO1t/zTVXiOcBc
         eJo3c+UadWOXBE/VEPSgPKIy/2rLnPY9SLT6sSZvKJly13itmmC8EtAmFdjlrygulg
         oFuiJ3emtg1qR/ujbfbHWRUzZFceoNrEyEXGdwVpQGnEzpaNrxq3+zFf/CY2IT+JVL
         r5HGeX0l0xRjw==
Received: by mail-wm1-f46.google.com with SMTP id o30-20020a05600c511eb029022e0571d1a0so3143366wms.5
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 08:02:28 -0700 (PDT)
X-Gm-Message-State: AOAM530ywY01R60vbG7GSxNJhhH47m9k1qcz92aZhA4P6AIK0Fv1bM/k
        ELlN04Z0b1iSmhZr09fTkUr1NMJ3CfA7X/zE+VY=
X-Google-Smtp-Source: ABdhPJyV2E7Xaw88/AQXLfI1hr5ose6bZZ+1AZd+9GtcHnUkLX2j6yTM0fbfz0D/NIz2H+4ebXPYCf/mHkwZXCLDMfc=
X-Received: by 2002:a7b:c385:: with SMTP id s5mr18522wmj.43.1626966147421;
 Thu, 22 Jul 2021 08:02:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210720144638.2859828-1-arnd@kernel.org> <20210720.120857.447378612092310208.davem@davemloft.net>
In-Reply-To: <20210720.120857.447378612092310208.davem@davemloft.net>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 22 Jul 2021 17:02:11 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1r0TuH8h2X3fZfMOmBycRoha3v4WcGEyQU3ExS4tyy-A@mail.gmail.com>
Message-ID: <CAK8P3a1r0TuH8h2X3fZfMOmBycRoha3v4WcGEyQU3ExS4tyy-A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 00/31] ndo_ioctl rework
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 9:08 PM David Miller <davem@davemloft.net> wrote:
>
> This gets several rejects against bet-next, please respin.

I've rebased both series now, and have done a little more build testing,
which resulted in a couple of unrelated patches you have already seen.

Since this series is based on the other one ("remove compat_alloc_user_space()")
I'll hold off on resending for the moment, until that is merged,
hopefully there are
no further obstacles in there.

       Arnd
