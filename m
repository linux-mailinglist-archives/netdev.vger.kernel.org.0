Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8927C302C74
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbhAYUYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732202AbhAYUXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 15:23:19 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDAAC061573
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 12:22:39 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id l27so3373459qki.9
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 12:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MvsjRn4Ln0mYx54lfs9m9KWMDREYVaSef690hRZ+Qgs=;
        b=BzK4utLOD0qI0Z6kvCMTW1AEH0xHSdKPg0k6jozjJAy+CKzZYnuFGClZi2XUM4oBT3
         BCkBt6KRPwd98htKgSBq6Iik0AYlx2Hpq95T7uqhbx9LihiSr1KdVwkCHH/v6Dx2Ajjn
         EAQjd8YU/eBZBQvf3DJjDc/gVZNLgmR3TIYiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MvsjRn4Ln0mYx54lfs9m9KWMDREYVaSef690hRZ+Qgs=;
        b=JacKcEGgQbqKWECE/uYNgzm5pPl6YyGZyYZf2ZJVkVTiRtELG2faTbOEIg/Mb754MW
         4mj0Z2AerwJWtJ2Fh45+tG1/+GcLUy8MHBRgXS6+Q/9yTS8ozPfjwhc5f/R4I0Lce4u9
         hC5RIJsvEb5wKG/shGdF+OFkClboQScrRIu2zYkk94yoc+hwP2al1TDTifKVAlAfdEXL
         BGXBCt2ghhzJlWDalZsqD+HTgLE/3r726gH5FdqfWrohpbpLsw8hjaU6RZUdqZX7ss8j
         Tc84S393cYi9cXHH66mSg9TewUn7WJztZ7jtYMPV8KNMQKn+49lazHFukgO2q+WXwIJC
         wGlQ==
X-Gm-Message-State: AOAM530ZdoquiyeCroCBF55s6H0enAe2rbdE+LfDq7xCBwzYBcfmvsok
        4CrfToZ2LDt5UhG25mwMSeczE79w5Sa3klKAr4dcTw==
X-Google-Smtp-Source: ABdhPJxCOn/UZuEW8ayScFFrS/ZpRIJtosrpnwQAtjaB49ONMWXBTj/wfcNW3iXFa0fd1d/FBGsVboRDLSDk/y69Vhw=
X-Received: by 2002:a05:620a:898:: with SMTP id b24mr2558280qka.269.1611606158177;
 Mon, 25 Jan 2021 12:22:38 -0800 (PST)
MIME-Version: 1.0
References: <20210122193658.282884-1-saeed@kernel.org> <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
 <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210125132210.GJ4147@nvidia.com> <CAKOOJTx9V328r+TC_Pd0LXQr6aMaiK2eB4Qu77Dw-kc00vg3Bg@mail.gmail.com>
 <20210125194941.GZ4147@nvidia.com> <CAKOOJTwuziJWKUFVNMtqbOeMnRx6eJF54zEu7GDaUJr_Tx1Rtw@mail.gmail.com>
In-Reply-To: <CAKOOJTwuziJWKUFVNMtqbOeMnRx6eJF54zEu7GDaUJr_Tx1Rtw@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 25 Jan 2021 12:22:27 -0800
Message-ID: <CACKFLimAQtVSbo7mw6_CGU5E_a_by+9rwsh0HwXW7gZ_jaCdfA@mail.gmail.com>
Subject: Re: [pull request][net-next V10 00/14] Add mlx5 subfunction support
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
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
        boundary="0000000000009e982705b9bf4c32"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009e982705b9bf4c32
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 25, 2021 at 12:09 PM Edwin Peer <edwin.peer@broadcom.com> wrote:
>
> On Mon, Jan 25, 2021 at 11:49 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> > I've never seen someone implement a NumVF > 256 by co-opting the bus
> > number.
>
> Usually the VF offset already places the VF routing IDs into a
> different bus number range from the PF. That much at least works
> today.
>
> > Can Linux even assign more bus numbers to a port without firmware
> > help? Bus numbers are something that requires the root complex to be
> > aware of to setup routability.
>
> I'm not sure, presumably something already infers this for the first
> additional bus number based on the SR-IOV config capability?
>

Yes, this should work.  During enumeration, it sees that a device
capable of SRIOV needs more than one bus number and will assign the
proper primary and secondary bus numbers to the upstream bridge.

--0000000000009e982705b9bf4c32
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgSG0kIzyinXB3
u/k9retzmeQEXto4eeB085/ZDo+12H8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjEwMTI1MjAyMjM4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKXGmpp6SA32IG2/AoPOxJvL9boIycAW
WGH2T1GQMJZ8aB38JlCz4EYQiQs9rqBnUS03FKPJRNS3s7FZgeUazAfC4zRCzeyL3wA+vUe1Hbfi
A3g2/XTZfjvN23zH99QKwcdCJSIyhr7Vg32cGdrva6KjljA90f4q8gMv+wpGgSWMdM1zP4NbVgG/
nQAUahEWVwAs3agtBZvGiGotRdDUIJPW5EiQoHLR7tLMr6gk6lHXCrIqRiNbKnTFRKeI7baS0w8q
uW5CujPqTEx6eCxUK1YBvC2/amIyCu6fjXtmsEPoOueA0HrWWfW2IJ5sqkDhcFZ0+aemZ2+fhCZv
u9mfi2A=
--0000000000009e982705b9bf4c32--
