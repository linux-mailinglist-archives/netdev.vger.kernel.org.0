Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37ECB14CAC2
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 13:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgA2MXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 07:23:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35103 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2MXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 07:23:15 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so8761338pgk.2;
        Wed, 29 Jan 2020 04:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zw2QOXTYa4DPfoFWBlgmT0QVWsY+VSIRNslcmp73E4U=;
        b=dLloQdRrHAzD9N+RT3r+t+VeVn1ngk7JOdmn4PXhf9VBwZ5aqozvIWUq0QzaSf+6w2
         49nN1Nl1bC6myj8/VRFvqtknJXFC9Bw8rZ4pXwBXjGnfRpIzQFHeStnGX84YaP8wOvmm
         43IkND/A1PK9AndEw8xUfQVnteZ6/CiuAS9Zp3HIfBa0iwSTA2Zcw41EkjM1x1caTvU4
         gr9y9Rx/QoQmf0wCJBBaklKAwEtYIHWh7+UKTlnASItW7O9w4r/9nCWX/K+P3Bs/1mv5
         S9YKrAUWrzS4p3Q0DyrxvV2iSdNIGY8XoA67arpfYzNPZabxza5uhPQmzGj85/yl6EvV
         VOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Zw2QOXTYa4DPfoFWBlgmT0QVWsY+VSIRNslcmp73E4U=;
        b=MhYhGi/eSDH4MZ03LoKe1f40cR3hm/AyhyURHTPoTlSiP3hB2VnBjJ66JOlze2HPk9
         ak/GD0YsfRHmfrngz/SY+eePXYV0WJos9hVG+KucpurXvW4bs21KjV6aqFz+mxFADNCI
         UAfjQ7M1x0o7n/e+g2w4oa+day7jQADnrWwFSZuvkwoMmjivCZVJp2pgilSHsZ7gqFUM
         1hqKg6zaV7CTJsFGkWlrnsBGxmOD4vwhT0Eckpzr4dhVEuRSrgDF+CKB4J8MqUDepqzY
         hCdmHjh5k1I0TSOrF2cFVl8gPLOYO+Lpd5R4YhBDseB9OWzrVZtRd0k2w3I6h5KuN8jk
         eR9Q==
X-Gm-Message-State: APjAAAW8hv7xy7yGfFQ1CGzE5JyQs4BzU81N6Eg1iQqiaPAt5xrEEJRO
        Io2N7eAdSfn/GDzzB1k1Pko=
X-Google-Smtp-Source: APXvYqxsajtGXiWfJo7puAJC96Gh1QHON9TNgislJuPYpCDA2oHS69K5SxciFe4TldTfyBS2XnF8Mg==
X-Received: by 2002:a63:f403:: with SMTP id g3mr30619483pgi.62.1580300594266;
        Wed, 29 Jan 2020 04:23:14 -0800 (PST)
Received: from Gentoo ([103.231.91.35])
        by smtp.gmail.com with ESMTPSA id r145sm2749967pfr.5.2020.01.29.04.23.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jan 2020 04:23:13 -0800 (PST)
Date:   Wed, 29 Jan 2020 17:53:01 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: wireguard ci hooked up to quite a few kernel trees
Message-ID: <20200129122259.GA25949@Gentoo>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <CAHmME9rProfVf4VGHGX9no3KTa08nL_oYkK8Nv+eknk4ewVMAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <CAHmME9rProfVf4VGHGX9no3KTa08nL_oYkK8Nv+eknk4ewVMAw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Looks bloody good Jason! thanks, man!

~Bhaskar

On 13:15 Wed 29 Jan 2020, Jason A. Donenfeld wrote:
>Hi all,
>
>With the merging of wireguard, I've hooked the project's CI up to
>quite a few trees. We now have:
>
>- net-next
>- net
>- linux-next
>- linux (Linus' tree)
>- wireguard-linux (my tree)
>- wireguard-linux-compat (backports to kernels 3.10 - 5.5)
>
>When the various pushes and pulls click a few more cranks through the
>machinery, I'll probably add crypto and cryptodev, and eventually
>Greg's stable trees. If anybody has suggestions on other relevant
>trees that might help catch bugs as early as possible, I'm all ears.
>
>Right now builds are kicked off for every single commit made to each
>one of these trees, on x86_64, i686, aarch64, aarch64_be, arm, armeb,
>mips64, mips64el, mips, mipsel, powerpc64le, powerpc, and m68k. For
>each of these, a fresh kernel and miniature userland containing the
>test suite is built from source, and then booted in qemu.
>
>Even though the CI at the moment is focused on the wireguard test
>suite, it has a habit of finding lots of bugs and regressions in other
>weird places. For example, linux-next is failing at the moment on a
>few archs.
>
>I run this locally every day all day while developing kernel things
>too. It's one command to test a full kernel for whatever thing I'm
>working on, and this winds up saving a lot of time in development and
>lets me debug things with printk in the dumbest ways possible while
>still being productive and efficient.
>
>You can view the current build status here:
>https://www.wireguard.com/build-status/
>
>This sort of CI is another take on the kernel CI problem; I know a few
>organizations are doing similar things. I'd be happy to eventually
>expand this into something more general, should there be sufficient
>interest -- probably initially on networking stuff -- or it might turn
>out that this simply inspires something else that is more general and
>robust, which is fine too. Either way, here's my contribution to the
>modicum of kernel CI things happening.
>
>Regards,
>Jason

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl4xeR8ACgkQsjqdtxFL
KRX0iQf/TkKseJ2jksqjmC+bnMd9mnIox1pWzGwElpv1csKIwul3m+TnHGRFSCOu
FBbHlw0MSrrEB0dOyG5NJr2GqtGiEJ1ogoLT6XjUq4qpcaIljJU3gU35c6UKiM12
ThYstC9ZfdXoPgPI5n5qL3p8rTp71Aj7b947ZRfQ2SEMQiEZ5wEgwAwK+fV0yAsa
VwqJxZy2jZTiOABqW8Ez65YyhceUDvGfv0G1K6EdZdyWfHsoOHXUH24C4jdtGFWi
m+I7ZnFM9LFlzz1Fyh62PDwIBMYHegW3rvm6q3XawJo4+8VYodApw5axbRDfjGFK
tMcQCZyCSD4Rtpv+Vrfg0Toveq4nOw==
=cnyd
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
