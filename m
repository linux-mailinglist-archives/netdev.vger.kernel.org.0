Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBDB19F432
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgDFLMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:12:17 -0400
Received: from sonic308-20.consmr.mail.ir2.yahoo.com ([77.238.178.148]:39679
        "EHLO sonic308-20.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbgDFLMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 07:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=s2048; t=1586171534; bh=zDZ9QOYVUcd+Miv/XXcaBB39zkYnnckVxFmIYcplgp8=; h=Date:From:To:Subject:References:From:Subject; b=hcRJthcyM+mXY+yotGmdIPUtVQtkC7lsDJ4neaHUH1pSYg72jQLfhrmPj9TleIrFo+AsuJNSsxZUCcMvf8bUO3fRf4oOzbPpuqtz53RgeIuahXuYcmXpha8aWRJJw5jsYiWnPY0fFfq9udE51qk2EepCPNKXdXTdyc0/4NX5zj2zyKSDOhnNDZ903kbR1HL2mVEjJb+IXuWatT9TyWdVScrb20r8WcJJK05tgUFii5ZuMRHYGGXhg9J++qmcmFfl++H1Xk0adqx4qH6ZFMn5z1kdFbvItI7oWLJHwONqFlondsGiGdT7BdXQ4P8hpAUL3ZKUgDgzd/WekvkjoUSYyw==
X-YMail-OSG: fsIsK7UVM1m1_7f5b1gogFgRxxwuTfI3.NkBlfLQBXWQ83VhpltZxLlXOKXA8Mt
 z113TT6fMMmkvCB9oxTIQrd5mJqry_VuuTvrtB4JpT4y4IpcLo.u2FB4a2uSo53GmjuDgu9ccuUX
 5MGduly5DXm5xPm7Oi7IYMS_acmcYBqwUCqWRArwTnWgJGVZcQPQqifS2yyiPE5TeYr3JTAey7ry
 CEmP2_yTlXxWDcgNO42aNBmtlZ6OPdVZCbE8JZka7zKPaWOPkNFZz6VZG4lgyAj.a1p5qtggsIuL
 g9cV2LZfYJ8y7C6bxsZt1i1W_XRO0CgxYQgWVuEqZ81djXUZ8Nm1f8H4SVd.IvD_v58e3bqKFJON
 Dj3DMOmOecq24jgkB1OA1qcH9S.o45GDzzPsEamIXJxXSEC4dNdKkulhIF.GcC0zEDpyPxUzUpkY
 GUSAfn5Khm1HK7jx_bycACjJYClg_nUkD.86e.EW34jrtAe6Kyn7Mn6tFACogG2lOq8zHS7Bo_RI
 ktiUDTOql53eUAf4ep8JB2zPq.P2IEMcVuElkv7gwirzJsyWRqjx7VIdcejPA64aQY.LyUV9aIjS
 yQ8G8UXf_4NoZnVR8CrRBhl82Tymu1iYGI7jLRqE71nsqPg0syrZlMEmOj6lGObaxjmGPaZiFx0f
 Vk2.MzW18jt5dfenP3vz5Xr0rwbfNefwNkA9krKDjvbHOMyybUH9nfJ2Vc1PPuNV5_cZl_8vyXDs
 qnLAEDNeBstUiKNR1CExegjNJHMEonC9rDdY.V4jNjXmVYSvNSPhu1dqobnTuFIQK389_w725ofS
 VeO0PoxXeP7z3pO1fA0HV3_94nJpVEubysmIUDUE0qI3qZh9h3jbs1QWTHRMFzTEAi7KPheC_Qdl
 qIwXnuFzqbjrGk8i.M3rJPyvVpDg1f0mwMOBZEIMSSFGVvP.x13kZUff_0PmxQzl0MkmBCDrhpAD
 GzZYLBkBA_0UQdlnVWRagzDr1lEmHwDPZwlGXpFisnjf3ezBkly6uI383EcMIkGKlNUETGZJsu_S
 zQvOpNescqXBS3CLU3adXpeAX.V3DNG9wDFNUEDEPXS_gAZ06ZsXoDwS2WoVsumuVntXgPeqyK2Z
 YJvBOQSHgEqYsb5BS79MpwoovBnIdoZwiHiavsgDrpVp_si6CXF4xNMZrpjHsbFXav.60CFqOGxe
 eLACBM_qzD_WJGTtwMWYApgXU8GfFp37zAZecY2HEKaZecsTchB.fdtSXMRDln16uHniJ78.Fnhs
 r197uyiLrn.6nFhzYZyyD9mCudp6o75rur.A3R0wwf4nIOB_cKLz9PKDtQKCQj3Kb8jQjOpIdLXA
 NRdt9P8VipnbRKxjMouhOUJfkcQdqsKgE5eYV4Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ir2.yahoo.com with HTTP; Mon, 6 Apr 2020 11:12:14 +0000
Date:   Mon, 6 Apr 2020 11:12:09 +0000 (UTC)
From:   Jason Forster <jasonajf@btinternet.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <61151149.2061088.1586171529969@mail.yahoo.com>
Subject: Netem 'caveat' clarification
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <61151149.2061088.1586171529969.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15620 YMailNorrin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
I'm looking for clarification to the statement on=C2=A0https://wiki.linuxfo=
undation.org/networking/netem, namely;

Caveats
When loss is used locally (not on a bridge or router), the loss is reported=
 to the upper level protocols. This may cause TCP to resend and behave as i=
f there was no loss. When testing protocol reponse to loss it is best to us=
e a netem on a=C2=A0bridge=C2=A0or=C2=A0router


What are the limits to this statement? If I run on a router on a separate p=
iece of h/w with netem, then clearly there'll be no issue. Is it an invalid=
 configuration (which will in turn lead to misleading results) to run netem=
 in a container and implement the router functionality inside the container=
?

I've created a setup using a container configuration on which netem impairm=
ents were applied, routing the tcp iperf from the host to the container and=
 encouragingly saw the remote iperf server dealing with the lost packets. H=
owever, in an attempt to prove the container approach was not giving mislea=
ding results, I removed the container from the ip path, applied the losses =
locally and got the same results as those when running with the container. =
I was expecting the 'caveat' to be hit since these would be classed as loca=
l losses and the iperf server would not be seeing any packet loss.=C2=A0

Any pointers or info would be gratefully received.

Apologies if I've arrived at the wrong form - if so - please advise the cor=
rect address to post to.

Cheers,
Jason.
