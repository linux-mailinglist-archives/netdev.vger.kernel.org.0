Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110762C3839
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgKYEog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgKYEof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:44:35 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC78C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:44:35 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id z5so156797iob.11
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SSJF+vDpHIlN1Livg4wOJjE4b8r350ulZhtPKBaSYN4=;
        b=FlpL39F+DYsOYs3eCa6Ps4M0asL3urd//ViFkMRqkwigELPvHFrHvDHL+ZrFQrR9kb
         wiMuS3yyMa6tzuIH87KRqGb3WABWM2rm7tHAvLsJiKQPLiGvdF2pbvpUiFuxFxcaQn4S
         isltUK0bqdz/tvAxH33vMMvT3bYNil79BOSm1OVJ1DaUShu6wbXQyaCuK2MjEzteE5Ce
         CqtRaIa5PGyqMiPaw+h2DhFf7LYtT/NbbzDdeLQZmBnW2u6R9CEXauvnPs/XmZNH6wCv
         7yAIgvYjUrNb3DKw5s9lnfWOOQ/HS4mAx5bQKIxYqF7fn//Q/tj7IuuwGOGbN4uJn0bn
         K5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SSJF+vDpHIlN1Livg4wOJjE4b8r350ulZhtPKBaSYN4=;
        b=CaMveT6qpRwNKk3/kSrms3+ycQwz45h3/9+SifQfN2a1cPfsAidwjSuQIC581UBDNj
         fP3hpCwum6MrxVWONSiGhclUHax5r+FWo1qCRGdgMZxF4GlmoVkbJRiHgQL7Ho2ryCsc
         AhZl6jFGuQm8IUfI/jf8lZ6alhDP0wsc3Sdi0uiGnP7uH3OceAMeGgRwSBGVn88GmOoT
         IrJCBugq4xdDKSHWys3NSQgEmbz5rjwGP0gVC2BflNPCl2BKp0gkDRQBs81/Ydg+e5kc
         hSN7IP/jBPik+ZIsne6fBzVE9dFujUWPNO+PG+kY/fYVm63EKSxZgISd4sv+2PQRB2s7
         +TZQ==
X-Gm-Message-State: AOAM530GIdcdexUnH3GrcTyqFCPVknvXj4tjgJuV5bxkOvVoBo7+KryN
        fZ2FJEFM64I3I4+Df8DOQPdm9kc68N4=
X-Google-Smtp-Source: ABdhPJwa2NNLH9O11t7eGwknIw/lwnftIKnQhTj8OEcNQpuQ7YM7jbnM001KyQ3It548iUbsGL45mA==
X-Received: by 2002:a05:6638:58a:: with SMTP id a10mr1755688jar.51.1606279475330;
        Tue, 24 Nov 2020 20:44:35 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id n7sm133778ioa.34.2020.11.24.20.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 20:44:34 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/7] Convert a number of use-cases to
 parse_on_off(), print_on_off()
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
References: <cover.1605393324.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <933aa799-0196-f61e-b02e-6d4b9e37978f@gmail.com>
Date:   Tue, 24 Nov 2020 21:44:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/20 3:53 PM, Petr Machata wrote:
> Two helpers, parse_on_off() and print_on_off(), have been recently added to
> lib/utils.c. Convert a number of instances of the same effective behavior
> to calls to these helpers.
> 

applied to iproute2-next. Thanks, Petr.

