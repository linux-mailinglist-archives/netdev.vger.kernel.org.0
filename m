Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6082ED5C3
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbhAGRhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbhAGRhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:37:22 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D4FC0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:36:41 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o19so16530268lfo.1
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ah9ynpU8lE2uzSQ/GtjoWiQutCWeW27rf8zMnpLcnFc=;
        b=PMnqchlQTfnmu5VlaWWFzzbPXXSui2n3DGLhye4rqwRnly4NGNS/XhTaWCaYHdG5oY
         EV7gh6bfYcGcv5ifFapH3vA6BgkqIOl4Oeo3a8vEryvZDsgnn3DF2v5MrtE9qiEOAwmQ
         14iKWjaCPyEOWSXkK/Rful3RJwurBcKUgPZE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ah9ynpU8lE2uzSQ/GtjoWiQutCWeW27rf8zMnpLcnFc=;
        b=S/uIZbUa0kN0Vvmd/vor7p6/3Yr8BzQYPN1vvwWoA6/Ks8QgP0UxHgCpOnpu4P0iQd
         rlIPD6HrXK2/oN4MvHUn59eYIMnruOcXYePfwYOoJ73CzjN0jay6vHpv2msRj+jXLxc/
         NI91wZ7ImvcEc/C32c4aFBYPGaS8RhrdRgTOxqq1kuyZq8ic1cLd7BIosrn7DBqb3Cr7
         6eQ9lvqd+8WMnnI/UMQjKVhRBfh46aVr9rfP2zv0/eTXeveZrO18I3GQfUHhGwAbPjqJ
         lvtHmpdnY3eBShgWkhgy0o3Dz2K7p3gTPheaVaolYsK87gnQ7aCH7o8dJxScwsY4clQF
         AFdA==
X-Gm-Message-State: AOAM530WyEy6HZNoIi4Lpnd01LVevh7MgPIR/KCXq8C4bA/j/SeJ27DD
        FocAq3sRWzPzexR5Lm4Wc968wt3/vBtBRiiZSIFY9PQskj8=
X-Google-Smtp-Source: ABdhPJy8AnfciM4V/1bZWmun012CEgrcZY17W9ZtjnJFmPpU3Ntz8yNndCGAUksH/6zwpGuPFCt7bz+Rns4lJ1eXne0=
X-Received: by 2002:a2e:89d9:: with SMTP id c25mr5012266ljk.410.1610040999609;
 Thu, 07 Jan 2021 09:36:39 -0800 (PST)
MIME-Version: 1.0
References: <20210106130622.2110387-1-danieller@mellanox.com>
In-Reply-To: <20210106130622.2110387-1-danieller@mellanox.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Thu, 7 Jan 2021 09:36:03 -0800
Message-ID: <CAKOOJTx=Cz1yCDxCC3AmroQUd=zHmw0NH1eCGVNd6u4PfBjR_Q@mail.gmail.com>
Subject: Re: [PATCH net-next repost v2 0/7] Support setting lanes via ethtool
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, f.fainelli@gmail.com,
        Michal Kubecek <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e0e16c05b852e1a0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e0e16c05b852e1a0
Content-Type: text/plain; charset="UTF-8"

I still don't think it is appropriate for the UAPI to be defined in
terms of lanes. I would prefer to see it defined in terms of signal
modulation (for which multiple could conceivably exist for a given
lane configuration, even though no such ambiguity exists for today's
defined modes). Better still would be to define the UAPI in terms of
the absolute link mode enum index (with the modes that are not
compatible with the presently installed media type being rejected).

Regards,
Edwin Peer

On Wed, Jan 6, 2021 at 5:08 AM Danielle Ratson <danieller@mellanox.com> wrote:
>
> From: Danielle Ratson <danieller@nvidia.com>
>
> Some speeds can be achieved with different number of lanes. For example,
> 100Gbps can be achieved using two lanes of 50Gbps or four lanes of
> 25Gbps. This patch set adds a new selector that allows ethtool to
> advertise link modes according to their number of lanes and also force a
> specific number of lanes when autonegotiation is off.
>
> Advertising all link modes with a speed of 100Gbps that use two lanes:
>
> $ ethtool -s swp1 speed 100000 lanes 2 autoneg on
>
> Forcing a speed of 100Gbps using four lanes:
>
> $ ethtool -s swp1 speed 100000 lanes 4 autoneg off
>
> Patch set overview:
>
> Patch #1 allows user space to configure the desired number of lanes.
>
> Patch #2-#3 adjusts ethtool to dump to user space the number of lanes
> currently in use.
>
> Patches #4-#6 add support for lanes configuration in mlxsw.
>
> Patch #7 adds a selftest.
>
> v2:
>         * Patch #1: Remove ETHTOOL_LANES defines and simply use a number
>           instead.
>         * Patches #2,#6: Pass link mode from driver to ethtool instead
>         * of the parameters themselves.
>         * Patch #5: Add an actual width field for spectrum-2 link modes
>           in order to set the suitable link mode when lanes parameter is
>           passed.
>         * Patch #6: Changed lanes to be unsigned in
>           'struct link_mode_info'.
>         * Patch #7: Remove the test for recieving max_width when lanes
>         * is not set by user. When not setting lanes, we don't promise
>           anything regarding what number of lanes will be chosen.
>
> Danielle Ratson (7):
>   ethtool: Extend link modes settings uAPI with lanes
>   ethtool: Get link mode in use instead of speed and duplex parameters
>   ethtool: Expose the number of lanes in use
>   mlxsw: ethtool: Remove max lanes filtering
>   mlxsw: ethtool: Add support for setting lanes when autoneg is off
>   mlxsw: ethtool: Pass link mode in use to ethtool
>   net: selftests: Add lanes setting test
>
>  Documentation/networking/ethtool-netlink.rst  |  12 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 +-
>  .../mellanox/mlxsw/spectrum_ethtool.c         | 168 +++++----
>  include/linux/ethtool.h                       |   5 +
>  include/uapi/linux/ethtool.h                  |   4 +
>  include/uapi/linux/ethtool_netlink.h          |   1 +
>  net/ethtool/linkmodes.c                       | 321 +++++++++++-------
>  net/ethtool/netlink.h                         |   2 +-
>  .../selftests/net/forwarding/ethtool_lanes.sh | 186 ++++++++++
>  .../selftests/net/forwarding/ethtool_lib.sh   |  34 ++
>  tools/testing/selftests/net/forwarding/lib.sh |  28 ++
>  11 files changed, 570 insertions(+), 204 deletions(-)
>  create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lanes.sh
>
> --
> 2.26.2
>

--000000000000e0e16c05b852e1a0
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
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg+QkCfBiLITCphym3EnCW
5NG9F33M6C71OefKlv+O3dkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTA3MTczNjM5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAB18AKhlji5KDTQr5YEA6TsJ4K9WRPc1MhuTo8+S
ri/81KJzGqUmD5OdmC8kRZw7dK2CKT6vEpfK3tR+1fbhXf8HGktEoM88CatX46QXcRbbGqMMSS1i
ZaaVcKRQTv0sSBtKQPpIPmcPqDjAniUQs5do8I7j6BbC9prvOTWfGdEX/9r+JG7uxalRTI0o31ph
0ixDR97DF+HKHaB6fh/Hb5J71zf9L2qujrYhUStguABDob0n5WotLOkOeAWuqxcd+NZK24IPAn1p
8cUYRkAaN/k7DgzJnfOIPg4Tr4xnhTqJcsovsQ2w/gW+U70sPboxW7vMA0JixCBzCQjtA8E0D3Y=
--000000000000e0e16c05b852e1a0--
