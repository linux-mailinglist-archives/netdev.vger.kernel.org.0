Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCE731AC05
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhBMOFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhBMOE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:04:58 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2207AC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 06:04:16 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id e1so1843680ilu.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 06:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=XfrBb6sB60yhNSm78XNTHoePRNQ24sdlRWhH4ZAggLg=;
        b=YDXnW4Ff6iGXdaM3U2rm9YU2c5goO9dDAHbd0p+6i/mJ3lEEURyu1LyQv0dBAIOke6
         r2KCvMy97S0lHa9h0vJ7KwEeKTftVT5c5vilaVt4Ov7D07VaSw5yPhB/egfusm++1LU8
         hZWT/NNX2HbohgD6VT9oE8fEchL1EKg1uYULp9jEoS9OZ6DPIO6NYZwd9Uit++jkWUjm
         MLRQ+pRIZ3m1ds65wbcgc7mYdagevnss4aqwG0gkHaCHgevTtLLBg9WNDuc/emwYf0Bb
         /uah7pykEHSy3xEba5GYT4vsr3qeCqH2kvYytWpLof+vxxvJFB/1p8PWKuEBtekvBlZc
         62Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=XfrBb6sB60yhNSm78XNTHoePRNQ24sdlRWhH4ZAggLg=;
        b=r3LkrW6iIKcrsOzkhb84thdpndWAyQ76aOWf2j/oNgkIhDYVbM/Ws4xvZnVbvjOqFW
         +aoGamy5HU+bfJTTGc+E3V2WDn9uPk891bP/7WMCmcT7YAmLTMWsNyRaKdjITge5MEvS
         JenvH2HWQbQEhD598qC9MmZhUJhO02ld0GDzer3dU7Jytt1Z4fOA1Uoun3YZyNOgAXC2
         7UxdzCDIR3jfKxJfUUZ1Z7HR2l5Gu7ZVgF9JXDzuFqW7nZH/ZPlfrZFOiGJKygWiliwe
         nJbGrFGz2gHztsc5THBj4zXuHcqMy8siWdwMTJBzL6Syb49pBFbgrCFfa0FQMtuvo+7h
         p9tw==
X-Gm-Message-State: AOAM530TG/3BzlK9gvwISyFqwwn89CoJx7U+E4R0XF9NA5Qltote7C1B
        0ELPoYm2InxSP3oeBv5s754=
X-Google-Smtp-Source: ABdhPJyZmYSXEcy9SQGno4PnlVUFNQWvUq7UzP0lpsml8tfhuUVBQxTMVdZEawWZYGz2BxxZACKO4g==
X-Received: by 2002:a05:6e02:1b84:: with SMTP id h4mr6155229ili.196.1613225055477;
        Sat, 13 Feb 2021 06:04:15 -0800 (PST)
Received: from [192.168.1.2] ([96.78.87.197])
        by smtp.gmail.com with ESMTPSA id x7sm5726538ioa.48.2021.02.13.06.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 06:04:15 -0800 (PST)
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com
From:   Jefferson Carpenter <jeffersoncarpenter2@gmail.com>
Subject: [PATCH] lib/parman: Delete newline
Message-ID: <65ad19ae-4f69-17be-7a2d-d19ce36a4b1c@gmail.com>
Date:   Sat, 13 Feb 2021 14:04:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 6.2; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------568068764570235E61C92645"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------568068764570235E61C92645
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Style agrees with surrounding code

Thanks,
Jefferson

--------------568068764570235E61C92645
Content-Type: text/plain; charset=UTF-8;
 name="0001-lib-parman-Delete-newline.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-lib-parman-Delete-newline.patch"

RnJvbSBlZmExODVhYzFhMmI0NzE2YzZiNWNmNGU3NWMxZWIwZTkyMTY4OTNhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZWZmZXJzb24gQ2FycGVudGVyIDxqZWZmZXJzb25j
YXJwZW50ZXIyQGdtYWlsLmNvbT4KRGF0ZTogU2F0LCAxMyBGZWIgMjAyMSAxNjowMDoxNSAr
MDAwMApTdWJqZWN0OiBbUEFUQ0hdIGxpYi9wYXJtYW46IERlbGV0ZSBuZXdsaW5lCgpTaWdu
ZWQtb2ZmLWJ5OiBKZWZmZXJzb24gQ2FycGVudGVyIDxqZWZmZXJzb25jYXJwZW50ZXIyQGdt
YWlsLmNvbT4KLS0tCiBsaWIvcGFybWFuLmMgfCAxIC0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvbGliL3Bhcm1hbi5jIGIvbGliL3Bhcm1hbi5jCmlu
ZGV4IGM2ZTQyYThkYjgyNC4uYTExZjJmNjY3NjM5IDEwMDY0NAotLS0gYS9saWIvcGFybWFu
LmMKKysrIGIvbGliL3Bhcm1hbi5jCkBAIC04NSw3ICs4NSw2IEBAIHN0YXRpYyBpbnQgcGFy
bWFuX3NocmluayhzdHJ1Y3QgcGFybWFuICpwYXJtYW4pCiB9CiAKIHN0YXRpYyBib29sIHBh
cm1hbl9wcmlvX3VzZWQoc3RydWN0IHBhcm1hbl9wcmlvICpwcmlvKQotCiB7CiAJcmV0dXJu
ICFsaXN0X2VtcHR5KCZwcmlvLT5pdGVtX2xpc3QpOwogfQotLSAKMi4yNi4yCgo=
--------------568068764570235E61C92645--
