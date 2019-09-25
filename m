Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76467BE265
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388476AbfIYQVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 12:21:47 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:36363 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfIYQVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 12:21:47 -0400
Received: by mail-io1-f47.google.com with SMTP id b136so343405iof.3
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 09:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2rn/VVwWndnSNHVbXXMHSAu7KE/WJIUrvB31OVKOF+g=;
        b=gmK24dpzNEKyjBF5McAR1hTZmRCfdES+ZzLXyRaSxqzAAgw4pGR/DhjaK4yaPsKN4d
         0i9IG7fcDZ3egvaIbQwfnx0P06889rYZpqDlUw4B8q6jMx6/DfY2rVtrOrZW8T3uC3Zf
         VMoyzy1ZdBIhvo0QeVP02Gxm7dOLflDQYxYLsl+H3BCtlWAj+uGQT6YLp7ruYWDk6lgN
         k25Fd0Q+ZDH5/ehNKlczjjNqfvCGNe8r/LCTeywtCo2BBadshpj0kRVRKKUxjY5t3pho
         ABqHXSnHszarpS9bmBTOS4dTzSDWjhxibHAf26owhTD9CauS7qZxb7c5QPzEWv8Y7p++
         jcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2rn/VVwWndnSNHVbXXMHSAu7KE/WJIUrvB31OVKOF+g=;
        b=c19pBCvLLC0HrtrNVvlmE0MHgtt7fVTqaniz+7VLXAygdOdH1cz/5eVkcS+6SbxpEn
         W2BZybkErB2t0FmTwZ01U08XCd/8v8Gmw+YLUmqo6wx/Oh5fHGJL4eqVDc8Mkxvf9PZs
         wRNq1nPZOxFf5pDgf8ztdXU6lpjoBkkVfyxJTeyHnqNNJfTGZnpCcfMhad8OprVXLN9D
         9rUWnd+sVxcfeh4VToVIH99O7iObGzJpUfp7Njy/L9jjDOqpH08Y2NiTakN/M2NnA+Uo
         cfTYqWNuJbwn8NiqrAiIeBHR3wxvYpPDc9pchMr/B9yu1raBxx2f9yxvFX0lPmaYdcba
         jLrA==
X-Gm-Message-State: APjAAAXybRImMqtqP8WkT//sLO49VeLYQAzQP0hCw3h+khHPz1J1WLIO
        +ZpOrCrU8hB6ktD3+ARGPzRmyd8G7mIOr/4+tL/ATw==
X-Google-Smtp-Source: APXvYqz4VHkiDCb92GKHh6cV7SRnjfkuVzz082xZEL1/p3jKeGkMq7lR+mHtJ96AaRv6mBFLQPAJZRhCv8nTUoCQuA4=
X-Received: by 2002:a02:634c:: with SMTP id j73mr5916623jac.99.1569428505816;
 Wed, 25 Sep 2019 09:21:45 -0700 (PDT)
MIME-Version: 1.0
References: <CACwWb3BE7msW6=XADuG2Di4xYnoJq5qScc4Wsu4xOS=ycYPDww@mail.gmail.com>
In-Reply-To: <CACwWb3BE7msW6=XADuG2Di4xYnoJq5qScc4Wsu4xOS=ycYPDww@mail.gmail.com>
From:   =?UTF-8?B?5ZCJ6Jek6Iux5piO?= <hideaki.yoshifuji@miraclelinux.com>
Date:   Thu, 26 Sep 2019 01:21:09 +0900
Message-ID: <CAPA1RqCKr4TnqEGrn2Og2QmH94eNnAnRFBge3gtsM1XiQAYM-A@mail.gmail.com>
Subject: Re: IPv6 issue
To:     Levente <leventelist@gmail.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?5ZCJ6Jek6Iux5piO?= <hideaki.yoshifuji@miraclelinux.com>,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


2019=E5=B9=B49=E6=9C=8826=E6=97=A5(=E6=9C=A8) 0:25 Levente <leventelist@gma=
il.com>:
>
> Dear all,
>
>
> I don't know if this is the right place to ask, so please be gentle.
>
> I have a router running OpenWRT, and it fails the some test cases
> defined by the IPv6 forum.
>
> https://www.ipv6ready.org/docs/Core_Conformance_Latest.pdf
>
> It fails 1.2.3 / 1.2.4 / 1.2.5 / 1.2.8 test cases.
>
> My question is if there's any particular settings (either compile or
> running time) in the kernel that affects the outcome of these test
> cases?

You should look into the result in detail; how it fails.

>
> Other question is that is there any open source test program to test
> the kernel's IPv6 stack against this test specifications?
>

You could find some "Self Test" suites:
https://www.ipv6ready.org/?page=3Ddocuments&tag=3Dipv6-core-protocols

--yoshfuji

>
> Thanks,
> Levente
