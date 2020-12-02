Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227212CC297
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbgLBQjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgLBQjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:39:44 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88453C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 08:39:04 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id x16so2221790oic.3
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 08:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f366nkIqj/VQMgS6jHzY9FK9KvS9W591gXZT+/ALELI=;
        b=DE+w9fUJF0sKtTWX7WgyGJXiG30QloOoPh2D/P70AuHNa77F/SnYRE9l1WEBJh3Lyd
         w41uW3zcJXjvKD7dKIlE2X7QBzrAIFiO9CDKx1QFUVZIxy4ozUpz65heBUn4ht5JIfs4
         rU7DTWBz5NHRWb9p3/OtE35l44qnexxsnDBnoLrdJe0UN5DDUTRSppiBxscZtIsYq6H2
         40b0i0TtF9oLxngCJ5N4GDlw8QSryjnRBOl84kbBvSZruW3wiipvKf8bC7OZ3oOepjNv
         4jVjWgrPkuDnhUdMoomBgGpAD2UTKyR+VvFwzsM0VhyPuiAeuCzp4IKnRlgbbVF4+wtZ
         kzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f366nkIqj/VQMgS6jHzY9FK9KvS9W591gXZT+/ALELI=;
        b=aw0ZsWwS/Ow8DL0XKA5pdNekFqvwdsCdLVKRfA6Nd3FCGCWMbWHpZRnQuE2wL7C2DS
         2wXfw1IG/1sLc0MdHWTqPec6q/2I88KNxuhu65LpU81JBsQg3BAP8cmq9jGNo0rlOxee
         fjOW7slXtMr1xUVrqdIWRfKFdctrhUsIv4iPcaNpwxHWrcw3v9GAadVNQ5VuuBSTqwLi
         92V/puhs7ptZMg8M6BroEQKhZlNnIRHxqrkMtvcICuRDPRLGoF1uOkDEeF1o8CZSkX3C
         knEyT4T15ryyS38Sx13hyMq2f4zLNP8iSRoONIDIyrypUSIAZYww+X1k6xQOLF/ULV2Z
         VhOg==
X-Gm-Message-State: AOAM530FVItGz2jHjl9hnMUJixfXHu+s6k9wJzOcxV5u2iq81BU4giOh
        nbKMwvrkZ89VQYNNzL39ALg=
X-Google-Smtp-Source: ABdhPJx+Rikqy/3ALQT+E3X+7jKwGwrfX4/4axjnIHxYE107M8IYkZ8MK3bfnbzjy2hA3Iazi77Pbg==
X-Received: by 2002:aca:4257:: with SMTP id p84mr2249783oia.176.1606927143939;
        Wed, 02 Dec 2020 08:39:03 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id 9sm468913otl.52.2020.12.02.08.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 08:39:02 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip: add IP_LIB_DIR environment variable
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20201122173921.31473-1-ryazanov.s.a@gmail.com>
 <0863b383-cd6a-1898-3556-bc519e2b0cf4@gmail.com>
 <CAHNKnsQ79LMh7L0GbQ69pTb7BS0zbWPs183NSgoTqVnEvihiKw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <62966799-0310-bc77-f027-95f252d2e180@gmail.com>
Date:   Wed, 2 Dec 2020 09:39:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAHNKnsQ79LMh7L0GbQ69pTb7BS0zbWPs183NSgoTqVnEvihiKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20 3:08 AM, Sergey Ryazanov wrote:
> As for the patch, it is intended to make developer life easier by
> allowing them to focus on development instead of maintaining a fork of
> iproute2 source tree. The patch introduces the same functionality to
> override plugins loading directory for ip, as we have in tc for a long
> time. Even the environment variable name was selected to be similar to
> that is used by tc.
> 

it makes ip consistent with tc, so applied to iproute2-next. Thanks
