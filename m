Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115D7302D98
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 22:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbhAYV0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732704AbhAYVYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:24:23 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B94C0613D6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:23:42 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id v24so19924679lfr.7
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=klsHHsLzR3zv12oKdf5J16F5H29ZpvzNwvHad26s23k=;
        b=W6cQJJqI2HAP9GsYwmYZg5RfvgrixzOJUAoDCRsL8jnDURKlp242UGX19PzahHtgaz
         6ueZDwH+d5WOHgCRi81YVeD7Ttlpo30kGZtq/VQ7L5yc5rcdKs+UO9uAZYVbgiNo1/mw
         97eDfi/uogCnAKKrJP87sJkXQRl8HwVO8b0KU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=klsHHsLzR3zv12oKdf5J16F5H29ZpvzNwvHad26s23k=;
        b=Q7sqtpybZUgUA0AszxCa0JCHjlg7PW1+oFMSE8NLccZHNuMAfcV2e0Lo+Xy1XS3ROf
         M/MYI418h5LsclOTL7fNXkd9qLgKC1EcM9l87VfpdemNUbHjtcdxrKmxmmMetEpT43uv
         IeUCMM/OKD0u93Wva77iB2uPK0dmJ4Up1b7PeVPcAq3DTvgcxwo5LxmtF5BRdqB1qv4D
         ob5RX6tEbSD4O1qgiIuOUpc0IF2KAPP6mn0wOtNIvGPsI9bCEP6Glo0dWWIsW4g+H7Ko
         7V2wDxsm/bROG/8Hk7heyLesKTgTy2CV5reYuk0IhrHh+jK+W2WJQH8+TLOh5smH5NyB
         eHaw==
X-Gm-Message-State: AOAM530o/9TigVvac2slW7AHE08xREKiG8V4nY8aau7fedT0AChbebna
        Dpol0QUf822H32DVF0WK7pzwVRVadRk4YsRQxrDjtQ==
X-Google-Smtp-Source: ABdhPJzuqymtNcUpIlkly7qLhDRFSUKtaInHj7gjQ0G9LKfVVcsVuj+qJ+N1NgJ2GEnfj/zNeyPSfvkFiCrLID5PyIA=
X-Received: by 2002:a19:e34a:: with SMTP id c10mr1122552lfk.336.1611609820775;
 Mon, 25 Jan 2021 13:23:40 -0800 (PST)
MIME-Version: 1.0
References: <20210122193658.282884-1-saeed@kernel.org> <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
 <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKOOJTw_RfYfFunhHKTD6k73FvFObVb5Xx7hK8uPUUGJpuTzuw@mail.gmail.com>
 <CAKOOJTx7ogAvUkT5y8vKYp=KB+VSbe0MgXg5PuvjEiU_dO_5YA@mail.gmail.com>
 <20210125195905.GA4147@nvidia.com> <CAKOOJTx_0CxQ27PmB6MfcagGYdeAqEDy4CCr0wNATZOeCBBkTg@mail.gmail.com>
 <20210125204143.GB4147@nvidia.com>
In-Reply-To: <20210125204143.GB4147@nvidia.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Mon, 25 Jan 2021 13:23:04 -0800
Message-ID: <CAKOOJTwWUCe+6qkderKY7ojfHWDxkMQyQTR6uYRFNiZJ8zzYbw@mail.gmail.com>
Subject: Re: [pull request][net-next V10 00/14] Add mlx5 subfunction support
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Kiran Patil <kiran.patil@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e781ac05b9c0265e"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e781ac05b9c0265e
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 25, 2021 at 12:41 PM Jason Gunthorpe <jgg@nvidia.com> wrote:

> > That's an implementation decision. Nothing mandates that the state has
> > to physically exist in the same structure, only that reads and writes
> > are appropriately responded to.
>
> Yes, PCI does mandate this, you can't store the data on the other side
> of the PCI link, and if you can't cross the PCI link that only leaves
> on die/package memory resources.

Going off device was not what I was suggesting at all. I meant the
data doesn't necessarily need to be stored in the same physical
layout.

