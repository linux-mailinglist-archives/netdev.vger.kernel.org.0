Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46EE2193537
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 02:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgCZBVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 21:21:20 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38525 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbgCZBVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 21:21:20 -0400
Received: by mail-ed1-f66.google.com with SMTP id e5so5042781edq.5
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 18:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=13Twtrlp2dqGIuRVL4M357jiT/a8hCEy39HcluUM67M=;
        b=LYIAJLDPMR/Dd7T/GxLYQvrUa6d8R994z/QwzTIjMiYZzzeSu8QGxLOd0Ti+5zoTg5
         6wveR/6cxB3e8oTZtaUniuoZgFdEtaUGK5VCI5UpyFYzFxsjb9R5Q++9YqTau+T5wgsI
         MQgEz0m5OxM+fcO07O2qZGtIbccEntF46RpJE7HTGsztpf7z943OcMdlnnyBEqpYmFM1
         lhd18zm52ogmm3O2ceLcPxKa9Yy1v2r7xm+wjGISL8wUBslLY7M9nlwZzH1mw/Es0JNr
         4aP7I85Jez01Y8g925PHo///Qh1WdIPSjPtoVyyEDid8Am0cyaS7BGEQqzVl2WeR1R6M
         L6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=13Twtrlp2dqGIuRVL4M357jiT/a8hCEy39HcluUM67M=;
        b=GYcNuPRmSaHn4M+FDNC/o9Vcp8W1vydnm/y/u26P3AR71a1FyRB258Tf8FbdSQCTEH
         OMTDDZd0mIfi+7/TbWz6v2vo0Uzomg+tqL72IORCZXh0z41xZ+OHhIm6pSha4fWPp9M+
         0qje7Kcopg/nmUD5hIB4SuRSrHfVHA7jB0Cq5wAc8P5jx+0ZwdlnDG9aC3HZSptN5I0b
         jo5t7INDSQO2YrLfupYn7ONi9gZ8qf5ZDhJlolQO1ood+cK+6CVQVMb+u1iOWjyneL7W
         tkS6mGCd1V/ZxMxGNuqAm5I3il7eHrEUd/gxbA58Pu+7zJmHuLiaAjh5hL1ic+STN3iv
         U7+Q==
X-Gm-Message-State: ANhLgQ32sMncdPhnMfaTjSVGpFSGoNCaq60CXZami8dj9S/zDxJQub0C
        Yc/vA1I5aFQTBiFz3javvsQpD8vH75Vq3PDBq48=
X-Google-Smtp-Source: ADFU+vt7SH/E698lSuaoRa8zVelIhpj6rCAAohmAl/4+xHHoVnmN4fcyt4Ie0Kuep+28XK7qJF3BOhzGmB77RSNTFkA=
X-Received: by 2002:a05:6402:1a5a:: with SMTP id bf26mr5767377edb.42.1585185679113;
 Wed, 25 Mar 2020 18:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <2786b9598d534abf1f3d11357fa9b5f5@sslemail.net>
 <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com> <25b83b5245104a30977b042a886aa674@inspur.com>
In-Reply-To: <25b83b5245104a30977b042a886aa674@inspur.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 25 Mar 2020 21:20:41 -0400
Message-ID: <CAF=yD-LAWc0POejfaB_xRW97BoVdLd6s6kjATyjDFBoK1aP-9Q@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5Bvger=2Ekernel=2Eorg=E4=BB=A3=E5=8F=91=5DRe=3A_=5BPATCH_net=2Dnext=5D_net=2F?=
        =?UTF-8?Q?packet=3A_fix_TPACKET=5FV3_performance_issue_in_case_of_TSO?=
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>
Cc:     "yang_y_yi@163.com" <yang_y_yi@163.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "u9012063@gmail.com" <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 8:45 PM Yi Yang (=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=
=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 <yangyi01@inspur.com> wrote:
>
> By the way, even if we used hrtimer, it can't ensure so high performance =
improvement, the reason is every frame has different size, you can't know h=
ow many microseconds one frame will be available, early timer firing will b=
e an unnecessary waste, late timer firing will reduce performance, so I sti=
ll think the way this patch used is best so far.
>

The key differentiating feature of TPACKET_V3 is the use of blocks to
efficiently pack packets and amortize wake ups.

If you want immediate notification for every packet, why not just use
TPACKET_V2?
