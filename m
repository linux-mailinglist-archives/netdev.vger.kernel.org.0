Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E00E1FEEAB
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgFRJay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 05:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728819AbgFRJax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 05:30:53 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEE2C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 02:30:53 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id fc4so2450075qvb.1
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 02:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pumpkinnet-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=LedYRrb0C2slcDatyr7KvhC9s9aUbf+92ltI8cL/D7Q=;
        b=C6bJZl+JzLyv762KCHKpX3jzm0np2UR+30ctZJQYNI9Gvso+6pZ6FUBdp6LGhrRcob
         iw7hsfZjURDGRPhWayzh/XpmgQ3SWsP0fFUB5K/fBdc6G44do4nb0AVaRwl7dYod0Cbj
         DNHwSWyR6d+J396H8Di1OcC4X6cmfbgMxEnWGpw9spX0U5BT8p1q3W+TAQ9rUx2XrnE3
         enLDI22SJMBLofYZQHKbjEFAZuJx7JILcQeyy2XNV4qEaMsjgKYK8BPUADHIkIzIayK0
         75V//9yLMXLoM70lmlrGbORpC06XnieLR7NUOePPDQLp22siRVaFwQEN1dLbXbq/F0Vs
         Oq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=LedYRrb0C2slcDatyr7KvhC9s9aUbf+92ltI8cL/D7Q=;
        b=YWYKuY3qQCfrPrUWEp2ZY6Nes6HjrCDLsv579CqxqBmmGzLm07Cv0KoW0GmOtBszcP
         jo35T0PNslzIA6ZxIDSLc8kLr/KHX5yg9wUpLK56D5Hww2gIVYB5CDqLkc8XSNRmAk1S
         wHqYCoDRrK+hzd4kHNsFuDnVEQFZr6nac4a61OstJ4oHo0ucHP00wRhzS3BobAML3OtK
         1cOzP7wa2+H+2QkcZf29BjBP+lXBUx9GxQT9eARv6jdEpETOReXnQKFxrT9a92TmiAbH
         0FC2JvZmTJz9Du5wTOFqtTBikUZGA2oYaHF8pzueVtH11D3jf9HFoJK//oAg9Evsr1N1
         nXGg==
X-Gm-Message-State: AOAM532Nc50plDjapbw+xBMY0f9eC58LNOTOqxiBi84i1vu+xgiOMU8i
        lV26OY3VKqlKyVdzGG6Wf3CVqvvw7p1qFBsJIr0r5w==
X-Google-Smtp-Source: ABdhPJxUiguLw5oWAIWKbW4k75qrZvQbq52G/2cGJe6+URnSUBTEViph3YAm7+OGNXXyzNUuPGDdUkMxikp8n/8h5l8=
X-Received: by 2002:ad4:590d:: with SMTP id ez13mr2835593qvb.177.1592472652394;
 Thu, 18 Jun 2020 02:30:52 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?6rCV7Jyg6rG0?= <yugun819@pumpkinnet.com>
Date:   Thu, 18 Jun 2020 18:30:00 +0900
Message-ID: <CALMTMJLgfJaBM1N=NUG6NfJwtWDEfANnqKmbMdKP+a27Zf=RYw@mail.gmail.com>
Subject: Question about ICMPv6 parameter problem code more than 3
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?B?6rmA7KO87Jew?= <joykim@pumpkinnet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

I'm testing linux kernels to get ipv6ready logo certificate.

Some test cases require that node send parameter problem with code 3
("IPv6 First Fragment has incomplete IPv6 Header Chain" referred from IANA)

I found that parameter problem codes are defined only from 0 to 2 in
the Linux kernel.

So my question is as follows

Why are the codes on IANA not implemented? Is it under discussion?
If it's being implemented, can you tell me when it will be completed?

Thank you!

- Yugeon Kang


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
