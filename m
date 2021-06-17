Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557DB3ABCE6
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhFQThI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbhFQThA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:37:00 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88C0C061760;
        Thu, 17 Jun 2021 12:34:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d:444a:d152:279d:1dbb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 575109A9;
        Thu, 17 Jun 2021 19:34:52 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 575109A9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1623958492; bh=+FDoO5Ud1J1Le00Bv1li2JtQlBXuIq31yl6Euxvq5DY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=WFVCsFOWoCuezpcMYNJux/MpMipcxgURDCD8bYWZE9oLP+hr0mD3Xe38qE9GlyEG0
         Gvrmx/6wpMEfLebKYi5ENC4W6D93n0xRBg4JlAiYuguUJCOVH/Sbcc177/pSJ8RwAv
         E3cpiJ8f45knZ8aT0CWWOFnt77L2ugwWqu5L+OOgLyx51xHGn3IAS67BR8sCqbaa3c
         mtDp3qgRj9rdXizONDhH6eODDD62j+YLkABCJo+Le9e7A3x1Cf3PulnTM6CCGerVdL
         zkkQaP8VaQg+H9hspqZZVENcEXMVI3DpUgxhieXkAlC9hiz9xqv97/sk0QsDqKlaZS
         9w1F6+Gt7q8cA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        coresight@lists.linaro.org, devicetree@vger.kernel.org,
        kunit-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 00/29] docs: avoid using ReST :doc:`foo` tag
In-Reply-To: <cover.1623824363.git.mchehab+huawei@kernel.org>
References: <cover.1623824363.git.mchehab+huawei@kernel.org>
Date:   Thu, 17 Jun 2021 13:34:51 -0600
Message-ID: <87pmwkthd0.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mauro Carvalho Chehab <mchehab+huawei@kernel.org> writes:

> (Maintainers bcc, to avoid too many recipient troubles)
>
> As discussed at:
> 	https://lore.kernel.org/linux-doc/871r9k6rmy.fsf@meer.lwn.net/
>
> It is better to avoid using :doc:`foo` to refer to Documentation/foo.rst, as the
> automarkup.py extension should handle it automatically, on most cases.

I've applied the set, thanks.

jon