Take the config space for example. Many fields are read-only,
constant, always zero (for non-legacy) or reserved. These could be
generated by firmware in response to requests without ever being
backed by physical memory. Similarly, writes that imply a state change
can simply make that state change in whatever internal representation
is convenient for the device. One need only make sure the read back of
that state is appropriately reverse translated from your internal
representation. Similarly, if you're not exposing a bunch of optional
capabilities (the SFs don't), then you don't need the full config
space either, simply render the zeroes in response to the reads where
you have nothing to say.

That's not to say all implementations would be capable of this, only
that it is an implementation choice.

> > Right, but presumably it still needs to be at least a page. And,
> > nothing says your device's VF BAR protocol can't be equally simple.
>
> Having VFs that are not self-contained would require significant
> changing of current infrastructure, if we are going to change things
> then let's fix everything instead of some half measure.

I don't understand what you mean by self-contained. If your device
only needs a doorbell write to trigger a DMA, no reason your VF BAR
needs to expose more. In practice, there will be some kind of
configuration channel too, but this doesn't necessarily need a lot of
room either (you don't have to represent configuration as a bulky
register file exposing every conceivable option, it could be a mailbox
with a command protocol).

> The actual complexity inside the kernel is small and the user
> experience to manage them through devlink is dramatically better than
> SRIOV. I think it is a win even if there isn't any HW savings.

I'm not sure I agree with respect to user experience. Users are
familiar with SR-IOV. Now you impose a complementary model for
accomplishing the same goal (without solving all the problems, as per
the previous discussion, so we'll need to reinvent it again later).
Adds to confusion.

It's not easier for vendors either. Now we need to get users onto new
drivers to exploit it, with all the distribution lags that entails
(where existing drivers would work for SR-IOV). Some vendors will
support it, some won't, further adding to user confusion.

Regards,
Edwin Peer

--000000000000e781ac05b9c0265e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
mbo++PCnVfHaIk6rK1M0CPodEV0uUttmi6Mp/Ha7XmNgWQeQE3qkFIwAlb/kPNmJAMECAwEAAaOC
Ac4wggHKMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUHMAKGQWh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNoYTJnM29j
c3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25h
bHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1UdHwQ9MDsw
OaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hhMmczLmNy
bDAiBgNVHREEGzAZgRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcD
BDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU9IOrXBkaTFAmOmjl
0nu9X2Lzo+0wDQYJKoZIhvcNAQELBQADggEBADL+5FenxoguXoMm8ZG+bsMvN0LibFO75wee8cJI
3K8dcJ8y6rPc6yvMRqI7CNwjWV5kBT3aQPZCdqOlNLl/HnKJxBt3WJRWGePcE1s/ljK4Kg1rUQAo
e3Fx6cKh9/q3gqElSPU5pBOsCEy8cbi6UGA+IVifQ2Mrm5tsvYqWSaZ1mKTGz8/z8vxG2kGJZI6W
wL3owFiCmLmw5R8OH22wqf/7sQFMRpH5IQFLRYdU9uCUy5FlUAgiCEXegph8ytxvo8MgYyQcCOeg
BMfFgFEHuM2IgsDQyFC6XUViX6BQny67nlrO8pqwNRJ9Bdd7ykLCzCLOuR1znBAc2wAL9OKQe0cx
ggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMw
MQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDCXgDAeB
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgTaZ1AzbyLsDufhChWjnY
d5zZ0ku3wUTG5Fq+jDtUb18wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTI1MjEyMzQxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHm4yN3HKLpJWjWIPdMFMhZp57UgZSG1/TIhGx93
6m4UQy/zhHB5NRVTJFn7D/2Rx4KHsLthhK1xtqaYELxHIoOaSyFBTkDfqFBUcOeuRg4j+coS3/qV
SLyhBmfnW24XZX5+67gj9abKGFUATsUw0bsh5Nija9hat3ekQZkRrOlWr6o4W5zpsz5DL+uj44px
4xOsR6WBhw49uPITkdqMUOaH4vBwn5d7D7BSsgW0tfeRHUFBWJhCov30xuJmHgIg/bzC50wNUEHD
Ry9hDS/F0RA4D+QtbNuNCvs++zve+aD3q+6DPGG3wPcqHVbdEts2922GFOcN9qRhAVheuQxHf/g=
--000000000000e781ac05b9c0265e--
