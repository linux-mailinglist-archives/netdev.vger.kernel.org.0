Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B26722B33
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 07:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbfETFiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 01:38:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34956 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbfETFiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 01:38:17 -0400
Received: from mail-pl1-f197.google.com ([209.85.214.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hSb03-0004Mq-4x
        for netdev@vger.kernel.org; Mon, 20 May 2019 05:38:15 +0000
Received: by mail-pl1-f197.google.com with SMTP id y9so8449980plt.11
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 22:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TVP/8CjCXvNl5tuRgdDmjBu0TWoLXb8FSZYhC65xlcg=;
        b=PXYirPRN+g/f4l9ezfQJbWOaM09RP2okMMxHwuhQYCeHTnKmCSbVDNwEaGZNBdoRxM
         bHJDMvsSpLuQPCQ+CwVu+3ilKLQnnCcr4MCZ164yjHLOeXQHd7qJv3wz/QDkrmiy9hHm
         txCKhoxeWPohcFqLktHzhdukoFiUlJB3mGTFdZyfmiYhw+SdYg/puIiX7Edeq1TQ5ej4
         HHBvWQnmM4QCfpafZNdV3EWbRlbCnY3+vI3NyPg8hDgRwUGO0jeoCoYkYZKnkkJSW6qb
         3zV89z7hnGlpm0fx8UnIl9LrbEyhwP4OmA2QZMLjkuPvUEC9bXpFXQHIKdViU9+53SAt
         EDdg==
X-Gm-Message-State: APjAAAU/zAPyg+e2oIAOBHnTvXYlSKXmGmTH8j8wYzpADpl2xS7/f4dY
        t1rp8E7lPJli1Qayf3Tq65a4LOV+8F9tZVI+J0iwsVA1m6gpfuhlF+VosR7wu2mrqFggGm6fjdU
        5rj6Bi7xZCMLq21AkI8QHVoFVk1ZZhyfrLQ==
X-Received: by 2002:a17:902:8c8f:: with SMTP id t15mr17648154plo.87.1558330693934;
        Sun, 19 May 2019 22:38:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwW4rcstBi9GEFLzD4rZyhuz/ctWFdZ1iAZP63YVh839OqFhd0yW4KEi9QKAq2SrllBN+PV+w==
X-Received: by 2002:a17:902:8c8f:: with SMTP id t15mr17648146plo.87.1558330693701;
        Sun, 19 May 2019 22:38:13 -0700 (PDT)
Received: from 2001-b011-380f-14b9-00f9-1d4c-cebb-931f.dynamic-ip6.hinet.net (2001-b011-380f-14b9-00f9-1d4c-cebb-931f.dynamic-ip6.hinet.net. [2001:b011:380f:14b9:f9:1d4c:cebb:931f])
        by smtp.gmail.com with ESMTPSA id q20sm17908184pgq.66.2019.05.19.22.38.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 22:38:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: Latitude 5495's tg3 hangs under heavy load
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <CAMet4B57L7HfceQXTQtO8_SkBt5L90TaduguAvN57V+0Jb0qBw@mail.gmail.com>
Date:   Mon, 20 May 2019 13:38:10 +0800
Cc:     Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Chih-Hsyuan Ho <chih.ho@canonical.com>
Content-Transfer-Encoding: 7bit
Message-Id: <1D496D12-FE86-427A-A8B8-6A17D229A941@canonical.com>
References: <693030CB-35F4-41C3-9511-CF6C99F5C964@canonical.com>
 <83AB6905-89A7-4F1D-AE88-BA3A1CA28B19@canonical.com>
 <CAMet4B6OXOcz3CZxuY59G4mJoN_LW3gj4r0LJbdT1ePR-BQN2w@mail.gmail.com>
 <7E14D23E-92C4-4D9E-B891-4F08075DF382@canonical.com>
 <94C0FE2C-8B9A-4DCA-91AE-78E16331672E@canonical.com>
 <B9FBFFF9-5765-4EA1-ACD5-87CD43723392@canonical.com>
 <CAMet4B57L7HfceQXTQtO8_SkBt5L90TaduguAvN57V+0Jb0qBw@mail.gmail.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Siva,

at 21:42, Siva Reddy Kallam <siva.kallam@broadcom.com> wrote:

> On Mon, Mar 11, 2019 at 9:23 AM Kai-Heng Feng
> <kai.heng.feng@canonical.com> wrote:
>> [snipped]
>>
>> Hi again,
>>
>> Any update?
>>
>> Kai-Heng
> Sorry for the late reply. We will provide our feedback soon.

Any good news? It still happens on latest mainline kernel.

Kai-Heng
