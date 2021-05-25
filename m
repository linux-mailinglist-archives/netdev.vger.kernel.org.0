Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB24390410
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhEYOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:37:24 -0400
Received: from mout.gmx.net ([212.227.15.19]:35865 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234006AbhEYOhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 10:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621953325;
        bh=Ha1O3oUIO/SlFZmTV1A1Y6JxFCDIcBoTObhEx9un/Qs=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=OzESSQj+KxyTt5cHgi24OmtRTTIkHGk82Flj368i2fqc2CIQrSOz0OnAPCTSPDY9r
         4k9voRTqprZtp5X/d+HSvU7RwTIMJi/eymXpYkygLbZnU4CPdV0ZAs+/mH/dKSbSNw
         ViEC0RSjFK7X91PPsFC29EWLpiPqccdFiQQqraCw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.224.228] ([157.180.224.228]) by web-mail.gmx.net
 (3c-app-gmx-bs13.server.lan [172.19.170.65]) (via HTTP); Tue, 25 May 2021
 16:35:25 +0200
MIME-Version: 1.0
Message-ID: <trinity-47a1b1c6-2edc-4786-b085-158df0bd532b-1621953325491@3c-app-gmx-bs13>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Aw: Re: Crosscompiling iproute2
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 25 May 2021 16:35:25 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:1Iloy72L06sZBdv07/wBU32/mLJ7MIRKTS+JsJirG+gjBtrMNIxzDjrKsmWyFD+8YOi//
 8JQAXsZSJoZWMag4C1xE+viTFyDY3WtM9G7zkqwgtuuYusphIHNKe5YdBEZro25j7YzDSUi4MAW5
 GoqDXuuwufvzrj/mMfODj0eh3qEISvkvavgr+CZGpqTkTFNeba7I51d4Cr3skLo9GP+FOFKkLk+V
 6xw3MIpkDckSuHDyhHqn6At4cekpD8sMA4f2XY6pXNa/FwreWPQ8R1tkczAyEJaKEGuFT73gRPpS
 PE=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ewbb04hsOeY=:zpPw8y9w9Yjoo8Zzpc/E5/
 JMJB7hWYmR4hYZCGF4Ntlq6w3oLZ1K7eQNe/6CGxyMRo789+kmOnIS5R+kwZvzK56va7ynNAe
 7j6mmfUAfG3TSnePjcqWLDMuhaOqfIGG0ZgMYQ0eXR2hH68OfzIJTtt5meWIgrelRH6Tf/DDc
 ieAyu1EoXJmh0bGX8RAlE24CZetyvnlDiNJyU5pksfoHp5QJTNaWbgEdgW+GOG/LnJudhsES+
 HM0prTdpqW+7aflsaQvGLHYWjWPRt8XmYUOlyVkijSKXxEu2VUJv41M+xp5VGUJRP54xysc19
 Jya86adEEaiBFdCdy51KQSwVcoaFFQZas3S0Nxzikmxq/qrjnikwuaz9nLLXwPR7j/DqM+IGY
 CqyigDi78tL2vqnRNGm6k4/o/x8bMbI5DvWCTywyTStv1G3OCZBk1vV6Ci/xAY9NYZ84l/iVw
 e1xerVpME1zCH4RKXV9AhYjGNMgliDYRTZs8cfIfxUqSGqAnuMSVe/RICG0tLt175Ul0APw2V
 uHHaQcSV/RR8prZy9Pf48GklCaGI8YEMymtNzQgbdnH7vOfmOa00P27m4w/lQ1sZzoSHVQMjq
 k+Z5KdSUeOj7IPes+rUr62Qkz8tdoLfA+OoxKclc5U6gXNTYaMNtj23PeCumfhDSoxMokqECI
 zB6KzUAu5KqJaLwc7KwmiuEM3LjYH3MRhUW/slB1kY51Y5cw7R32oZ+8w/bx/M19CSq1jTBXa
 9+dKsdSKE9mzmyamHdbrXfWqbmywzKCXSN3D5Gnt9kCH4H2VTrSbXhR/p1Qdd5vppFqdnD2IC
 SHiMMzHSQWAfUZOTgefOar5/7dm0W9qq5wK/IW0nNjY+c1/y/EBMtCKN96tADRn9ZKOmkRNWP
 clrYEFAJfqFaIDNqM9PIMF8Vcp8ZcU55I5nuIRGatEHybh3dvBkHExqMFhUeqUVpfIgzZpDye
 B2C08enGNkA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi, sorry for posting again, but i found out that make clean does not remove config.mk, and there i had disabled libmnl and selinux, i removed the file and it is recreated. now i'm back on the compile errors because of these 2 libs missing. if i disable them, compile works, but i guess it's broken again...

#HAVE_SELINUX:=y
#LDLIBS += -lselinux
#CFLAGS += -DHAVE_SELINUX
#HAVE_MNL:=y
#CFLAGS += -DHAVE_LIBMNL
#LDLIBS += -lmnl

i'm not sure if the libs are really needed, but i cannot install them directly for target-arch (armhf)...i guess i need to compile them with cross gcc too (have done libmnl for nftables). but how to reference it to Makefile.

regards Frank
