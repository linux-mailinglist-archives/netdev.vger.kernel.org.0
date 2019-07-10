Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F4564DE6
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 23:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfGJVII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 17:08:08 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35980 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJVII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 17:08:08 -0400
Received: by mail-io1-f67.google.com with SMTP id o9so7893847iom.3
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 14:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=du44lOkZXSPVZPvCuF1A186RHUbR5cXy7LGNeFOhLbA=;
        b=jfMQpMMOWUlBMTJiv1x5cHvljNWEBV2RugttRQ6XLdmzSAnPB6+aC5dtoMzxyBABQ1
         TblWantHcdl7RUiAuOS1ciaOvPh6Hi6PMJbn1mGSQML9EhKR4zoDEOd/f2MT5CNWwbYL
         ttT2CX3EuGQR2xTFko7Rzz3adU43ph7MSNuogHwaVTXfnOozieKMdF6qESMC/ZI/2Rh/
         tywYyahVHvN6Q3yhUqvZy7QYA14lEfZFHxy/o8H9RFgEH5WfrBT80A10dKQRDjA+icdi
         2Zlhik5rwtHKr+C8sSlIf65+3av96YO9b4jre5spEbfA9diKJ1LYklRqYHdtuzjAgWmF
         caBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=du44lOkZXSPVZPvCuF1A186RHUbR5cXy7LGNeFOhLbA=;
        b=T+1umDP2xKyEshROSnE7ADm/HrSxtcXLZSBhRaaSUxId+9yyEmLR1NWukUAqaFdXh5
         zkv/lV9TDu9fr4de35HBUUTn2ni95MZbFJuMc7gjngyossKrd9VaYuoLWoCyeNGZRk2H
         jlr4KV+52HiRjlE392fCPERrogcYZbLQ5lEAUZ0Ll+OVObVBvlQe/NrKBr09yYKBLsjM
         2nWvqUuL4NevyuFhgKw7kfLaX3IMBLCvoEfRBH1tYPofbFszRCfa3zeYqwD2+t5vuoxb
         4/RZajErVuI4VbZyOwrk67SnGPXbgRciGlLKUqSN69lBwaN21FWJVXRGkxkgprKuOb/w
         YRKw==
X-Gm-Message-State: APjAAAU1nKAekzbc8h1XZM3TcJnHEb7ytwFqguhyzB5M/k42Ja641elS
        lDDGaoycsV0YpApLBu5YgWM=
X-Google-Smtp-Source: APXvYqyWKR7Zr8PaSxpuSR+amrKh9ykeiO3fKC59n6eNmObo3eZirk8e32PdSWViBPuu361c0/samA==
X-Received: by 2002:a5d:9858:: with SMTP id p24mr100161ios.171.1562792887436;
        Wed, 10 Jul 2019 14:08:07 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:3913:d4da:8ed6:bdf3? ([2601:282:800:fd80:3913:d4da:8ed6:bdf3])
        by smtp.googlemail.com with ESMTPSA id r5sm2930620iom.42.2019.07.10.14.08.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 14:08:06 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/3] add interface to TC MPLS actions
To:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        willemdebruijn.kernel@gmail.com, stephen@networkplumber.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
References: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <15257a97-f710-3192-6a28-8680ed89ee5a@gmail.com>
Date:   Wed, 10 Jul 2019 15:08:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/19 6:40 AM, John Hurley wrote:
> Recent kernel additions to TC allows the manipulation of MPLS headers as
> filter actions.
> 
> The following patchset creates an iproute2 interface to the new actions
> and includes documentation on how to use it.
> 
> v1->v2:
> - change error from print_string() to fprintf(strerr,) (Stephen Hemminger)
> - split long line in explain() message (David Ahern)
> - use _SL_ instead of /n in print message (David Ahern)
> 
> John Hurley (3):
>   lib: add mpls_uc and mpls_mc as link layer protocol names
>   tc: add mpls actions
>   man: update man pages for TC MPLS actions
> 
>  lib/ll_proto.c     |   2 +
>  man/man8/tc-mpls.8 | 156 ++++++++++++++++++++++++++++++
>  tc/Makefile        |   1 +
>  tc/m_mpls.c        | 276 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 435 insertions(+)
>  create mode 100644 man/man8/tc-mpls.8
>  create mode 100644 tc/m_mpls.c
> 

applied to iproute2-next. Thanks

