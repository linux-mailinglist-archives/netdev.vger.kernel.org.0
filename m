Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A8C10C452
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 08:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfK1HZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 02:25:44 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:49716 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfK1HZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 02:25:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1574925941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tdlxNmPjYz+T53Gzjo5bSd5rvu0/U9sFpAzZUIpHTf4=;
        b=bNjezSZJ4+JfYhaLI6ZHByOzf/g/QwZJrhzY1luZJRIUCRBZ5fFTBWQW4eOZ70YZwWOw76
        7t/tJfWXDW5VZuQ2/0duk63Hq6ooQnBIseefJO9PPpPPCGXY9s/BcjGsKdOIVujxzR83DA
        /T1n7uJiSOlcEUfqYivGmhB+b036rFQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     syzbot <syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jhs@mojatatu.com, jiri@resnulli.us, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        vinicius.gomes@intel.com, wang.yi59@zte.com.cn,
        xiyou.wangcong@gmail.com
Subject: Re: WARNING in mark_lock (3)
Date:   Thu, 28 Nov 2019 08:25:34 +0100
Message-ID: <2825703.dkhYCMB3mh@sven-edge>
In-Reply-To: <0000000000009aa32205985e78b6@google.com>
References: <0000000000009aa32205985e78b6@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2024983.uInpGIOpHj"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2024983.uInpGIOpHj
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday, 28 November 2019 03:00:01 CET syzbot wrote:
[...]
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=132ee536e00000
> start commit:   89d57ddd Merge tag 'media/v5.5-1' of git://git.kernel.org/..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=10aee536e00000

Can the syzbot infrastructure be told to ignore this crash in the bisect run? 
Because this should be an unrelated crash which is (hopefully) fixed in 
40e220b4218b ("batman-adv: Avoid free/alloc race when handling OGM buffer").

Kind regards,
	Sven

--nextPart2024983.uInpGIOpHj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl3fdm4ACgkQXYcKB8Em
e0Yhpg//TkD4LZe2QORpdzTJdAdLlx2bM1EYIhwWq2VPr+a/w89xre7Z0vpXmHHe
CBG+X/XCYev7EAJhDE7HQU/Jo4WRl0ukTNPprzHn0jcq8VcEIAl3qoqHg1ZhSImU
I242iP55uYzCcLfzj04hnlfgHHr5p8K4YMXUuSihL0SK2GGMdfMViRqb8mHXMwxi
vFaDAfI4mu0gmVm0MTo5ehel9e5VLVnmOJoBsReXXeXjLhjR70liSC1gzOKPQztk
oPiK8Ena8ZFDa6yEPPcB5sQQQfM0haPy1z3fmCFvIzAA9lnsYnJxIpWOBuzf2WfW
6hSeX6+zvXRGDV9R0cVsGpkRaslfHgl+B/gwVMdw2XtVkwUvX3GW4ugLe/4Yw3WK
jyzibIP1XunENnfUYwdPIMYXgMJxiJsZlS8ERWxBXG6fYlzTsKV5uKLYP3GfGuS2
/7cFTBC5xT7rCgiJ89CWhYRabfDJLUNpvi01s1jUBIG0AXyjev8xEHXwLV6qG8Ht
M6qzNcjrOnmOP80xzJrMvIr+lEawY3P5Gn3E/Ro6PoQzOs7zaVMV/Cg5VyTRyjQw
jPJ9bZmvGjw3zB/4mdYzSeDN8ZR1/bbv65OeI5IOo9Y+s4b8/reptZVROpXF2N7Y
CkO9awr7QYeRmeOHCtt+Adg5A6mJNz5LGUisgW1ZQJQzTLbOzVM=
=GMnl
-----END PGP SIGNATURE-----

--nextPart2024983.uInpGIOpHj--



