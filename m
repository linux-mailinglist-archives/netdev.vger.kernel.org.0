Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6C8EC73D
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbfKARJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:09:59 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33298 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbfKARJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:09:59 -0400
Received: by mail-qt1-f193.google.com with SMTP id y39so13818064qty.0
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 10:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TcxCEtLzY6A+szaHB57ic5tU57pS2pv4cxwGH2qfeVM=;
        b=jRtSDhUaKR3WckiTAQmKLACw+YdfBOEnpShBUOZwmR2w6KyhuZhI6kVUeVk9CIm6rB
         upxZvDDEkSwsllPmrqsyX2IHkLZmQR9NmHdwZF9qSEx+eiKv+jJBvFExn8gTuelwOVai
         cvKKxuLlCMqW6bk7Ny0Ltkl6f9DJlrwge1Q4u5hTacioqnheihpPfuqFqG9lQpe6JZgc
         eUZkUJaBKMYc56CXGmYC044/SauNc0DCbnprHwdoGlJgPyD+ZdfUarvcoEtfyPYK3cnR
         nk3ZuDmbJVkzevAUkG3MoS05qO8MQasBjBpIVJ3uH2AISao74GuSNFUquZD41fAFuz/x
         b+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TcxCEtLzY6A+szaHB57ic5tU57pS2pv4cxwGH2qfeVM=;
        b=GOwGYqe1YTsctcS6uIjiyrNiYQ2c8t25bKvlqnin7rRbJvBx5kfjAjdyyrQHwlBXUw
         eHYQp96OtNJl+eMm7Qk8hR+0x/wxaXjsj11q9KXxeQFAFvAapxcpSvOGAWWV24Vn2+Mv
         qz1LBVdZu1oagn97cvewtgld2WBh6RgI1V1RdHk624q2YkT5Qbh7UzTKPgIEYI1yn4L9
         PNsXKtVNAXtGcSrcEW6jDeNHuAtxpxNO4FNjlaiSCQ/1PakxZVHQ6+6OynZ8j2/UDbD+
         d10qP0Lo04d0cvflZDybPjXMZzdscEXn1hEUHPtxVqK/UdOAzo6mMKLpBq2xJNXcV5Eq
         ExiA==
X-Gm-Message-State: APjAAAX8BsI+8VRaeHOdwwtoYFI+rn4oqXlSUBmxayZX37ok2Kg2RbYm
        N65pzjgf9W040+OahP18lEFkIiL86duDwC45okCjxQ==
X-Google-Smtp-Source: APXvYqxPrab2V4RpwvAKocdgr3/6KRC/E5pxq0CGp5eFXUvb7GfDMnQTRGMVJMnNrzZ/t69pOFNNy2gMOIEZrj4Jal8=
X-Received: by 2002:ac8:29c8:: with SMTP id 8mr330444qtt.117.1572628198336;
 Fri, 01 Nov 2019 10:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191101004414.2B2F995C102D@us180.sjc.aristanetworks.com> <2706bf00-c156-a71e-01f8-be64de0dd32f@gmail.com>
In-Reply-To: <2706bf00-c156-a71e-01f8-be64de0dd32f@gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Fri, 1 Nov 2019 10:09:47 -0700
Message-ID: <CA+HUmGiv4DTdt0uRXr7yMsF0RjyZQU7BfrATmj8JatBJ25Eg6A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: icmp: use input address in traceroute
To:     David Ahern <dsahern@gmail.com>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 8:11 PM David Ahern <dsahern@gmail.com> wrote:
>
> Change looks good to me, so for that
> Reviewed-by: David Ahern <dsahern@gmail.com>
>
> In this case and your ipv6 patch you have a set of commands to show this
> problem and verify the fix. Please submit both in a test script under
> tools/testing/selftests/net/. Also, veth pairs is a better way to
> connect namespaces than macvlan on a dummy device. See any of the fib*
> tests in that directory. Those all serve as good templates for a
> traceroute test script.
>

Sure, will do.
Thanks,
Francesco
