Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430DA39C73
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 12:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfFHKjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 06:39:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39463 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfFHKjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 06:39:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id m10so6362075edv.6
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 03:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PAHfE6UW3/IKN4cTMNQBKU1lB293wPtE7Cc12NjZwzY=;
        b=sziTWXq9Ea9idrPVfjixxS6kfFBI5dn8fUi5QVL9gwvaiU5V7yV51EYWhh6XuAO0A5
         m3awOA3Soxpyp3E8QqnBty8v6Jaai6aVUTQm+F6wqWa0pNbLJ2lWX91/BJNfxOfXhnu9
         /42wse74JoQPyWtEGv4eWLJhtHf7VCW/oR6KNv6tLlA2QmLY3CAI8sWxtfQ5GFNgVepI
         aFi3bQorWkqVv/xKjBKLBEEAy+iDJ1YKN5uyykO53MCrpZRBh/BHy8i6IhfW5j6bEYwv
         jefX8aVAwJ33lWQYYp8FcaL2LVmPfB8pDf2zfZbdEzw7oO+aSY3CaXZGOK8m48XSPsQd
         disg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PAHfE6UW3/IKN4cTMNQBKU1lB293wPtE7Cc12NjZwzY=;
        b=CW+aNKYdEzxLNmY1nfz439/pp9hQTAzHgmu89e+XkCiQPcs+CVCTzayO3laK96doKR
         hjIQyZCRuKYLGPKGoEIGJrs9BE7yvyGi1RBRC06Zcp29bdW9DMRO4Tv+DGPSShN8bXw6
         TUTk1Hkn2dZNmoF5ty6QPrqn59FKl+6FmL6nlQNAQ/qCOsElce3I8H2gMDVZ9xAQ3NJJ
         R7tuYDeDWEzjT82Wsp1zzTnPD6gumnVFHzuEttGl0kZ2bLyVk4PXbrWiLLKPeJ1G1J+i
         bQ9Qm2HirSvXm/YmHgnEJ4sO2pExrRNn81Su6yAhCqOS2slmqYIrhCBMi07BsmncjCOc
         +WMQ==
X-Gm-Message-State: APjAAAUG6xPWYaowrT60JC0fSLj5Sqv6wdjBi038jRY9k54mQHjFLZFD
        Iaa5JQntZlnsfRrTRZWOdSvcU0HIyPAH7g==
X-Google-Smtp-Source: APXvYqybJC6YCaK5AvmTNzWleWHzLAkq1b8FlUIW2dfcjbxaU2B3cXTMuOpwNwJ1iEJh8ATMfjsB3w==
X-Received: by 2002:a17:906:4c81:: with SMTP id q1mr50721713eju.12.1559990352399;
        Sat, 08 Jun 2019 03:39:12 -0700 (PDT)
Received: from ?IPv6:2a02:8084:601c:ef00:991d:267c:9ed8:7bbb? ([2a02:8084:601c:ef00:991d:267c:9ed8:7bbb])
        by smtp.gmail.com with ESMTPSA id e22sm1253338edd.25.2019.06.08.03.39.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 03:39:11 -0700 (PDT)
Subject: Re: [RFC v2 PATCH 0/5] seg6: Segment routing fixes
To:     Tom Herbert <tom@herbertland.com>, davem@davemloft.net,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
From:   David Lebrun <dav.lebrun@gmail.com>
Message-ID: <752a0680-a872-69d9-c67d-687d830e29da@gmail.com>
Date:   Sat, 8 Jun 2019 11:39:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559933708-13947-1-git-send-email-tom@quantonium.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 19:55, Tom Herbert wrote:
> This patch set includes fixes to bring the segment routing
> implementation into conformance with the latest version of the
> draft (draft-ietf-6man-segment-routing-header-19). Also, segment
> routing receive function calls ip6_parse to properly parse TLVs
> in parsing loop.

Thanks for your patch set !

General comment regarding uapi changes: it might be wise to wait for RFC 
status in case the IESG or IANA decide different type/flags values.
