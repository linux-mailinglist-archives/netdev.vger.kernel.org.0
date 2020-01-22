Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34509144A84
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 04:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgAVDql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 22:46:41 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44441 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbgAVDqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 22:46:40 -0500
Received: by mail-qk1-f195.google.com with SMTP id v195so4965134qkb.11
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 19:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JAZ/ZMWyuq4FEKtrvhmJMV31P86848x61Sz2mRvsyMA=;
        b=LgaM3CJqEuDxXiTF1gwy/pOlzOdm31HG9vE330U3+N4ih30G+UDRleHicyvlmYw5hS
         a/ClsVy4/0Ik6AYwajEbLPmVKfXifZDsW8XE5E/OLpi02cAcJNoeH0HWq0GQtrvvTcvu
         OyilDjYY24KCp7trgT2+Aba7O3C3Ykh0gxMKkcDOBQRL1mt/3IBYrKZY9hlrtKaaBYI5
         B9ydjeiuHoMgykW3oDiKUDS9RtbG6OSZtIHRy5n6y9U439atxJb4avfO3XWJ8D8fHdf0
         MDER4m0JXVkybzNRY7SYB1yKqBSBxuRo5rHoJTX4GilJET/9a/q9GpbrT3N7eZLiyPXU
         aQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JAZ/ZMWyuq4FEKtrvhmJMV31P86848x61Sz2mRvsyMA=;
        b=OZwEMT/D4rZPDHzVp47rYKhWkwdRlQCzznCRfvPcumCmXB6/KYHkoxkDuMwrTVUXSg
         w5pfA5Z/zKp6E+8w8GxubOgpudzm3pM38FDb5QlGUSKtExVzDg/0uuyL6x7aeZ8VaTfb
         fg0K2Hkg86HUZVeGpSQq/e2jVj3Onrb2/h/GDuaR9tmjrRzqQo+mO+NeU4p0vO87BPtv
         yXZjWF3xhnxYcmHyUKAp926QEf2uxyvkqWL2F6hOLuWDHSxXqGD2mQXmYANzgw4u7gmj
         uBt5jft21F80HbSQV1TgEf77vVNMEMI3t3qpYfIyGliIfwIGkYTN+MVR8Bc7nev+260w
         OBoQ==
X-Gm-Message-State: APjAAAXtZDmBrFJ3yGpxbPCf7SKA8GuYp9kex4UMwIuTxMQtJMMEptZz
        r+R1uvr1otFf1MCkOVEyIyRlAPjev50=
X-Google-Smtp-Source: APXvYqxmHnjYEOy1j8yPGBDbb418bFqFaQ6xp2RXNtoEh0a3Z8dI38F9PqQ1tSc2ovN2/7JvmyjMNQ==
X-Received: by 2002:ae9:c018:: with SMTP id u24mr8041128qkk.339.1579664799766;
        Tue, 21 Jan 2020 19:46:39 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:8177:51f2:6c2d:fef5? ([2601:282:803:7700:8177:51f2:6c2d:fef5])
        by smtp.googlemail.com with ESMTPSA id q126sm18228720qkd.21.2020.01.21.19.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 19:46:39 -0800 (PST)
Subject: Re: [PATCH] tc: parse attributes with NLA_F_NESTED flag
To:     Leslie Monis <lesliemonis@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>
References: <20200116155701.6636-1-lesliemonis@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c6587456-23fc-6a20-7a0a-8a7114a9fc19@gmail.com>
Date:   Tue, 21 Jan 2020 20:46:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200116155701.6636-1-lesliemonis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 8:57 AM, Leslie Monis wrote:
> The kernel now requires all new nested attributes to set the
> NLA_F_NESTED flag. Enable tc {qdisc,class,filter} to parse
> attributes that have the NLA_F_NESTED flag set.
> 
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> ---
>  tc/tc_class.c  | 6 +++---
>  tc/tc_filter.c | 2 +-
>  tc/tc_qdisc.c  | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 

applied to iproute2-next. Thanks


