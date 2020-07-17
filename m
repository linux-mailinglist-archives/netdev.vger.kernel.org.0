Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43CA223382
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGQGSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgGQGSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:18:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EA7C061755;
        Thu, 16 Jul 2020 23:18:32 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id x9so5020494plr.2;
        Thu, 16 Jul 2020 23:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=38x0+yFXgM144DcOh++ohQw3llr/3xl5VFGXiH0Y9VU=;
        b=Zqlgc/mmZFfGFzf1p7WuYTz8h3f2JG7bboaKxhsEyBHzk+64uhI1ffpjQfQEYbLnyG
         t27N3ZzeaimzU//a0IFZN7ST4Gtx+ZiWpOjplUfdUdlMvl4FyVgiZRmRwq2pfJKa9nyp
         EW6t4Oagyju/v3C6bFp0PeMsYlng7XNMwRdK8s7mCJ354rwVXzBqIbM/wbiMnEqaGwFj
         QIU8CA9SoMlvIDcVYV6aPLtQg2z/rQ5hTo94cUlWwUpjptbx9txpAvBZ0WKcOyRjPM3G
         7gnSs4VcLNMPX1H8Sop/uqmkTsVWmG0KJjgnGp8Fj/JZd5ivwsvAPy1wOwd5IkTg+/ox
         fVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=38x0+yFXgM144DcOh++ohQw3llr/3xl5VFGXiH0Y9VU=;
        b=M3jp7sidQYMubjj1/4+8fj8+mnnsolwbg5SVS/EpWB9iJzDwE2jwFvIW7D3+McchJH
         auVo88pBW8FnKAnlsDsOg3WG3qguXh1Y5xCyrDxYG1W9ZKOo5/UVSBQkIyD7WlGV2QOi
         SCOoNzfcwxEioNedpfCNOgLHeI/H0Vs+ixC3nveeu4PTj45+IMves0fSX34A+8zVGBLo
         huA6jz3Fl2RstnhPtYVl6Qs4boXVg7VmyETl1yriW0xMHIcrdBqCwCyGbiMCyyK0Me+U
         57yMJyGfPLxJBCCfgbeXghoXvMhjttEfgri+r6dDx/nh50IXxvE6C1Pyn16Md8Tt30GG
         YKWw==
X-Gm-Message-State: AOAM533NVg5sjcyIvXJ6CwxU6O/qaSdu899luLUu6Bt+2P9YYferKa1X
        glcckv/Asa0kvYQ0xMmQde4=
X-Google-Smtp-Source: ABdhPJzbxmw+oFVlzhQCGitT+5OUpjyeRTJHXp3qVn7YoBAxqfcN7Pl/dL7BQlZE1t0hhB6ixNHKAQ==
X-Received: by 2002:a17:90a:70c3:: with SMTP id a3mr8455627pjm.107.1594966712063;
        Thu, 16 Jul 2020 23:18:32 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id w71sm6390469pfd.6.2020.07.16.23.18.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jul 2020 23:18:31 -0700 (PDT)
Date:   Fri, 17 Jul 2020 11:48:16 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     davem@davemloft.org, kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: net: decnet: TODO Items
Message-ID: <20200717061816.GA12159@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Maintainers and Developers,
	I am interested in the DECnet TODO list.
I just need a quick response whether they are worth doing or not
for the amount of development happening in this subsystem is extremely
low and I can't help but question whether I should indulge in any of
the listed works or not.

Thanks,

Suraj Upadhyay.


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8RQp8ACgkQ+gRsbIfe
744gVBAAjinwdE0AeQiJVAltYcVkCbywDsdeBERk2RXrhUeFy2Xe25gv0ZpLPNRa
5SrSw2ZzLHxL+F0ikagLWVZ0oLcGDdcwIX91aCdpQh8ECVnp3Mk/UbFwtybQmqFs
6QrgBYFylLflyQsQtfDLBEozktYLkFZwMpPbjQ/GG8HZAO5/0nSMfITHC+7fnsHs
B4XlKeMMZBv69aqCVWitoM2xaF47zlms0oZsrdMvmxpQYPEB1XovLv751j4r/WR+
uqTMe0XQdnF7tnxala4E1UYCeHgIspcBVAVNPHh/M0SLFhs0RqF2JpmlV3KoOU3q
d5adZidA+NEjWLFy8QU1DoiDHsorcosxlCj78c4suF8JavaeHZzU+fOtJvDy0pk2
DDKiADYs2UIOy8GXZ5kXd/lvelbOpl+Huy/DoUbdvMpg2NCGpDK4Y0GJI5kYSClE
9P6Dw/wN4USnmYVeCUcaccytivliqQ4HskNCNmdWR6InVgGjJWJ3AR5owq6l4WAW
wViMGGWslhkHfKk8yWVCMWh2ePJiS3Zm7SvAaM8VGPH7cqJsUODPy14wczJeS1I8
Wj6glPlZMww0LBG+juIZjMMpovtcyCALB+4Cf3HgdaDmZhPnECH+UrzQTv3OeUza
QkYtkz2cqJApCD2WL8anjgYCsC0MbE1j5Uk4heTa+ZBihof8GgY=
=Lz2n
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
