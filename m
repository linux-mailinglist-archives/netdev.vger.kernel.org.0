Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D59C31FD
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbfJALGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18557 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbfJALGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 07:06:40 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DCE35356C9
        for <netdev@vger.kernel.org>; Tue,  1 Oct 2019 11:06:39 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id m22so4004847ljj.6
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 04:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Jn4upI5f6HuItoKVOb27JfzYu4wZjs3UOtU+UupwVkQ=;
        b=kXP3WVYuoDd3Ez1mCJvhhcSG3RrwbdG71Ad3oDM6ih7bim+hz3ozWEH/35PQockLEU
         bVvdn4GsI0jh9CpT23vi0jSR7cpR0UZgdR9iIOmWdG4P7VYwPOU6jK5augOF4NB+At1c
         hRi8e2aREEkqflQKr/DYFig+nhKYm+cbc45J7zm00iMBfBP0cijA1aERDh1+cuWkuJa/
         y9j1NmteWgIObKmYck+IV6ChWfolxvRK6tzXvNo0JnUXUXjVTNfzWHwbOG4RLcZLSPwD
         /Sr9m1mN/laFHIv0YoaWW3Qme1a1Qzyy44Hswz/xSEu1fKEf044Z6PUjNT1UwktxYLLu
         XVyg==
X-Gm-Message-State: APjAAAXxA4q5GldNJkkQQhxzb2L9oHlnnpfsCHL8KvDQsFYlgA783T/B
        wHozkiuAAGfjg7ekt8WrGfEGOK6KmcXP0Ka2SCyTmXPVfamZ+oEjAX+xp6WrZzRBrMqlKrZnszf
        8sHNed5d1bG+cI5Vz
X-Received: by 2002:a2e:80d3:: with SMTP id r19mr7600188ljg.41.1569927998515;
        Tue, 01 Oct 2019 04:06:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxF7ey7zH6PHxP/6fLsFaUaJkgz6GjZBtefzLjtkEFZNc67+7xJsf0oFLLYg1YFR52avNmJ+g==
X-Received: by 2002:a2e:80d3:: with SMTP id r19mr7600179ljg.41.1569927998399;
        Tue, 01 Oct 2019 04:06:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id q13sm3760697lfk.51.2019.10.01.04.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:06:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EC7A218063D; Tue,  1 Oct 2019 13:06:36 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com, mcroce@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
In-Reply-To: <20191001125246.0000230a@gmail.com>
References: <cover.1569920973.git.lorenzo@kernel.org> <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org> <20191001125246.0000230a@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Oct 2019 13:06:36 +0200
Message-ID: <87zhiku3lv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciejromanfijalkowski@gmail.com> writes:

> On Tue,  1 Oct 2019 11:24:43 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
>> Add basic XDP support to mvneta driver for devices that rely on software
>> buffer management. Currently supported verdicts are:
>> - XDP_DROP
>> - XDP_PASS
>> - XDP_REDIRECT
>
> You're supporting XDP_ABORTED as well :P any plans for XDP_TX?

Wait, if you are supporting REDIRECT but not TX, that means redirect
only works to other, non-mvneta, devices, right? Maybe that should be
made clear in the commit message :)

-Toke
