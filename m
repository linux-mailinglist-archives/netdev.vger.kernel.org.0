Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68169424C4D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 05:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhJGDx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 23:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhJGDx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 23:53:56 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D9FC061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 20:52:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 66so4363064pgc.9
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 20:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=jUwSNrbRqeZ2+wz9gNAx3uczGeWWOtNLeT0B6K0atA0=;
        b=Mb9f4S/meQ2pfM4+bgK4U45+qLwEh81pvCL4c8eonYARO0fTZKkjC7q1K92opeiYIN
         ZWhkfU+LXYg8QeV4VAYopdPcjYRCDhouYsinO4WAQ1/LKQ4j8PXMZSRvxw+KxZr1Uges
         JsiNjnjnq1kId9AV8yj0KNpMhdJnnFNjWu6D8lNm4t+KnoVsOPMOrMBTlQQps1x+fqnp
         2kLut/BphIhylxmmI+1K4vvZPB+bCHEZu5TXM9JvNyKjLeteaWET4g0HKxfMOq2YIb5m
         QcBfHc/6iQOC11wAW+K9H0SdVjUumvoTYInWKh33XFUV9mUGKXqNFuQLu4SklG4zlGnZ
         OkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=jUwSNrbRqeZ2+wz9gNAx3uczGeWWOtNLeT0B6K0atA0=;
        b=yZcLZFxJmjZPjT+CCysBhJudyoqFJXljl5gMRIxKY697dXT/d50ZMG1quKdWFetn9F
         swI7hBjOeo1XgSnm4NeTlGMzrhTkvC2C+9bJX3TyNHGAGNmBS7CrJP2mC0nc4xlFdjDA
         NG2Q7YNUa+FmKoIWu0UMyHWMWTVZ7qohZc6Wr/quQosxT4LaevF1zD/8Gb8I4aKsue8x
         g9YKOw69mXX86aSY0JtUnZXG4YrTtGuPwVjU0+iTlBUo+Z4hwejRxFxan8of/Pe/h9Hn
         dRh7N58sod4HvoPSZQj2VbLA78LWCeXlYehJBKjqPS+GacUzIp3pmw+ULU5GunTQvKu+
         FlKA==
X-Gm-Message-State: AOAM533BkoZQtOAc0DbBiTE+J6Mynoy+44W6uR4qkahAzjmo+a/Cp7Qp
        1HC7juVqPdfmKOV66dLPNRuftsHqVT098XXc9YU=
X-Google-Smtp-Source: ABdhPJzfkS18NoZKEY4Jcn9TkUXKvaD+iTatlhW4VD8pzrt6y3zsmORayiOrFZ2wKkorsEIPNOw1MVm1RPmS4Wf8ZlY=
X-Received: by 2002:aa7:9a11:0:b0:449:58bc:452e with SMTP id
 w17-20020aa79a11000000b0044958bc452emr2049445pfj.17.1633578722482; Wed, 06
 Oct 2021 20:52:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:114:b0:59:f7ca:8188 with HTTP; Wed, 6 Oct 2021
 20:52:01 -0700 (PDT)
Reply-To: compaorekone34@gmail.com
From:   "kone.compaore" <abbttnb001@gmail.com>
Date:   Wed, 6 Oct 2021 20:52:01 -0700
Message-ID: <CA+d4EbOKgpqVU7A6iVX3W3TRBzQ8bPJDLP=28OrT3sYbvekNwg@mail.gmail.com>
Subject: Greetings from kone
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings to you and your family.

My name is Mr. Kone Compaore, the auditing general with the bank,
Africa Develop bank (ADB) Ouagadougou, Burkina Faso, in West Africa. I
am contacting you to seek our honesty and sincere cooperation in
confidential manner to transfer the sum of 10.5 (Ten million five
hundred thousand Dollars) to your existing or new bank account.

This money belongs to one of our bank client, a Libyan oil exporter
who was working with the former Libyan government; I learn t that he
was killed by the revolutionary forces since October 2011. Our bank is
planning to transfer this entire fund into the government public
treasury as unclaimed fund if nobody comes to claim the money from our
bank after four years without account activities .

We did not know each other before, but due to the fact that the
deceased is a foreigner, the bank will welcome any claim from a
foreigner without any suspect, that is why I decided to look for
someone whim I can trust to come and claim the fund from our bank.

I will endorse your name in the deceased client file here in my office
which will indicate to that the deceased is your legal joint account
business partner or family member next of kin to the deceased and
officially the bank will transfer the fund to your bank account within
seven working days in accordance to our banking inheritance rules and
fund claim regulation.

I will share 40% for you and 60% for me after the fund is transferred
to your bank account, we need to act fast to complete this transaction
within seven days. I will come to your country to collect my share
after the fund is transferred to your bank account in your country. I
hope that you will not disappoint me after the fund is transferred to
your bank account in your country.

Waiting for your urgent response today
Yours sincerely
Kone Compaore
