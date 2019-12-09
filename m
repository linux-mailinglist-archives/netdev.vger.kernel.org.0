Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B39211715D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfLIQSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:18:24 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:33310 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfLIQSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:18:24 -0500
Received: by mail-qv1-f68.google.com with SMTP id z3so2872514qvn.0
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 08:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wC7Sf/uo6CfuKrsvXK/l/vbxDk3ZK1u2NuCSrwck27g=;
        b=m+8HhL6wLmXQsMjt0cFQt0DVs3VBsryMBrsuOaZAEx0xxqAh19sau/BnGBI5vBzxnK
         fH4GeF2FUYKSsbzhbIb4d0bdzRr6ZHivjsys7fQPdRTXeQahHROXnaJBYjPrjE70e64z
         lFqNeeAsK8lSX0R5tQkrUHSANECnxGLyuvdHLGHZnf30V1eDSGMuw1Djt13E95mCM5f8
         qbNIff6OSInGnFYIUdEhfM2GDT7CkiRGWszLT+u3P78jWQyp/CyWlcFulAnEIo3YvQQ4
         ifu/1fPxwd95Nyhywl9sGbsdTXmSdPo5br1bPNd3MUfgD6C4sVy+dNLxbEJ335MXuvPG
         /bXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wC7Sf/uo6CfuKrsvXK/l/vbxDk3ZK1u2NuCSrwck27g=;
        b=i4V2B46Su1cQPPGowViH8MlaHKwVRsiyRmXVJO2Q2NbyU32Iyu8ZuYi/tb1E7GWA5y
         SJbsgvZG5dVoWIIJaw82SiH7fVPEmhSeTOri1FCEKZvBNp6VVl+SzYZkMmr3lYKgrzGF
         bg+4DM64SuGjYiy/dfLJmtmrkJSTX8uYWav0SDouxxd8+XoIbr0BjGYpZ5S7DpR98o56
         18DgvFYhOGP5dz4ObaRkoiTkd5YLhySePlSjpYKJS/N5w+vXcG11IAJp7+qABoNunCKS
         1X528FA7RhK0zIBFYgyL4Za/ncO59zHdFYFCQxCHACkWTSSFUGmjYs4druj/6mURoy6x
         vqmQ==
X-Gm-Message-State: APjAAAWsoFx+PRwazJzDgIRV180Qmx9tzUkw9EDmesvd7EkHHA5/ngFz
        srEicivNXlN1qqOl0jYx0HM=
X-Google-Smtp-Source: APXvYqym3dsaS69WWOZ9PwDNq+4Iz4POxscfOyxsxtKR1CBUN8aHF099o78tCWIb+IiQzIJwmJR3uQ==
X-Received: by 2002:ad4:5689:: with SMTP id bc9mr23753620qvb.132.1575908303287;
        Mon, 09 Dec 2019 08:18:23 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:6903:116b:63ac:ff23? ([2601:282:800:fd80:6903:116b:63ac:ff23])
        by smtp.googlemail.com with ESMTPSA id 13sm8961940qke.85.2019.12.09.08.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 08:18:22 -0800 (PST)
Subject: Re: organization of wireguard linux kernel repos moving forward
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <CAHmME9p1-5hQXv5QNqqHT+OBjn-vf16uAU2HtYcmwKMtLhnsTA@mail.gmail.com>
 <87d0cxlldu.fsf@toke.dk>
 <CAHmME9oUfp_1udMFNMpeXPeoa7aacdNp9Q31eKvoTBpu+G5rpQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8a5bdf0f-c7f8-4667-ecba-ecb671bea2e5@gmail.com>
Date:   Mon, 9 Dec 2019 09:18:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9oUfp_1udMFNMpeXPeoa7aacdNp9Q31eKvoTBpu+G5rpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/19 5:49 AM, Jason A. Donenfeld wrote:
> I'd definitely be interested in this. Back in 2015, that was the plan.
> Then it took a long time to get to where we are now, and since then
> wg(8) has really evolved into its own useful thing. The easiest thing
> would be to move wg(8) wholesale into iproute2 like you suggested;
> that'd allow people to continue using their infrastructure and whatnot
> they've used for a long time now. A more nuanced approach would be
> coming up with a _parallel_ iproute2 tool with mostly the same syntax
> as wg(8) but as a subcommand of ip(8). Originally the latter appealed
> to me, but at this point maybe the former is better after all. I
> suppose something to consider is that wg(8) is actually a
> cross-platform tool now, with a unified syntax across a whole bunch of
> operating systems. But it's also just boring C.

If wg is to move into iproute2, it needs to align with the other
commands and leverage the generic facilities where possible. ie., any
functionality that overlaps with existing iproute2 code to be converted
to use iproute2 code.
