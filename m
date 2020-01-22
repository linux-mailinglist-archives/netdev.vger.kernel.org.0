Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C83A1451FD
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAVKCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:02:18 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46494 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgAVKCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:02:18 -0500
Received: by mail-lj1-f193.google.com with SMTP id m26so6043253ljc.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 02:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VhoYmuSstk/2K06EIELhQ5VwyqfaDBHbgwdw+66AVIs=;
        b=As5mZTorGZs7MRZMuYYFngj2vAFyNJrqV4igMu9+jT8xfKNmCcQx0I/CMo1aqeUYjC
         6uCzqzAtM7dEqOBxmFLIVuLUCE8b3aUSJAukAjpybnBYKexUXrk4goFut1yl3VUdBYBg
         84Fs9vO80NgcZtMJqNF9rH8aJtmTN25o1qmdqcf3gf2Sb5nq4Nv0J07F1g2C/UPwosn+
         ne8kfSxixzCuZgB19jy2hS70X3oDdeu6CmvdsCVqZVJkJO59b+R0UszGzjREEba7rfb9
         U8t4VKFekmgIQNXbGFKiPs5CtsQlq6nZa6KCTXA1VKCq9MUTECvwKcjGaxcrbNcxwdiV
         U2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VhoYmuSstk/2K06EIELhQ5VwyqfaDBHbgwdw+66AVIs=;
        b=glVny+XEBZs92PYxZHDFX8orW5lnlrrX6YOBbDPMGYMjwR3Ndxxk/5dYP3SP5O5QpP
         LAhEMTaoLPHm7rIcjstLWtYU7vRbDcJL1AynVWguNYLz3kZhbFcBiyWMg3A88H9UsqjF
         Euc71jmzABKu6kFY0j0f4Q5aFz5vuZ5/gcMfhM/G3Bk4fiyZ75v/4G5UK+ZgkIHAlwZn
         Qwx9FGNxQTVSelSMWPo1mhEWYKy3SJiKJQalwBz/3WYNN4ND5tEfnoU4tWd05hbUWTyZ
         24/S+8LHpa4cEeK3Z/KKMkkKrfzgDORLdbfoX9NEp+fVRRIKm2qOZ594VshNeTAIg4Va
         uieA==
X-Gm-Message-State: APjAAAWNQszpliLB+/ukjKScKcAdvceYsMOhecbM7mQv50P8QoyTrgwK
        iN0BgbrQTuZkqmLEwhwuzEyHKGiMNXA=
X-Google-Smtp-Source: APXvYqwNJdU/+zDQYdveVF/6kfTAzrvxENOaub5Ydg0y63RRINOqGusBg/IPnVaoCnx3H6FDytBQ6w==
X-Received: by 2002:a2e:9883:: with SMTP id b3mr19046792ljj.80.1579687336615;
        Wed, 22 Jan 2020 02:02:16 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:468a:1e6d:e8e4:fead:7539:293d? ([2a00:1fa0:468a:1e6d:e8e4:fead:7539:293d])
        by smtp.gmail.com with ESMTPSA id s18sm23651566ljj.36.2020.01.22.02.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 02:02:15 -0800 (PST)
Subject: Re: [PATCH net] Revert "udp: do rmem bulk free even if the rx sk
 queue is empty"
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <ec4444596ced8bd90da812538198d97703186626.1579615523.git.pabeni@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b5be7e66-b809-094b-56d6-8c4c9bebf413@cogentembedded.com>
Date:   Wed, 22 Jan 2020 13:02:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <ec4444596ced8bd90da812538198d97703186626.1579615523.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 21.01.2020 18:50, Paolo Abeni wrote:

> This reverts commit 0d4a6608f68c7532dcbfec2ea1150c9761767d03.
> 
> Williem reported that after commit 0d4a6608f68c ("udp: do rmem bulk

    Willem (as below)?

> free even if the rx sk queue is empty") the memory allocated by
> an almost idle system with many UDP sockets can grow a lot.
> 
> For stable kernel keep the solution as simple as possible and revert
> the offending commit.
> 
> Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Diagnosed-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: 0d4a6608f68c ("udp: do rmem bulk free even if the rx sk queue is empty")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[...]

MBR, Sergei
