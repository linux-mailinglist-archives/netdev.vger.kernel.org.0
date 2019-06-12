Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3913421EE
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 12:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437760AbfFLKFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 06:05:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41892 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731837AbfFLKFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 06:05:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id s24so6423070plr.8;
        Wed, 12 Jun 2019 03:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gcDvik9+KpaYGNhLdOFj21bkRuHqN/0qSRW+OLH4t8o=;
        b=HhM7yhZ7ia7xDPhEU1Jv5AWvfd0HzaBZjuY4Oc7cNiazWjv16Aa1UmpMsj9yT+rC2R
         cCuDSTK9xesfChyiZyV9D2yihvd52pNjgjo6vQX0BdoBUEp0ON5mQRguueGM/7Fb6DwI
         zrvjysyFn1N2Gmz+ojP/7pirWleYt5PwmnWc4Zl0CaxGIhBRVWkb2Hq98R2dfmqJhFU2
         cBCcYNlUAiX2CFKHo2zF6RcO2dIrWfjRzRYiZubVgOgOlhC4y/f8jYQdzUFLdYQzI2x/
         LMUjuatuN69pf2dXmPu02dyGXndwyovHUMKLzVOIsWmrriB5thmKkEHdo5/H7E8hH+X2
         HumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gcDvik9+KpaYGNhLdOFj21bkRuHqN/0qSRW+OLH4t8o=;
        b=lON6ufAOVWXUY50LvAfxfBhO9nrmj/+5x9HuKLhR7T7Fwy3bW0QIfsjndnOTdCnm3o
         hWJqwW6OHnvnizWegGua1krNc0OB2S3FxxxK5OBXivpYzRLZwUD0GBMOz3mqY6xYJQtA
         TIpfjscn5gfouYEVvd7q5A4/eepM/SkhEQhy4s/n/rr70EHqXqfvjzMYIoDr1dl5ePmC
         icGLwxMaeGqp9bXa+z6tSSwDFtjOKk5It4i7kqCYl+jYrCw3z0w3/irL8w4OEdHu0zV/
         Ic6Qv2E0Xej6sMU7PPJORLT2t254drEIZWfmhFeblvIdfjj7aD5RPKqYkgSHfoOzEVhU
         SqYg==
X-Gm-Message-State: APjAAAWVXmIPexPMyGIh/OMxpxdswKFfuqwV8XvABv/wt3HUcdqzAKu8
        GY1OOM2mVWaYZEovcqWRhEBEl8eHQE792w==
X-Google-Smtp-Source: APXvYqySl9pxjkn+PTm7IbgW5at2rXe1yZ7PJw+AN8G3EHc+LUA/4hmQDPSHZpW778MQr27Lxx2ydg==
X-Received: by 2002:a17:902:2926:: with SMTP id g35mr35288254plb.269.1560333903409;
        Wed, 12 Jun 2019 03:05:03 -0700 (PDT)
Received: from jhedberg-mac01.fi.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id p2sm14958413pfb.118.2019.06.12.03.04.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 03:05:02 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] Revert "Bluetooth: Align minimum encryption key size for
 LE and BR/EDR connections"
From:   Johan Hedberg <johan.hedberg@gmail.com>
In-Reply-To: <9ad95905975e09646f0f2aa967140881cbbe3477.camel@hadess.net>
Date:   Wed, 12 Jun 2019 13:04:57 +0300
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <77E07614-6F68-4661-BC6D-2BD610DBD62A@gmail.com>
References: <20190522052002.10411-1-anarsoul@gmail.com>
 <6BD1D3F7-E2F2-4B2D-9479-06E27049133C@holtmann.org>
 <7B7F362B-6C8B-4112-8772-FB6BC708ABF5@holtmann.org>
 <CA+E=qVfopSA90vG2Kkh+XzdYdNn=M-hJN_AptW=R+B5v3HB9eA@mail.gmail.com>
 <CA+E=qVdLOS9smt-nBxg9Lon0iTZr87kONSp-XPKj9tqB4bvnqw@mail.gmail.com>
 <723142BB-8217-4A01-A2B9-F527174FDC0F@holtmann.org>
 <20190612070701.GA13320@kroah.com>
 <9ad95905975e09646f0f2aa967140881cbbe3477.camel@hadess.net>
To:     Bastien Nocera <hadess@hadess.net>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12 Jun 2019, at 12.38, Bastien Nocera <hadess@hadess.net> wrote:
>=20
> On Wed, 2019-06-12 at 09:07 +0200, Greg Kroah-Hartman wrote:
>> On Tue, Jun 11, 2019 at 11:36:26PM +0200, Marcel Holtmann wrote:
>>> Hi Vasily,
>>>=20
>>>> Can we get this revert merged into stable branches? Bluetooth HID
>>>> has
>>>> been broken for many devices for quite a while now and RFC patch
>>>> that
>>>> fixes the breakage hasn't seen any movement for almost a month.
>>>=20
>>> lets send the RFC patch upstream since it got enough feedback that
>>> it fixes the issue.
>>=20
>> According to Hans, the workaround did not work.
>=20
> Is it possible that those folks were running Fedora, and using a
> version of bluetoothd without a fix for using dbus-broker as the D-Bus
> daemon implementation?
>=20
> I backported the fix in an update last week:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1711594

I don=E2=80=99t know if that=E2=80=99s the case, but at least based on =
the comment here:

https://bugzilla.kernel.org/show_bug.cgi?id=3D203643#c10

it looks like there=E2=80=99s still a race with controllers that do =
support reading the encryption key size. The peer device may send an =
L2CAP Connect Request before we=E2=80=99ve completed reading the key =
size, in which case we=E2=80=99d still reject the request. For making =
this work again I=E2=80=99m not aware of any other quick solution than a =
revert.

Johan

