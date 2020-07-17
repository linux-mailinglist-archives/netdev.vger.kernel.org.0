Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458552241D1
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGQR3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:29:47 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:60586 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbgGQR3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:29:46 -0400
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4B7dRD4J2QzRhSV;
        Fri, 17 Jul 2020 19:29:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1595006984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uJr2b4jU2VVP6dxKKXRY+LDT5Rw2EvC3vE/csmHSnZ8=;
        b=R95BtOTYv8mnKQi5bmRsB5MtTR8/gziVmk+z4Jpc8MCRBWX3/F9fcCZinXOHJe65mHT+zQ
        ytABafxXTOvYWGYGQ3G+B6P/k7/8xIY7hv5qfI5yfxVYU9z4/So+S4PcZK0TQ+o5Vyw4u/
        mbsbsNeDmcqTWNfv3zko4jujFTnGAEAMojNoef0PH+P0I2ZTOye3QUvt9EKJEUurkiQCtk
        vSJLvdSvIdn3hVwW/ZOnoM7Uuza1kb6L+oQoh24BCxSnSNboIoZ1dk4ngTgyWXBHRdF+pO
        CurVM8Z9I7P1NQ4hBXyD0tVt9GColGEqgJzUeG/Lokrv+qh/fplu6iYIicFGxA==
From:   Pierre Sauter <pierre.sauter@stwm.de>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kernel-owner@vger.kernel.org
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()" breaks NFS Kerberos on upstream stable 5.4.y
Date:   Fri, 17 Jul 2020 19:29:44 +0200
Message-ID: <4546230.GXAFRqVoOG@keks.as.studentenwerk.mhn.de>
Organization: Studentenwerk
In-Reply-To: <0885F62B-F9D2-4248-9313-70DAA1A1DE71@oracle.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com> <5619613.lOV4Wx5bFT@keks.as.studentenwerk.mhn.de> <0885F62B-F9D2-4248-9313-70DAA1A1DE71@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chuck,

Am Donnerstag, 16. Juli 2020, 21:25:40 CEST schrieb Chuck Lever:
> So this makes me think there's a possibility you are not using upstream
> stable kernels. I can't help if I don't know what source code and commit
> stream you are using. It also makes me question the bisect result.

Yes you are right, I was referring to Ubuntu kernels 5.4.0-XX. From the
discussion in the Ubuntu bugtracker I got the impression that Ubuntu kernels
5.4.0-XX and upstream 5.4.XX are closely related, obviously they are not. T=
he
bisection was done by the original bug reporter and also refers to the Ubun=
tu
kernel.

In the meantime I tested v5.4.51 upstream, which shows no problems. Sorry f=
or
the bother.

> > My krb5 etype is aes256-cts-hmac-sha1-96.
>=20
> Thanks! And what is your NFS server and filesystem? It's possible that the
> client is not estimating the size of the reply correctly. Variables inclu=
de
> the size of file handles, MIC verifiers, and wrap tokens.

The server is Debian with v4.19.130 upstream, filesystem ext4.

> You might try:
>=20
> e8d70b321ecc ("SUNRPC: Fix another issue with MIC buffer space")

That one is actually in Ubuntus 5.4.0-40, from looking at the code.

Best Regards
=2D-=20
Pierre Sauter
Studentenwerk M=FCnchen
=2D------



