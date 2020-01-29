Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE514D14C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 20:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgA2TnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 14:43:04 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40089 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbgA2TnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 14:43:04 -0500
Received: by mail-lj1-f195.google.com with SMTP id n18so662180ljo.7
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 11:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E0EZyoS/3ZVFNKf5OpzTDCl696I7Q5Ua1W/UsyB4vc4=;
        b=SrDLlp+9KTbulMwqm+ZHq4unesxbaoVmQLamNY4Ub7v4WdOsJeU6vOmhVWMpMXLvlR
         PmjC8hY2HN9D6Ap3/etUdMHMPpUcN9Vo9gRRoIriCeNpYK3oiyDn5v/Q5rj1LupUyrmS
         VvwfumYbOMMY38P8JIdrCj9k7L3NRwv4xxV2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0EZyoS/3ZVFNKf5OpzTDCl696I7Q5Ua1W/UsyB4vc4=;
        b=DlJtrTZB3p9TckNzLkZJEugns4LFs0x4UyNqZQkNWlbWmwCA96y7fC4Q6vPBNUSA1v
         94s2LIMSwHcq1VaeM9uq557g7X0rhG4ZzT+nBKs3NM9efXGUU5JlxiBOQkmZeS+gCDfR
         6PxcFoAdzyTJ27x8FXEVuiwfilHDXt2IPl005TlR3T2XIfUqpc3sTGMbAzR5mn2dcP8D
         xwTlmrQHkC+Ze5gzGgSIdTzekMO47tKjOF+J32ASLn39RlxFnvrtaDkpCjubqaQbFMd3
         m3RRRxSQvfiisdnZ+cQOJYA309yhzRCt587PcV64kL7LhdUozAhCa8BxgcxkBTraqDmb
         nmmA==
X-Gm-Message-State: APjAAAXCE47qHHDDBir8jIv5Jkht5TMj3/Ms78xwInwceIbQo9MPwQO/
        ADmgCU+8bn/T2kTRFXF5hW39ML4Qf+c=
X-Google-Smtp-Source: APXvYqwMIPcnNbmAgsx/DZEkNrFITJEfDfiKBuYO5Z7F9ohNNnxgDGyZzoIw7Zpnp5h8p6TkO/yYOw==
X-Received: by 2002:a2e:b4af:: with SMTP id q15mr432639ljm.43.1580326981546;
        Wed, 29 Jan 2020 11:43:01 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id t27sm1522378ljd.26.2020.01.29.11.43.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 11:43:00 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id n18so662074ljo.7
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 11:43:00 -0800 (PST)
X-Received: by 2002:a2e:580c:: with SMTP id m12mr477334ljb.150.1580326980237;
 Wed, 29 Jan 2020 11:43:00 -0800 (PST)
MIME-Version: 1.0
References: <20200128.172544.1405211638887784147.davem@davemloft.net>
In-Reply-To: <20200128.172544.1405211638887784147.davem@davemloft.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 29 Jan 2020 11:42:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wizYS9W=N2S9b0F2XdMPFTx4MKk6iWjo8yq1aMfYaoZ2w@mail.gmail.com>
Message-ID: <CAHk-=wizYS9W=N2S9b0F2XdMPFTx4MKk6iWjo8yq1aMfYaoZ2w@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 8:26 AM David Miller <davem@davemloft.net> wrote:
>
> 12) Add initial support for MPTCP protocol, from Christoph Paasch,
>     Matthieu Baerts, Florian Westphal, Peter Krystad, and many
>     others.

Hmm. This adds a MPTCP_HMAC_TEST config variable, and while it is
"default n" (which is redundant - 'n' is the default anyway), it
should likely instead be "depends on MPTCP".

Because right now, if you say no to MPTCP, it will _still_ ask you
about MPTCP_HMAC_TEST, which makes no sense. Even if you were to say
'y', there won't be any tests done since MPTCP isn't built at all.

                    Linus
