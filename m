Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA08713521C
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 05:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgAIEGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 23:06:04 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:34510 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbgAIEGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 23:06:04 -0500
Received: by mail-il1-f170.google.com with SMTP id s15so4602176iln.1
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 20:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4X1LVDnSTOyuY10qUdTjoEPlPEWnGoOiX7WmPHwll0Q=;
        b=YTtUOBmBptPNVx7+WUVR9ymFL90gUxuq7JvL62g+J94cDof3ZxXyuiQTKKvDn3Je7T
         nldOWqzCRhiKMkzxcEDysp1D46X5aQ+6mEvCjQWaukCWPhrhRqu5zmSbpWHyRDvfHoxz
         m+RBeHXblejHKNLb2zY7Cjfesm8M0hcsK2dxaoH/PWJfn1qXexlURa3GmXYM7asWGq9N
         QjL3qGXcCcBfz/Gn/NpuTLdPgMWnXR1SjRx0AR1sOnSwpD93dkfFoI7la13lvEWUCjzN
         yJ69z2Vx77kRcP7VYgvD56aX/f0KjSKhvWAQVvrkeyaouz/fSPfhkBvTKPFUI0RITzdm
         3yJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4X1LVDnSTOyuY10qUdTjoEPlPEWnGoOiX7WmPHwll0Q=;
        b=JVr3d/BG7cq0HW2nellCRoJ9pu3ghaLVC0IIWIVKvDQSL4T1odvBkYxuyqfJZUiDfV
         XqmCxc/8W7zEq6cw+c2pAodU3wH0/d8WyF9fE4f4AkB1QU0gGA/Elj0Pd8ycRblDki9T
         cbUm+mHlLApgMozcghCNzQ1rMzjjBeAaqkjAeItNt2pMWypdIFTLvQ66YWtEvWrw9MLU
         5VQ3S43DhSSMXO15XZAibnOceuE4Wc7K6FKkiQRCDfHwZbFPW07D9Tfhk6XRLuL2HyKH
         dLpHNT8vtZplefU6d5pQHuw1emgdHFQeJUJx4tZEfOH63lo+VqxpAZKi3DmCoV5EaIuc
         GyKw==
X-Gm-Message-State: APjAAAV33XKbcSc3U7cG8vUhvVBIoZGLeHnBNUTqGn8g7TvlrTlyZvJa
        Vd4PgRi79U7raLrGCywkFzNCAzpeuRo=
X-Google-Smtp-Source: APXvYqw2rNFkgcK7o1By206S+Nwbf4mrDMId+WOPsaADZ/1t8qyWdhW9nktX2BAbGlpTLGwrTSUzAA==
X-Received: by 2002:a92:15c1:: with SMTP id 62mr6936311ilv.216.1578542763456;
        Wed, 08 Jan 2020 20:06:03 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:601d:4dc7:bf1b:dae9? ([2601:282:800:7a:601d:4dc7:bf1b:dae9])
        by smtp.googlemail.com with ESMTPSA id d12sm1627825iln.63.2020.01.08.20.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 20:06:02 -0800 (PST)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
 <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
 <3bafff5a-f404-e559-bfd6-bb456a923525@schaufler-ca.com>
 <8e0fd132-4574-4ae7-45ea-88c4a2ec94b2@gmail.com>
 <a730696a-9361-d39e-5dc1-280dc8d0f052@gmail.com>
 <44c7cd8a-7383-dada-e193-bcd79852912d@schaufler-ca.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b9473f09-d3f9-4f26-67fc-9e9805bec0db@gmail.com>
Date:   Wed, 8 Jan 2020 21:06:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <44c7cd8a-7383-dada-e193-bcd79852912d@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/20 4:06 PM, Casey Schaufler wrote:
> This version should work, I think. Please verify. Thank you.
> 

It does.

