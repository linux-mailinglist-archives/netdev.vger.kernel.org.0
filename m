Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AFA1EDC95
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 06:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgFDEwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 00:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgFDEwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 00:52:49 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F08C05BD43
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 21:52:49 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id w3so4811264qkb.6
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 21:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pumpkinnet-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=/0ZiOVJeJYR3beybSQLkUOQhQ/JD5VQFmTppL80KkH8=;
        b=Q3hqeKuU8XTd4jw0aTLt+jjQE/ABuDnRXRQsUy0D3r76R6h+hpAXsZgm/JNebU3D5/
         q4iSrCPPkjpjNU8XanC6egzmhN9RMSRo2ASiVjxY8E7lkQxHmk8YaH0U89chlQ4jFbF4
         gqntpRuZChvpuxlVLYN9vY05t7SuLq4FgOo+xVS96LVN5llv71iK+0j8n/prtY+nm6Ah
         Bf8IHe+gJphHmtOc8mZFJhu0G9k+NEPjFx5UmXuz4w2jHCfWVopVXEHCDi92lqcrxH64
         NoR4BMqZqkEXNKX2gWYD5FVKRCbT58wOgLVOz5twKQ0TnMqnwJ/9rnH6KHPOTrgr7cEn
         YqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=/0ZiOVJeJYR3beybSQLkUOQhQ/JD5VQFmTppL80KkH8=;
        b=KGdDS9Q+1HsIBpHS7zFkcqO9TQsoF0vhcljt7AEdpYegkEZlUqmBeTm1pHd52iF3pJ
         o+tmxjOPQ095Pm+q0dUqk+k9qzJ6aVTorFdgFQH8PcyLimlmTjXsidxhFpGWxqog1iq7
         LmawwVs6itBvm8EW7E5zEKSfVRyXXa6lxk/9mmESAvxMo0EjkeZSIafJG4uPtUzL6FDz
         eZFVfdOyS+JyHsIStu4DQCJIj3r63LltKC5A3y1lbPGSty5v6jceEznxrL2E/j7C2kDO
         BMM9EsklVGW01wY6MilzQQ0/zN+zazA0yTn7QD/XgIAmQgfuOSb3JGtAaq+iq0uEus5q
         s+TA==
X-Gm-Message-State: AOAM530/10MnIyVXboKNJMIbuF5DGtQBWUPP5Lyq1HoLhKf8IuNHRCfw
        fIu8WMTJ70WtM379GHWFw6HMWgZns5kMvoMi8ff40i5Wf8k=
X-Google-Smtp-Source: ABdhPJxOHXdaNLVVEcCr9XlWTrnr7VkWtSa77f9LOIsksbjIgzJ/wX+UbgcIFCGa+QDI63d5k/JMM5dl7LyaY98HdKs=
X-Received: by 2002:a05:620a:49c:: with SMTP id 28mr3185262qkr.168.1591246367909;
 Wed, 03 Jun 2020 21:52:47 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?6rCV7Jyg6rG0?= <yugun819@pumpkinnet.com>
Date:   Thu, 4 Jun 2020 13:52:37 +0900
Message-ID: <CALMTMJKSAOmFWupKnh62Hu_h43MM-x=2T7sU4Sw+Wqf9B7m5xA@mail.gmail.com>
Subject: Question about ICMPv6 parameter problem
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?B?6rmA7KO87Jew?= <joykim@pumpkinnet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

I'm testing linux kernels(v5.7, v4.19, ...) to get ipv6ready logo certifica=
te.

The reason why I am writing this mail is to inquire about the failed test c=
ase.

In the test case, It appears to be verifying the following clause.

RFC8200/page-21
( https://tools.ietf.org/html/rfc8200#page-21 )
      o  If the first fragment does not include all headers through an
         Upper-Layer header, then that fragment should be discarded and
         an ICMP Parameter Problem, Code 3, message should be sent to
         the source of the fragment, with the Pointer field set to zero.

And it failed because the kernel does not send a parameter problem.

I checked that only codes 0, 1, and 2 are defined for the parameter
problem in RFC4443 and header directory.
( https://tools.ietf.org/html/rfc4443#page-12
/include/uapi/linux/icmpv6.h )

And I found that the code for the parameter problem is defined from 0
to 10 on the IANA website.
( https://www.iana.org/assignments/icmpv6-parameters/icmpv6-parameters.xhtm=
l#icmpv6-parameters-codes-5
)


In conclusion my question is as follows.
Why are the codes on IANA not implemented? Is it under discussion?
If it's being implemented, can you tell me when it will be completed?

Thank you!

-- Yugeon Kang


=EA=B0=95 =EC=9C=A0 =EA=B1=B4 =EC=82=AC=EC=9B=90

=ED=8E=8C=ED=82=A8=EB=84=A4=ED=8A=B8=EC=9B=8D=EC=8A=A4=E3=88=9C =EA=B0=9C=
=EB=B0=9C1=ED=8C=80

08380 =EC=84=9C=EC=9A=B8=EC=8B=9C =EA=B5=AC=EB=A1=9C=EA=B5=AC =EB=94=94=EC=
=A7=80=ED=84=B8=EB=A1=9C31=EA=B8=B8 20 =EC=97=90=EC=9D=B4=EC=8A=A4=ED=85=8C=
=ED=81=AC=EB=85=B8=ED=83=80=EC=9B=8C 5=EC=B0=A8 405=ED=98=B8

Direct: 070-4263-9937

Mobile: 010-9887-3517

E-mail: yugun819@pumpkinnet.com

Tel: 02-863-9380, Fax: 02-2109-6675

www.pumpkinnet.co.kr
