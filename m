Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FABD20E7A
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfEPSOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:14:00 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35297 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfEPSOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 14:14:00 -0400
Received: by mail-lj1-f193.google.com with SMTP id h11so2612384ljb.2
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 11:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=juFIl3dAAfIfSLCGsoL237d5zxYs1McSYxIiP4S2Vgw=;
        b=ZKO/GcQajoRu2DsATbOVimO5GU+LDHe2Lwjo5BHoqti4J77cKT60/t2F2eqcY2Hnkf
         QpAnoY5oo7iFLchrnZNHpX6ishWkwvOqBhi5hb9O8XR3Fpo53DSL6xI5LrmrdIs8QwBs
         5lzx5x92c8mxnaSdu5Heyp6a6dqnSd/YTcdlR51vRbvffkzOfWu07POLVeNN9sJhaVav
         KlC7pdQa0zuPS24/VWNIPBNqh4/NkMLJ0siBc8VtfBt1viE+ObbepMUx7vuJ552RyZxR
         x263JdYhT03V5lE+r+rwjMs9tLAFay/btrOoCmJ52oTJ+KLNYpH3xE0P47mOJ847Vt0b
         IVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=juFIl3dAAfIfSLCGsoL237d5zxYs1McSYxIiP4S2Vgw=;
        b=SQhBIauYRsIr2Ohwgyx+QzgeInp5q8CROmMf5WcChyIjgUb9J8z9G0t0vYisEIvX8N
         R4X6wikq+ynnQefUmPHhSmqtfu/JxUeL7PxV3yv1lCjxSRfNSSmY0acBOxQm+l1H9BIb
         HrYT70cf5sNpt0kRpKWgqPgI37sahv736rwKikoFCQzh8FWET6yaAwsz9vah6tB1eYPz
         2ZK3ZXM90m108shJlo2FRRWhLsxiFePRVZ9tX4bYqW+dZRkMFuDYw8gRF+xDbbTvVLPz
         mKgec6NXcycNXdgw8ZiDStG24FSM1bVawOW0wAs+rQ6E8mwmvnvkIAJ3RINi+0Rw0cjN
         FMTg==
X-Gm-Message-State: APjAAAXJ7dFjmWAz8orZugcHv9iyTmwTK6wPUX0cZxTb+aCPD5pB/5dM
        VZo9fhnQVy2gj93dhIFh73lPlMkXjn7BzplWvyM=
X-Google-Smtp-Source: APXvYqyrcPWUQCVRQ0X64l4TS+Vz2WkXhSrmIbhHu9GRWaL/tmfZbOzoYzDFFFkjCq8UT2ys6DDmRv/aeJEuS9PC8e0=
X-Received: by 2002:a2e:96d9:: with SMTP id d25mr24001635ljj.78.1558030438264;
 Thu, 16 May 2019 11:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
 <20190515204123.5955-4-jakub.kicinski@netronome.com> <2ca1ad39-b2a1-7f40-4bf6-69a1c9f13cc0@mellanox.com>
 <20190516105652.36c81a1a@cakuba.netronome.com>
In-Reply-To: <20190516105652.36c81a1a@cakuba.netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 May 2019 11:13:47 -0700
Message-ID: <CAADnVQ+eFX8S2go=SeQ9kdP_3yGckHF-_Aevv7x+EbJQgsCgmw@mail.gmail.com>
Subject: Re: [PATCH net 3/3] Documentation: add TLS offload documentation
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "vakul.garg@nxp.com" <vakul.garg@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 10:57 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
>   The preferred method of reporting the Layer 4 (TCP) checksum offload
>   for packets decrypted by the device is to update the checksum field
>   to the correct value for clear text and report CHECKSUM_UNNECESSARY
>   or CHECKSUM_COMPLETE computed over clear text. However, the exact
>   semantics of RX checksum offload when NIC performs data modification
>   are not clear and subject to change.

when host is consuming the tcp stream I don't see the value of
tcp checksum on top tls.
In that sense CHECKSUM_UNNECESSARY is fine and no
need to update checksum field.
Even in case of sockmap and tcp stream redirect it is still fine.
Only the tcp payload being redirected to a different tcp socket
and the headers are gone.
So imo in all cases CHECKSUM_UNNECESSARY is fine
even without adjustment to checksum field.

Obviously the hw/firmware should have checked tcp csum before doing decrypt.
