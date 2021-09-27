Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFF941987D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 18:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhI0QIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 12:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhI0QIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 12:08:42 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB25C061604
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 09:07:04 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z184so3066480iof.5
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 09:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UyGvdpL0yI/ULspuTPee70a1f1XcbYQ8D7yj9dqZP+U=;
        b=ayizTBwZpPQvHFDReipVPZ70ewR4viJDyiBMwnqT/PUx4YvjYq6byIH/90VPbv9Tev
         LdWGmYqF1ZXJzbK2PExHlScWSg/wGbYVbUsqjWEvV8v+B08jIlOFBzeZ16O+/KU0553c
         sFK+IM6WxlqNp7Tk0PI44o9gTqmyYZV1AO8Fg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UyGvdpL0yI/ULspuTPee70a1f1XcbYQ8D7yj9dqZP+U=;
        b=YmPcsrhbzDNrbL+ERoCBMIYz0JI8acpipGzex0m9RWqNjEm6JWZsGTx/JJYJyhNwHD
         CuIu84f76eKUh4V+C2KxltOREH5cw/6flty6TysI1eiwKNfxy4tVZCR0ybeTO4Ca/xJ7
         bsVm/XLCKDF7mMZoxaw4PdMd1Byw8oZuNJ4eoSJsZJzlYxYmFx5TWdJ+kpBCBP/PB9lY
         K2e0d7KHy2V2CCaWmWpskcuI5oHZjbVZdkLbIU4rtNv/2HjyxQqShh8tAVJ7PdHxNp3s
         d4kftgetoFvRimN3TXf5hhCZG9jUJG8QTtau+RyXNDrzLYzurK1fzg/qal/M6aokMH3D
         qAXA==
X-Gm-Message-State: AOAM531Hy0qi+O9aqFep3EHMVoiW1ifM7ZWAHmuQLIxEMiN+4tXXqLMB
        7QlSlVUBx+8lrhkwecxu6GO+/pp+2+WiZg==
X-Google-Smtp-Source: ABdhPJz3RxQB2d5HkgswYyLpu0bvTOTnMv+arPBIBIQLIFzeQdaL97l1wnArkVlnJ4jzEb6eIBhxbw==
X-Received: by 2002:a6b:6a14:: with SMTP id x20mr331256iog.177.1632758824207;
        Mon, 27 Sep 2021 09:07:04 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r20sm8804331ioh.19.2021.09.27.09.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 09:07:03 -0700 (PDT)
Subject: Re: [PATCH] net: ipa: Declare IPA firmware with MODULE_FIRMWARE()
To:     Shawn Guo <shawn.guo@linaro.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Steev Klimaszewski <steev@kali.org>, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210926065529.25956-1-shawn.guo@linaro.org>
 <20210926134628.GC9901@dragon>
From:   Alex Elder <elder@ieee.org>
Message-ID: <706be34f-9306-0212-baca-6c8dd3f19829@ieee.org>
Date:   Mon, 27 Sep 2021 11:07:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210926134628.GC9901@dragon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/21 8:46 AM, Shawn Guo wrote:
> Just reminded by Steev, .mdt file conventionally means we are using
> split firmware.  Building only .mdt file into initramfs is not
> sufficient.  So please disregard the patch.
> 
> Shawn

OK, will disregard.  May I assume you are going to implement
a patch that does the right thing?

I had a note to myself to investigate using MODULE_FIRMWARE()
but hadn't gotten to it yet; I'm glad to have you do that
instead...

Thank you.

					-Alex
