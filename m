Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248051134EC
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfLDS1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:27:10 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38556 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbfLDS1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:27:08 -0500
Received: by mail-qt1-f193.google.com with SMTP id 14so755859qtf.5;
        Wed, 04 Dec 2019 10:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=rRv+rhzCfuGo++iU2PWMbxJtQJH0iLaP0UrU4w3CxNE=;
        b=Ac1tXdmsBCtajajEJA4vlvGErEJ0vRZ6ndVyEEaMDrDdGqhrfVzLnzbdSwpV0eO2D1
         v/KYC8iohhIlOxuJz2YVC2fBGWOmEXvK6CzjOcEeqscDHUiaji4shP9NfBBBy6uJDExt
         UJhwwXdTIauV9neI//48hcMI49IIpntEcHzPTH4mkoQzFn7JEL93Q72pFAJn9/h1IBjj
         LGesVGxiJLArzH9/AfeN6pQBb+yNAkA9ZI7X3ti4HkE6NVdIaudOv/5r+pf81Ui9SjUW
         wUlwDCAzXQstSBePCPFMo20y2cg5uJBnRDs5TP0wTcPA6M9u7L3RJiH6uQl0ZLzvbS9T
         Qqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=rRv+rhzCfuGo++iU2PWMbxJtQJH0iLaP0UrU4w3CxNE=;
        b=rWY5H9om4L2pZA3XLiLa4Zh0Vt/3VQ7+sZb2AqVBG/mPNXjOZEhcacf+RpxLN72CpI
         wxZJbOKzYe7QesZOWyHGjbc/bYXArgTeeEprQCrMR5/pIXpze9cYSa13G6DeU/Lnyi5b
         MbISJgA3U8OOtOxCofotZC0upt8vtIarYF8W96/vrAv/qfY9QEsiGCbTqsNV+evaK0Uz
         hHoQKLLaFno5iqQpUs6HjHI2OvPP9flyPAn/CGa3hKb0BKHgU41wxvvJkxszQf52XwFY
         OmW7cCHJq7tOp0zkW7mYcmosRrqno4Oc6e5dm9yzxnKef30Vypnm1/1A5C3K7ADuTXn0
         IBqA==
X-Gm-Message-State: APjAAAWjuLF1Y64lRtHkmdbJlrQuuWFh+EDnGkOYZyMfAxMbTnY6tPv0
        wSfJSEcJe5poKYKxljvn6dA=
X-Google-Smtp-Source: APXvYqwvOr5+lvRpVjUWa75G4U3wtt6BZ7VAdjo63IVeH/Hs3f6PYd9m2mq3+4pXf30bM7guaM5mXQ==
X-Received: by 2002:ac8:22c4:: with SMTP id g4mr4076060qta.45.1575484026971;
        Wed, 04 Dec 2019 10:27:06 -0800 (PST)
Received: from localhost.localdomain ([177.220.176.179])
        by smtp.gmail.com with ESMTPSA id c6sm4086905qka.111.2019.12.04.10.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:27:05 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 24F79C39A2; Wed,  4 Dec 2019 15:27:03 -0300 (-03)
Date:   Wed, 4 Dec 2019 15:27:03 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-ID: <20191204182703.GA5057@localhost.localdomain>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191127131407.GA377783@localhost.localdomain>
 <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
 <20191127230001.GO388551@localhost.localdomain>
 <CAHo-OowLw93a8P=RR=2jXQS92d118L3bNmBrUfPSBP4CDq_Ctg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OowLw93a8P=RR=2jXQS92d118L3bNmBrUfPSBP4CDq_Ctg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 29, 2019 at 09:00:19PM +0100, Maciej Żenczykowski wrote:
...
> I'm of the opinion that SELinux and other security policy modules
> should be reserved for things related to system wide security policy.
> Not for things that are more along the lines of 'functionality'.

Makes sense.

> 
> Also selinux has 'permissive' mode which causes the system to ignore
> all selinux access controls (in favour of just logging) and this is
> what is commonly used during development (because it's such a pain to
> work with).

Agree, this would be a big problem.
IOW, "you don't have permission to access to this" != "you just can't use this, no
matter what"

FWIW, I rest my case :-)

Thanks,
Marcelo
