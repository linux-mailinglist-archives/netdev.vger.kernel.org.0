Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F9494E34
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243248AbiATMs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbiATMs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:48:56 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1794CC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 04:48:56 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c2so11889438wml.1
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 04:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lIhRsVQM89fOOn/pqPgkwPpB+n/X0P3c2czsugv+l2M=;
        b=rl3pTj9LhDtldBrZ+GVn/MKMVIN6PyzQNXRg0oHPZiksCJoEVO9TQ+i+U/zj2/wys/
         Mk9WIVPRgMfS0wQv2i4qupduWu9w0+PTklEQDEWw9drgOS4Q752ER0CD6EsHZVmEts2d
         5eM/gNKk9szZC1JJIzulLNZdYlGCEQoQjhHYHKeCK9/NC5Yp+7x9iN8Cqqd/18GABG7n
         gqu99O2zJStQLll/csZ0HXsb35jpAcqaLNqAlG9yYFf3SKHWy8ZiXxAjFeYVbmy4lcBc
         c5hvoQj52ALFXlkq/xX9hGcy/VqhyA4oiqIwfarcCFZNqbP0KZF9sbLiVUh636ZDnMVd
         0s0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lIhRsVQM89fOOn/pqPgkwPpB+n/X0P3c2czsugv+l2M=;
        b=Tb3zWQagidHFy6vSSZWeVbjf1C58cxQb1640bh9T7HrhpU8XISF/51dqv/ugG4m4XE
         JNq/RWgYv6YUdVSmuUV/ODUsdzQBzEpkZQHwRsbGkE4RXVNE11HVOXdJD5/mB+UIATam
         5sDcCcPyPU58HT0Fkp803zZbzak9tp1VOgSayrlr1Q/W8aD3SwpuFXjTBC3Xdn5G+aZl
         uzeHeQ7RNbQtY0H7eHvAij1d1wM1Fl22ky9Tvkkk809v3YojtOQ5I8fxRFc5/TOQzCsO
         kaoNZmOopzeEuwjP0fdWkMCPuRL8qvI/6Zlb8OECK5NE4nF//I+du+VcxvDKfIz2ukUL
         iZqw==
X-Gm-Message-State: AOAM531HxfbxImUVTw1hdmU41l24mowNattzAE4equzIta4wdnDvsL3a
        83GcxOogzva/aHgfsxBZcJ2/+iCHgV7s24hocXbeHw==
X-Google-Smtp-Source: ABdhPJwVz0ZES7K7wO8S6SoBDernRzL84NBIWN+7AzcU7dEbbKnaR17Pjod8C5Th2qn1fHW9SIoDh4R7ZqtvompeQ7U=
X-Received: by 2002:adf:d1e1:: with SMTP id g1mr21368862wrd.616.1642682934719;
 Thu, 20 Jan 2022 04:48:54 -0800 (PST)
MIME-Version: 1.0
References: <20220111175438.21901-1-sthemmin@microsoft.com>
 <95299213-6768-e9ed-ea82-1ecb903d86e3@gmail.com> <e8e78f5e-748b-6db4-7abe-4ccbf70eaaf0@mojatatu.com>
In-Reply-To: <e8e78f5e-748b-6db4-7abe-4ccbf70eaaf0@mojatatu.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Thu, 20 Jan 2022 09:48:43 -0300
Message-ID: <CA+NMeC8ksPxUbg_2M9=1oKFWAPg_Y8uaVndTCAdC+0xvFRMmFQ@mail.gmail.com>
Subject: Re: [PATCH v2 iproute2-next 00/11] clang warning fixes
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Sorry for not responding sooner. I patched iproute2 and several
existing tests failed.
Example:
Test 696a: Add simple ct action

All test results:

1..1
not ok 1 696a - Add simple ct action
Could not match regex pattern. Verify command output:
total acts 1

action order 0: ct
zone 0 pipe
index 42 ref 1 bind 0

The problem is the additional new line added.

WIthout this patch:
https://patchwork.kernel.org/project/netdevbpf/patch/20220117175019.13993-6-stephen@networkplumber.org/
it the output of tc actions list action ct is:

total acts 1

action order 0: ct zone 0 pipe
index 42 ref 1 bind 0

With it it is:

total acts 1

action order 0: ct
zone 0 pipe
index 42 ref 1 bind 0

So I believe the problem is just formatting, however it still breaks some tests

cheers,
Victor

On 17 Jan 2022, at 12:29, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

On 2022-01-16 18:18, David Ahern wrote:

On 1/11/22 10:54 AM, Stephen Hemminger wrote:

This patch set makes iproute2-next main branch compile without warnings
on Clang 11 (and probably later versions).

Still needs more testing before merge. There are likely to be some
unnecessary output format changes from this.

I think the tc patches are the only likely candidates. The
print_string_name_value conversion should be clean.
Jamal: As I recall you have a test suite for tc. Can you test this set?


We try to push, whenever we can, to kernel tdc tests. The Intel robot
should catch issues based on what we have there. If we make part of the
acceptance process (incumbent on people who create the patches) to
run those tests it would help getting cleaner submissions. Not sure
if we can have a bot doing this..

Punting to Victor(on Cc) to run the tests and double check if we
have test  cases that cover for these changes.

cheers,
jamal
