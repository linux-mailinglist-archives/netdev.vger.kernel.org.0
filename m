Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7331E1F19
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406607AbfJWPVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:21:07 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:41338 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406602AbfJWPVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:21:07 -0400
Received: by mail-yb1-f193.google.com with SMTP id 206so6421227ybc.8
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uBvjav4t9wOPdPpT+FUqN1cy8vxf7nChSdpIFivRTPg=;
        b=us4+W7WEp372ScczNpimf4aCuykgXxMuS1Mj0+Jb623deFHUWujqK9W4rmHH/0KP+M
         XnlO25EWDnQSgVGMHX2GSmkSb6vozJ9ute+aIKTjZgceIFka3W6gRMwd6DGOJxziFtfs
         jc4FaGfd0BCuX5be9UVGhjAxqLC5YimmZ9r0tVcA6xsHEbHT0b10AInQhjWs8PcmKUnH
         x5gApnC/hnVUrua2aLwc9I+5AQTqBi5qmYIr8VUXeAFDxVWLOx0IXzapW1zmMFCzezhH
         7K1gP8zNpHeNn/wiYNQVDROM+2bW+NmaiJVFg+pgYALZ7fvbpZM5S3m+VeMdL8V7Hnnc
         9XQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uBvjav4t9wOPdPpT+FUqN1cy8vxf7nChSdpIFivRTPg=;
        b=Sgi+/mKCwAuYu/9wfgHXuJqSA9cjP7E65ePBbhanaJqmlXb+HdZsTnRTYyg7pUzH1r
         8L8HH1D/QNNrDiJFvqbMG2cuaK/vOE3qtuIWiRGmfhZUNzaJcs6biR3VLC01+cTti7Ub
         d5FcD69fkAunJj3tLvQRdFwgtJVgpjcYo7Iie1xSOJ/IKi1QH+bSATlyjQDYa7XrMV9F
         lIgcGW+Ayb8NJw9EzM9cXMC7IDki/n/GDyMshHeV3B1OQWQj0MvidvtboabRTLAtWMqy
         9Ey/HPvVPSbEW6UeTwnBQaM5MU3etZ0iVc4e6D3caXIq9c1YjEHQr53L/PrbhOx+w4vl
         I5Rw==
X-Gm-Message-State: APjAAAWIdM+BYHGfkSQwRVT7PU4OHyaGPBWwJAhb6jgkLgMfQcZ24CNq
        xhxmlugPXdgM/jB5Veso2saystHOvoXE8EHBw3w=
X-Google-Smtp-Source: APXvYqyUhcGGvabcyJBhCE3Kk6ChjzkF3sTFCjZt5T6S1/kVUyuAB9TxacoqnYOSROABLhDcSCsHZgqhYYeaHKURZlk=
X-Received: by 2002:a25:1044:: with SMTP id 65mr6827650ybq.129.1571844066666;
 Wed, 23 Oct 2019 08:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191022044343.6901-1-saeedm@mellanox.com>
In-Reply-To: <20191022044343.6901-1-saeedm@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 23 Oct 2019 18:20:55 +0300
Message-ID: <CAJ3xEMgXujHYyMrMdmDDEyWJ6SLw8uKrxHZw=aTRkn-RQUjfKw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] page_pool: API for numa node change handling
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 8:04 AM Saeed Mahameed <saeedm@mellanox.com> wrote:

> CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
> NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)
>
> XDP Drop/TX single core:
> NUMA  | XDP  | Before    | After
> ---------------------------------------
> Close | Drop | 11   Mpps | 10.9 Mpps
> Far   | Drop | 4.4  Mpps | 5.8  Mpps
>
> Close | TX   | 6.5 Mpps  | 6.5 Mpps
> Far   | TX   | 4   Mpps  | 3.5  Mpps
>
> Improvement is about 30% drop packet rate, 15% tx packet rate for numa far test.

some typo here, the TX far test results become worse, would be good to
clarify/fix the cover letter
