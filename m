Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E94719DC30
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 18:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgDCQ4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 12:56:37 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:41772 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgDCQ4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 12:56:37 -0400
Received: by mail-io1-f47.google.com with SMTP id b12so8202097ion.8;
        Fri, 03 Apr 2020 09:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Ts/TLDt3o1jsBo4mFChDcCvNIOmWHbNlVcW2PKR1At8=;
        b=QYI/4dEBMPyxQNyv7fGJB6sghTC/YeoSrrram4B8bXo2uv4Rs9f2wU4EHa99PeQiXI
         Wu+BsFZBktlURPwS7Zacuaz2SVRn4pcRPE3+cF1UVmj/mIz6/sy60k0DU6vQtL5aB9+V
         r/ryTsEvdTrhbfjIyEUHkj/WkYxp5AVNw787+veqeGbxC3M5FnB5sFkAmfMZxY/+iEcE
         YAXgRoO/7JURIjdok3ZwdLiktOfoMR241dJY/leFhvVcSP0l5HWxIuZZHZ9t2GOapjQh
         J3UQ6eFINPXDnNZHEBH03PGaW83wN/cHlzAVjZ9eNLEeJ30J7If7OSO5kEcFkIO9y8lO
         fXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Ts/TLDt3o1jsBo4mFChDcCvNIOmWHbNlVcW2PKR1At8=;
        b=h21Ewa4EOn8nqWtntrytdTQtdCkjyd9JhYsjBgI92gy43CQ7s0xF6tSBJz+0TOcZSg
         M6iMPp6VnFTlgDcfogBKNW7wzNekSgRazDS36OnUZHfndoeZFzcSbgwFLd0xOv7RxBdo
         1yKlb8dtw1UsSo78GTsfWLyHi/GGCsjZ/79OrZ9UWVqj0b20fb1EaU7ocztBfsFTlMEQ
         E4qCSmiw/SmgDjTNiZKj/+vbODkBhXqaIMit/y3kBoK1G6c0BMglHWrYuzLKETvzKzHw
         7stfvX5Y7DwzznYUrjXwNzJfro6ECUjnKPvdSedkLG4r23reVzgpqGB2CZlpTiteNJlc
         5zAg==
X-Gm-Message-State: AGi0Pub8ASvcpERy4iu2FPcyLuTmX8oCV2wqWxhF45nW43LCzZnweLK6
        lRlEEGE1nGCvCAhv8zID5z2DMxLTy21X+6Ro7BaSq67t0sI=
X-Google-Smtp-Source: APiQypJoEtAzbsG8Ug7uFviKpD7eNPsfg43yG1Ayd1X9xRSzKLCwrwrL2geRmPxgWyBsaLr5/NaJ9q1LmUPEimbLsqc=
X-Received: by 2002:a02:716b:: with SMTP id n43mr3822194jaf.97.1585932995835;
 Fri, 03 Apr 2020 09:56:35 -0700 (PDT)
MIME-Version: 1.0
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 3 Apr 2020 09:56:24 -0700
Message-ID: <CAA93jw6cX48oAE=KrYOMUx_jY0zBpPc+Vg-b+7aYa7+7KRsOPA@mail.gmail.com>
Subject: restarting efforts on AQL on intel wifi, at least?
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the AQL patches for the ath10k finally landed in openwrt head, and were lov=
ely:

https://forum.openwrt.org/t/aql-and-the-ath10k-is-lovely/

When I last looked the attempt to get at least some intel wifi chips
working with AQL had stalled out with
a variety of other problems. I've been sitting on a bunch of ax200
chips, and am feeling inspired to tackle those.

Any news on other chips like the ath11k?

--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
