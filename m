Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87079574F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 08:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfHTG1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 02:27:01 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:33071 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfHTG1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 02:27:01 -0400
Received: by mail-wr1-f43.google.com with SMTP id u16so11073111wrr.0;
        Mon, 19 Aug 2019 23:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gfbR/B8uYiMWQfmRpgyRoErFiH9g7iKs91y2cIUxD6Q=;
        b=hPMuWuslu6rMGkPgZDoNm3pm+hI01GBmbVHwO+qQgAmPthI1bRmLm1V0Y9a+zi5Oef
         SUq73dWHdTYzpUCVh33CXAoDIxfk7ClKAeUQsuNOD0YyiLdxJb8aFrLlQMZVq2K2NPzW
         99QXu6HdUnY9FUHuDxcAj+nxhk1Io/JomB4FLodjPtwGLWjt/e4kevEnn837P8mxXPfs
         2kCK694Eny2mNgk0A5k/8FypWjaQNwoVv2L/YlibjQpvCgoMX4KEvDyvMaKYvAO0rAHo
         aWrWG4vNhgpoc7++i8Sz+H79EURtu2iuZlBWK2SjXLxSfS2PljNBPy3zJn7G3sfhxSGE
         RgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gfbR/B8uYiMWQfmRpgyRoErFiH9g7iKs91y2cIUxD6Q=;
        b=ncbmX8VAUQQ1LcD297zHccJ42hszr4m/NYLrdIWPSekdYY6jc7bttMWtf5yysjbJbL
         lPwQbEQRK0DLrrfmfk1K02nC094KrO6g8/nNXxyea1EtZuY6hshfgSzAOfb0IuOsxEoN
         uc398Fs/A3bpkALBegpckgHpUlSUDB9+hbeiYCj3orEwXS0jSmjm5kDnRnZM9h2QmqQQ
         AZEoY0RUeRSRS/71tx3OgihcG07Grw9LW1dxvBzZeNR+nfhjGLMl7Nx4sPjbRpsCov1I
         TrHNu9KfVAS4oR2jfslyyTAUEAZ8l6w2kYGzkk8DXx+LCx6s6P6zALxEzhIEsq7XbqnF
         iH3Q==
X-Gm-Message-State: APjAAAXmi2hPiutbM+8bZ9gHJm9gYtZsuTW75YamjtcoEnPoQjzgc+ip
        A+wdO7v1yjxgfp87Mn2EdVoPCU3KFgSyVPY4KbeROTAtfzs=
X-Google-Smtp-Source: APXvYqwuzoW15Et6tG0hLUJ07+wWLWRaLUvLcaMMzYcrR5QX9leMIkV+Ltx30cTNODa7ceEHqWbnbLNK6iLMwtLWem4=
X-Received: by 2002:adf:9043:: with SMTP id h61mr24974180wrh.247.1566282418946;
 Mon, 19 Aug 2019 23:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com> <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
In-Reply-To: <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Tue, 20 Aug 2019 11:56:47 +0530
Message-ID: <CAA5aLPh9o4wMAMzC_cQ3YtcYbta72qW9gywL3g=wjWNzVECKfw@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> If your goal is merely having as many classes as you can, then yes.

My goal is not just to make as many classes as possible, but also to
use them to do rate limiting per ip per server. Say, I have a list of
10000 IPs and more than 100 servers. So simply if I want few IPs to
get speed of says 1Mbps per server but others say speed of 2 Mbps per
server. How can I achieve this without having 10000 x 100 classes.
These numbers can be large than this and hence I am looking for a
generic solution to this.

I am using ipset +  iptables to classify and not filters.

Besides, if tc is allowing me to define qdisc (100:) -> classes
(100:1) -> qdisc(1:  2:  3: ) -> classes (1:1,1:2   2:1,2:2    3:1,
3:2   ...) sort of structure (ie like the one shown in ascii tree)
then how should those lowest child classes be actually used or
consumed or where it can be used?
