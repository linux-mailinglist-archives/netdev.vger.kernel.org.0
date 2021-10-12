Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991F942A67B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhJLN4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:56:30 -0400
Received: from mout.gmx.net ([212.227.17.22]:46289 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhJLN4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:56:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1634046867;
        bh=74hhc/PXFqCt+bKkHsZGaEq6oqa1tnflducNW48z4SE=;
        h=X-UI-Sender-Class:Subject:From:To:Date;
        b=VtpMxcrCHxG65k61sLerf1xVXarDppRBkEfpJyR9/3iK93ktEYJ/gVeSZyg3aGK6a
         B9O6FspFJLN5hIJV0L6s8MUhrA0N60LAaLkcMx4cw2PdrvDdh1RVj39bw1EXMk60ql
         +FaOngSkRWTpH5W1f8+eWFZ7H+4JPvx/aYt2CgG4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.221.148.49]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N49lJ-1mimXq1F6v-0102q7; Tue, 12
 Oct 2021 15:54:27 +0200
Message-ID: <0367ae6905b13851d3b8494ea8f2465bcd9c3ded.camel@gmx.de>
Subject: odd NFS v4.2 regression 4.4..5.15
From:   Mike Galbraith <efault@gmx.de>
To:     netdev <netdev@vger.kernel.org>
Date:   Tue, 12 Oct 2021 15:54:26 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:qkZcqGttJMmbgGnawl++zxgaRLl/Kqz7laGfiO3T/wg6nmi7Zf0
 /h+TqkIrM3uYgTZXF7NwRQOfyxAKdoyYcX5YVay0AHrw4LvfnBg/7LVG87T8ttX5aoGejQr
 kwn+TfejpH96ocBAFmrVpI2vp14zH/eDUXrtl6LDu/9ZgR3NLPqOVCQI/GhOQkldqE6QiOj
 fP9goy43qeFXWqH0WmSPA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pkPHv+Xxtcw=:PrjpxC0Tde95m9gOgnyaZF
 G6EcokOtFDBK24gjYU7iUUfX7WXIO/aQuOoz7WFlCURr7RIgit5sC77B57vGNGLTt5XJjLSLG
 6uC61quTH9jS/wfjFuIlPFQIH1/ozOvOYlUmR8d0Gy7cZ8jNsA5yQxSQVPwdFLPoZj9PpE3xY
 38OOPlrNEE6XdgvJ9I2fFXQz3mGo84a2ljQdHWijcwcoSPHfFWOEE6O6ftGr7gChoR9nBP9c3
 hS6YLEPN8TQUg0AmejBvLGolDyx/q7IzOkCZAFiLjxJmuyje8WmOjmrojbU9vCscGM3KhqgL0
 43dNZQSSv1JtNcPpE3peu3OmEd2xzi+mvg/6OwEP7m8JXUZ1ys/ehN7b8tNCItDUnr5RsZ0LD
 GyqqJSWxHGRJF+7QlusAdleZh6bL+oZ9uFZpP73xEPxsfXTifWIpCjKmS+B8+eVWcmiSqjr2/
 RaJsuv+t/vbTZHCDxhtxJqizMTcSANYy9s0vzCrkm5SxdM5831WNpv7gAJYQJ0dYhU6yhNI20
 obOzrR3/eqhd9v3XohuPmae3rFYr8W8rJiV4yS58SXxBLD8GtdiPpJ6sPK1BeMKqznMSwTMeE
 Hte8ERBs7CTY1bhDPttC7VeRqBgHrFcYdHw0NEWnpMah4Ktp9W2J31pOwrCeV8//Vk7ygoCuA
 lepfvojKNx3w/ocx+gZAbNJUbmPwFgFsx2XdBd1FRbjFdYThXC11Se7JMWg4YXNmFS4icaPOv
 nT+j0EMm4Qn6QbsZf/UFloaYlfEeNa7Nd+k2/9e+ZiSI4Kp6dPn4P0eWKF7PNerTg8dYt5zeB
 QQcdNV0XLlqt25weZ730XrRcqa19ltiU+ObGJ1COXk6gLCKJ9zlo5yueTltNZm2qaSdTd4bo/
 FrLBnqcCQwCSxMoOPsnyFjhSutQgsKsSHXKbQreE/6qhNkg/l8jLcjEcVCnJpwGlqjL/LVuS/
 DpTFKskzHrsR3Vfz0II/T5jkWGD7/VhlfnkZcFD+E295LkI232qgkMuvw50NlMcYdDt7vLGPw
 QsmP8DY6bvnU0+GPG69zA19gai+vP+rwHRp/Bul6Kli4Fx+MLuXuSXm0qhfqJrA9ryPdSY38t
 nRMHJfpcN9U7FQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings network wizards,

I seem to have stumbled across a kind of odd looking NFS regression
while looking at something unrelated.

I have a few VMs that are mirrors of my desktop box, including some
data, but they usually over-mount directories with tons of data via
NFS, thus hang off the host like a mini-me Siamese twin for testing.

In the data below, I run a script in git-daemon's home to extract RT
patch sets with git-format-patch, on the host for reference, on the
host in an NFS mount of itself, and the mini-me VM, where I started.

Note: bonnie throughput looked fine for v4.2.

host
time su - git -c ./format-rt-patches.sh
real    1m5.923s
user    0m54.692s
sys     0m11.550s

NFS mount my own box, and do the same from the same spot
time su git -c 'cd /homer/home/git;./format-rt-patches.sh'

4.4.231     v4.2        v3
1   real    2m27.046s   2m2.059s
    user    0m59.190s   0m58.701s
    sys     0m41.448s   0m32.541s

5.15-rc5    v4.2        v3
   real     3m14.954s   2m8.366s
   user     0m59.901s   0m58.317s
   sys      0m52.708s   0m32.313s
        vs 1   0.754       0.951

repeats     v4.2        v3
   real     3m16.313s   2m7.940s
   real     3m10.905s   2m8.029s

----

guest
time ./format-rt-patches.sh

host=4.4, mounted v4.2
          guest=5.15  guest=4.4  guest vs guest
1 real    3m38.334s   3m11.383s  .876
  user    1m7.747s    1m2.666s
  sys     0m53.721s   0m48.127s

host=4.4, mounted v3
          guest=5.15  guest=4.4
2 real    2m58.458s   2m46.857s  .934
  user    1m6.660s    1m3.685s
  sys     0m43.026s   0m42.657s
      vs 1   1.223       1.146

host=5.15,mounted v4.2
          guest=5.15  guest=4.4
3 real    4m49.320s   4m29.317s  .930
  user    1m5.740s    1m4.724s
  sys     1m12.240s   1m6.544s hmm..
      vs 1   0.754      0.710

  real    4m48.886s
  user    1m6.503s
  sys     1m14.910s *

  real    4m46.432s
  user    1m5.877s
  sys     1m15.251s * odd, only in guest

host=5.15,mounted v3
          guest=5.15  guest=4.4
4 real    3m6.965s    2m56.527s  .944
  user    1m5.192s    1m3.353s
  sys     0m45.775s   0m43.361s
      vs 2   0.954       0.945

