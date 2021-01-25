Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E51230298A
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbhAYSGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 13:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730492AbhAYSFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 13:05:31 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9CCC061352
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 10:04:34 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id f11so16398482ljm.8
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 10:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hi8eEJ/yk5PJ62a6BMlL6QGK0R29YMVblOpWztZRESU=;
        b=W523EYuSoBQ6XSHobPpgZJPxh/oVfhbrZukiQqw+LxmQLS2rEiIQHOdBx7LTd6E7oC
         LgSWmLoy38gSrFbQaVYHVWGFdC/j/ad7d2o1RzDGb95cZqIkM/MsDTIRAsxcwgZU7/J/
         6grqEakbBrZs3qZSC/li5iIubLzXp2Oht3bLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hi8eEJ/yk5PJ62a6BMlL6QGK0R29YMVblOpWztZRESU=;
        b=Hxz6ZoCcOFx4Syoqg5Xht7NvMG4KyKEqD/Acm9sb/8bpvOZ6OvXv306MeGs09AO1dA
         sBI4AqFpAic8+NJcoE5h7fMIbln8v66SRp9uqU05IweREBOmRdaq0z4+q4l8roKwJdSR
         rNPXjK7PG6b1qu+v8mKOCdG5invhZLb4LElFWiR0ht92HNy4ycCNVuEewkcBTc6hARcB
         2yeTSrbs+m/wwwxNw70+B22RW2wPoEvs5Rpw5brD6RLPfxKS8iINKvPEnnoGySCp/zrQ
         hWCzN8YVYLP9pBcZtGmWFquTboZBwUlQ2HUW7RgabYZSJDSFHr70emuuIJJBygx3U0JE
         QUBQ==
X-Gm-Message-State: AOAM532bcIIeKFa2h7ohiIPz9X5HhanPlxWL6dyTv2X9bJAloKfxv92/
        CydRrK19cP7u6NW6ZNul1LTJAAWbCAN/OGXtPynnfw9t9/0=
X-Google-Smtp-Source: ABdhPJz2tLlw10UoVXSqH+n1Y5EJDfcMovsIx7yd9bJb2oAYExffchrX80nYP6B7SELod6imPY89siZsS6pB9lYZiDw=
X-Received: by 2002:a2e:9692:: with SMTP id q18mr749154lji.69.1611597873349;
 Mon, 25 Jan 2021 10:04:33 -0800 (PST)
MIME-Version: 1.0
References: <20210120093713.4000363-1-danieller@nvidia.com>
 <20210120093713.4000363-3-danieller@nvidia.com> <CAKOOJTzSSqGFzyL0jndK_y_S64C_imxORhACqp6RePDvtno6kA@mail.gmail.com>
 <DM6PR12MB4516E98950B9F79812CAB522D8BE9@DM6PR12MB4516.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB4516E98950B9F79812CAB522D8BE9@DM6PR12MB4516.namprd12.prod.outlook.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Mon, 25 Jan 2021 10:03:57 -0800
Message-ID: <CAKOOJTx_JHcaL9Wh2ROkpXVSF3jZVsnGHTSndB42xp61PzP9Vg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c81e0e05b9bd5e35"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c81e0e05b9bd5e35
Content-Type: text/plain; charset="UTF-8"

On Sun, Jan 24, 2021 at 12:36 AM Danielle Ratson <danieller@nvidia.com> wrote:

> > Why isn't this also handled using a capability bit as is done for
> > lanes? Is link_mode read-only? Should it / will it always be? If not,
> > can drivers also derive the other fields if asked to set link_mode?
>
> The link_mode param is only for deriving all the speed, lanes and duplex params in ethtool instead of deriving in driver and then > passing each individual, as Michal asked.

I understand the benefit of deriving the dependent fields in core code
rather than in each driver, I just don't think this is necessarily
mutually exclusive with being able to force a particular link mode at
the driver API, making link_mode R/W (and even extend this interface
to user space). For a driver that works internally in terms of the
link_mode it's returning, this would be more natural.

> > That would be easy enough. Why don't we simply allow user space to set
> > link mode directly too (in addition to being able to constrain lanes
> > for autoneg or forced speeds)?
>
> It is already possible to do using 'advertise' parameter.

That's not the same thing. If it were, you wouldn't need the lanes
parameter in the first place.

Regards,
Edwin Peer

--000000000000c81e0e05b9bd5e35
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
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgrngqT5lj+1gpDdfe2e/k
/OHXP7XbA21QKivf8ziRovEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTI1MTgwNDMzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADJVXgAq7lSFOHiRX5iR9Pbv4JnfV9N+tmsH2JVW
LC2ObB7ZnyFzO0cxiwDWe/Uevz+PIPO4YtDNGOaLF2M5LGeF8QwuSZsJX9CsvnC0S5xpJDHraazf
uNY1wAG3QdgeT9xlj4m7m6SVURe+FDAZ/oYU+eQEm9AvvsPgRyxqVvpa4Tf75GV/SDnu0lGS9PLI
Ne/GJ5S48h60w2WJMaS0QNDylPwXR39Nanfaok55kppHXW93ztdImB/wS73dJE4WQiBpPA9EQNmB
x1eWW+Do+mZ69gnEVPLK+KeINpi3tlBRnbHq4L5y3zqbZFdvnKgTxo2zWTw1jBzaZu90gXC7sAo=
--000000000000c81e0e05b9bd5e35--
