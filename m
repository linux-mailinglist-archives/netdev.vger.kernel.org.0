Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389422BA156
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgKTDvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgKTDvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 22:51:15 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97C2C0613CF;
        Thu, 19 Nov 2020 19:51:15 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id x18so7406010ilq.4;
        Thu, 19 Nov 2020 19:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kY4x9mQQrH7WfgJTVe8rHex4hcGvcT2R/+KC5btfYtA=;
        b=CIAutkwn7G6PdBi0RY4HaZ/5mtdSpCrkjsVyicUvywCGw54Alost0yQhE0bjDU+b0B
         VhwiZBSEooNUCeqYvyDxEuBQVg3/MBlSKglagCRpoDZIyZHum+1pyLIWw8PV8GtvYqcH
         9Q6OmpCI15xIfSOtnka6xmTv6ftBBqhtOqh4yoAWuCvVQLQgInOdV3qCnTKWRWxOu1qQ
         0Str1PW7Z7ME9qAx3FM109Svwi7nuDIirfBo8Uws4fUT6ZAAP8T84FOHFk4jYMXKaeWL
         HKU8PGvrBLXwD1Y9E+4ourrwTGdX60avC+X8HsZuMyLygP8BGePoXur6e4yQYBO3ywwC
         mAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kY4x9mQQrH7WfgJTVe8rHex4hcGvcT2R/+KC5btfYtA=;
        b=pbvDIcv3fPZnzldA6Kyy9xCZvKX99jIjlUaqvP5L1N5Z3qQNKrDt4UEW+pzCGXrBoY
         r49cCPiTFKAIsfqQQn/sFuUkwNjiwzko/Gtwg4fa0y+pnUMmpjMa5MwW/Lcc7tnvXm73
         xm27xima5dSl0hqgkuNKCAVFdhvR6qGDLhji5UohGlSkHaiofZWuzwH7qnIa3iubTUmL
         Jj6S/otPLcZO7SxAtjQ0BoeRVhIlNnTmcM6q2oW9ce7/HwC/F1+9vASDUt6dn9pgcn9Y
         6UtxuOaEHf1xFr/2br27JEjc0UPADGjulUlX29kfzDo+XCamrkZg3XxXcmAIvJwd6ApI
         HKdA==
X-Gm-Message-State: AOAM532rimVhY1M4Y7t6BCi1/D9rm19v1Byc/axyylpT7jnOC6w4OsIB
        gIjcX/am0/iekHW6rfmZrB0ngxx9uis=
X-Google-Smtp-Source: ABdhPJxN9gjnttLFHOvRBU7juFTdH57kB1XEDhJN0YrJFPWTUalnx0BrG59/3iExNrh25aqEMocgXQ==
X-Received: by 2002:a92:d11:: with SMTP id 17mr24857773iln.84.1605844274782;
        Thu, 19 Nov 2020 19:51:14 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7c5d:d56d:e694:8d47])
        by smtp.googlemail.com with ESMTPSA id k26sm699496iom.32.2020.11.19.19.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 19:51:13 -0800 (PST)
Subject: Re: [PATCH v4 net-next 0/3] add support for sending RFC8335 PROBE
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b4ce1651-4e45-52eb-7b2e-10075890e382@gmail.com>
Date:   Thu, 19 Nov 2020 20:51:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/20 5:46 PM, Andreas Roeseler wrote:
> The popular utility ping has several severe limitations such as the
> inability to query specific  interfaces on a node and requiring
> bidirectional connectivity between the probing and the probed
> interfaces. RFC8335 attempts to solve these limitations by creating the
> new utility PROBE which is a specialized ICMP message that makes use of
> the ICMP Extension Structure outlined in RFC4884.
> 
> This patchset adds definitions for the ICMP Extended Echo Request and
> Reply (PROBE) types for both IPv4 and IPv6. It also expands the list of
> supported ICMP messages to accommodate PROBEs.
> 

You are updating the send, but what about the response side?
