Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB334366C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 02:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhCVBuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 21:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhCVBuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 21:50:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C30C061762
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 18:50:09 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k4so5718805plk.5
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 18:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4N5iSBFjWW4IwfSgbBTNhfABBEEfgzLUe825NXh35+g=;
        b=gN1OaKEvyi/hL2hN7DJZDE9vvO+o/be0Q0Nyoa01tOaHn37OmqjDRqU/krpzms4rU2
         nYxuvAVbAi0mm8JDby8cbg8+9qhB3hMpf6EUpb74YRNH75HW3ivF9lx48fnjPIWjTKDs
         kIPuwUAfyfL4scOuz91KgswNpEIkbJ2llpiMjdsb1kvnMtuPR+rbt/5/nm2kUVnBrN0D
         yzJ+LKvUXLh/QJShRcLcPUXLwmqMNqiRv3GuBGfYFPZc7Uh3CD76ll6ojLhG/l7md74l
         tcLJ6e03+LsIV0UEn5Gk3V5n9+60UxexbosjFhFyUnpdbEY/SJLk4r2RgKz1Ueki0sKS
         7u7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4N5iSBFjWW4IwfSgbBTNhfABBEEfgzLUe825NXh35+g=;
        b=EbJoxQrpTJoHH1PRcwl6LpXf/XKNAIoY7rXXpHToDFlFC7FLxDUA5QGk8tj41DS3Wc
         1xbbyRj8wvqTd5u6HYCsB7mOW8zqaek1x/5t91MX5BM+uY5RwjFLH7JwYoxzXOLkdoWj
         Yzl/9JVGVuq3lBCfY+q5FiOT2xbyxw3KqpFTQr0dAjs1h02qgupt68yDVUJ6WcfrBxjp
         V/jP3wDCGHFtyLYEZKP3fSUfZqq3xwb5/jqYkCJg6EX0Dq0ypQanA7APn43oY3XTONEc
         bcFZr3LBUV5YabeSKNN1GmqJlHsipFA5Irpecfz8Qr1HPfUpMZzsW5yAqsICVMOVKixd
         fCUQ==
X-Gm-Message-State: AOAM531B86LbGdEtG6++vMGlv6Nm4A2+yfck8O1oUqOnbibbpXuX93tv
        p1+7avCV+amvJBVejE3Sc6w=
X-Google-Smtp-Source: ABdhPJwwM31YLCerygPs5JsmmkTIzBFOPSebe5ErGUcI90MH2RPrBMHN5TUZWyBChOq2lmbxMJZkVw==
X-Received: by 2002:a17:902:e74e:b029:e5:bde4:2b80 with SMTP id p14-20020a170902e74eb02900e5bde42b80mr24793754plf.44.1616377809155;
        Sun, 21 Mar 2021 18:50:09 -0700 (PDT)
Received: from ?IPv6:2600:8801:130a:ce00:74c5:98b:a531:12d5? ([2600:8801:130a:ce00:74c5:98b:a531:12d5])
        by smtp.gmail.com with ESMTPSA id w23sm3922992pgm.64.2021.03.21.18.50.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Mar 2021 18:50:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: rfc5837 and rfc8335
From:   Ishaan Gandhi <ishaangandhi@gmail.com>
In-Reply-To: <a41352e8-6845-1031-98ab-6a8c62e44884@gmail.com>
Date:   Sun, 21 Mar 2021 18:50:06 -0700
Cc:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        junipeross20@cs.hmc.edu
Content-Transfer-Encoding: quoted-printable
Message-Id: <5A3D866B-F2BF-4E30-9C2E-4C8A2CFABDF2@gmail.com>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
 <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
 <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
 <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com>
 <a41352e8-6845-1031-98ab-6a8c62e44884@gmail.com>
To:     David Ahern <dsahern@gmail.com>, Ron Bonica <rbonica@juniper.net>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What is the motivation for adding support for these RFCs? Is the push
> from a company or academia (e.g., a CS project)?

Yes, these patches (RFC 8335 and 5837) were produced as a result of a
collaboration between Juniper Networks and Harvey Mudd College.

Let me loop in our advisor, Zach Dodds, and Juniper Networks engineer
Ron Bonica. I believe Ron has more context on the potential usage and
existing support for these two features.

> On Mar 20, 2021, at 1:35 PM, David Ahern <dsahern@gmail.com> wrote:
>=20
> On 3/19/21 10:24 PM, David Ahern wrote:
>> At the end of the day, what is the value of this feature vs the other
>> ICMP probing set?
>=20
> Merging the conversations about both of these RFCs since my comments =
and
> questions are the same for both.
>=20
> What is the motivation for adding support for these RFCs? Is the push
> from a company or academia (e.g., a CS project)?
>=20
> Realistically, who is expected to use this feature and why given the
> information it leaks about the networking configuration of the node. =
Why
> is this tool expected to be more useful than a network operator using
> existing protocols like lldp, collecting that data across nodes and
> analyzing, or using tools like suzieq[1]?
>=20
> RFC 5837 has been out for 11 years. Do any operating systems support =
it
> =E2=80=94 e.g., networking vendors like Cisco, Juniper, etc.? If not, =
why not?
> This one seems to me the most dubious at this point in time.
>=20
> Similarly for RFC 8335, what is the current support for it?
>=20
> Linux does not need to support an RFC just because it exists. I am
> really questioning the value of both of them
>=20
> [1] https://github.com/netenglabs/suzieq

