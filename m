Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5A14F3EE
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 07:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFVFoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 01:44:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42796 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVFoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 01:44:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id l19so4338385pgh.9;
        Fri, 21 Jun 2019 22:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NWS4f+aR6LO6iXUHr6HD4me4LkyrGwLq4KbFdEdeA6c=;
        b=ULCKOc6OtZqjLETG5AND4K3JctUd3iKXZPNNT2E0muNoUNAA9yxkl3s01HndlEUcEv
         bnxzvmijdiRM1wm/AYc5BgudSln6kCDuNzZvWHicF8D8tL/kQU15XKLlJirX2XKu4RkD
         yq3Pxk4d0jKq4HtCSyqto/FRl3hFItwvNmfWYbJYZujgTLY5I0msV5B/5AUZc94yO2pe
         rDy1g2xk3sDw0lM9jcgpTF1cOar/9rj34kuMov8LEYggEYtYzZwnODZ6ycfvgPU9V9iE
         0/YNnvfZCQKlD/McuQ40dqUKTnWVkXubzGwFR12jXy4GUIsjqzH5PDkkJYVEX8lLRma9
         3cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NWS4f+aR6LO6iXUHr6HD4me4LkyrGwLq4KbFdEdeA6c=;
        b=skjdCaNFXBOVPiBgeYrVMEyqBp/cilgYeE2xyAaEFsbc9kg4OiAVB1fyGHN93qYUZv
         T8dbnJFugHlbZ6/0JK22z35wgnoemIu82ctggRLevtuynn6817RCgV2N7nsXaLWTgwPG
         L1ovqYvtvR/mB8iYk9Q3GWvLzCeszYAUf7sc3/y4q75KMJI7sJ7HtokVeay/IrBJvLLA
         l7G0R5OMIvcNmSFLuf5SCJNNkagwLLwrfQ1wN8GvnPtgqvhFIDEYqh+n0vKsGMFfAdNO
         UFEBY4PHHkvvbfW2vnc1l5heewQhoUAaU0zouXNSeGlY1w4D78e4LlUOUk99NZKMiptJ
         O2aw==
X-Gm-Message-State: APjAAAWTKXNBWrndpoQBvuKWvxhb/BG748taTSQCRERt5HzCT0Ronc+q
        mC8JjRRFSbP8nlueS2nWr74=
X-Google-Smtp-Source: APXvYqy44LRkDO3jBpFKRB2NBMTaoymaDYjBhrhVQpMK53mfBq31Cyq1LzAcH5uU0qmHOEHjbCCYmQ==
X-Received: by 2002:a63:d60c:: with SMTP id q12mr21757037pgg.176.1561182246687;
        Fri, 21 Jun 2019 22:44:06 -0700 (PDT)
Received: from Gentoo ([103.231.91.74])
        by smtp.gmail.com with ESMTPSA id a3sm6753566pfi.63.2019.06.21.22.44.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 22:44:05 -0700 (PDT)
Date:   Sat, 22 Jun 2019 11:13:47 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     pr-tracker-bot@kernel.org, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] Networking
Message-ID: <20190622054347.GA27816@Gentoo>
References: <20190621.212137.1249209897243384684.davem@davemloft.net>
 <156118140484.25946.9601116477028790363.pr-tracker-bot@kernel.org>
 <CAHk-=whArwYU0KwEps4A6oRniRJ-B8K6VFX7gF=YGuFFaxDxqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <CAHk-=whArwYU0KwEps4A6oRniRJ-B8K6VFX7gF=YGuFFaxDxqA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

ROFL ....bots gets confused ...we are blurring the boundaries Linus...:)

On 22:36 Fri 21 Jun , Linus Torvalds wrote:
>On Fri, Jun 21, 2019 at 10:30 PM <pr-tracker-bot@kernel.org> wrote:
>>
>> The pull request you sent on Fri, 21 Jun 2019 21:21:37 -0400 (EDT):
>>
>> > (unable to parse the git remote)
>
>This "unable to parse the git remote" is apparently because the pull
>request had an extraneous ':' in the remote description
>
>  git://git.kernel.org:/pub/scm/linux/kernel/git/davem/net.git
>                     ^^^
>
>which seems to have confused the pr-tracker-bot.
>
>               Linus

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0NwA8ACgkQsjqdtxFL
KRWQpggAulPoFvWzafYH4jgSKEhcIJQhnfnU+aBviuV9tu5Bz/qaBKeHEO7Anwa6
8X+PTQSfdS/vhugNI/R1x7le1pkW4XfA7VYUGNNnSx1ortPByx+nf1gmNPh9mrFW
ThXq+x8Ii8AI8zTHzha7W2KoT/g+OkjagVGL+9TP7eIQCxn6CCU5HJ9jjGi8xjkj
BAZtZ54gD3wOFN/2tbRVz5+z25lD8AGwpho7m4/wI96MOrNLm3wXX12dNrUrkygC
pa7gPcAwl3R6lIkSrNBPAhpSuyh3QP8KY1XoBPfE1N9BYJj2fmfBTDl7vHgh7HL/
CjrigEK2r/wwZe+YXqNu34sbk4eS1Q==
=2ky6
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
