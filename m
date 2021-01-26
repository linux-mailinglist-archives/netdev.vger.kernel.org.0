Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7871304891
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388355AbhAZFmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729423AbhAZE1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 23:27:23 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915A1C061573
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:26:43 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id m13so9300707oig.8
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QPU9pyzVRmr3LaYZw5Jnifg5fhKjwPXnWDdbpaJD28U=;
        b=C66W5FFZJ3kQPdr+hblOpoVGc0e3AM2kDzG2+LqgWtwLObrggAQu5NDtSK1/AR0AQr
         R2w9mtyRUO6Z/uhqwY2DZN7Eo5hXODYmxQKYCdUJiZOWhanc+pVXGcmuJV9fxDzYJNfd
         Zx48lc/OhwPCvIvgoy8df3iZhwf5Z6oNSMJgKCRCMy5IVG78vx7Wv4/L3QDPP6kS7dY6
         4/qrMpNHZq5dg8ERouI4eygdGRjePNcwdyT3Ef6y4t2iLl+zwfums9rUfqCPPekhDnHX
         0xK76iulOCIQbg+3gxaRa0ws8cVyyzxvqSKTovceXZljkQ//97pkv7e2Qz3jCc6wqda4
         QJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QPU9pyzVRmr3LaYZw5Jnifg5fhKjwPXnWDdbpaJD28U=;
        b=JRs/MzA4flKQQ/F7U33X7WvEdxbT7HY5fanRRa8JNYOhfZnKPbd+niePZw4Mpjn6hR
         H8Jh9TU2cuISwyZHyMKOzua2AyqHrMMiXEoK3ziKUSpFGLbTjj9focNj448tRx/pUj8x
         QkpRFt8UEbyKgxww8UTewGgWL51N4C5LYrQVugAdWmmNNUFiML7GTXfvrFuROCEMl4cG
         yEGDcDJpghKKlW2KjgtzvpchN0vnvfJgfxlVx+xQHzquOxXxkxrI0PjtKID/mMYcAqK8
         ix9nbwXd2sNy6RAV50tk3iT1MzlIcNbDLVgCMK0ZgvjL7OKZlGeS/Jh+uvBeLpqlvYZh
         2+Mw==
X-Gm-Message-State: AOAM531GmdmcSC72LCmsJuLSzVJJG5KS83sI3x5a4iq4NJZX9prVCFuq
        PXELJBNHYRfdNgjbPQW0sbBTUA/Qrvo=
X-Google-Smtp-Source: ABdhPJxop7069L7J+tsUMOmcdvlBN4X+Jn0SfJttuW66I7iJhgsQZ9b1CzKwhpv1sAlJUetdSEeGgg==
X-Received: by 2002:aca:ec89:: with SMTP id k131mr2036191oih.131.1611635203011;
        Mon, 25 Jan 2021 20:26:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:f5f4:6dbf:d358:29ee])
        by smtp.googlemail.com with ESMTPSA id s23sm3811138oot.0.2021.01.25.20.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 20:26:42 -0800 (PST)
Subject: Re: [PATCH net-next v3] selftests: add IPv4 unicast extensions tests
To:     Seth David Schoen <schoen@loyalty.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>, John Gilmore <gnu@toad.com>
References: <20210126040834.GR24989@frotz.zork.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <eee96675-38b8-0252-a004-97c3537230be@gmail.com>
Date:   Mon, 25 Jan 2021 21:26:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126040834.GR24989@frotz.zork.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 9:08 PM, Seth David Schoen wrote:
> Add selftests for kernel behavior with regard to various classes of
> unallocated/reserved IPv4 addresses, checking whether or not these
> addresses can be assigned as unicast addresses on links and used in
> routing.
> 
> Expect the current kernel behavior at the time of this patch. That is:
> 
> * 0/8 and 240/4 may be used as unicast, with the exceptions of 0.0.0.0
>   and 255.255.255.255;
> * the lowest address in a subnet may only be used as a broadcast address;
> * 127/8 may not be used as unicast (the route_localnet option, which is
>   disabled by default, still leaves it treated slightly specially);
> * 224/4 may not be used as unicast.
> 
> Signed-off-by: Seth David Schoen <schoen@loyalty.org>
> Suggested-by: John Gilmore <gnu@toad.com>
> Acked-by: Dave Taht <dave.taht@gmail.com>
> ---
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/unicast_extensions.sh       | 228 ++++++++++++++++++
>  2 files changed, 229 insertions(+)
>  create mode 100755 tools/testing/selftests/net/unicast_extensions.sh
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
