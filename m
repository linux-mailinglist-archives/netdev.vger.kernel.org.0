Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA7F2702A0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgIRQxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgIRQxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:53:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FD2C0613CE;
        Fri, 18 Sep 2020 09:53:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o8so9001639ejb.10;
        Fri, 18 Sep 2020 09:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t4UNWRw3XtjaYPT1Tohvguum4En79LX5R37iA+oLJ0A=;
        b=H82+wAJgm2/HJXACILHMrIK39S3n8alrwnjBXhCk+vwg9VSlNsBRp4ICEKf2XNxCSe
         ut3AV73svZ9T/d97O8LXGNT30NI9iTsFA99zY70cIRgujDlHMve/IBLq2713Oae6OINK
         WM9z+Qlm9a8/tpfORt9A43LPVER6ejaUv+A/uZbcHZDra0urMSvHjcYNZrVJIMyPKgdR
         SKuS9lP+45ISXCbrI1ngJoBY72aLQu+m2N9kcw1S/NzXFWX5GFpMSmdvG7bnjV849085
         82lR9OCUElD4XF3mG+F5xa6haTQZskautC3hFikdWAzw/uNmYEvofVqvYbt11YVYIeVs
         Uzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t4UNWRw3XtjaYPT1Tohvguum4En79LX5R37iA+oLJ0A=;
        b=AXFYlNHPNSOYKBw+rP5Ff6R6a7y5s9uO0zPPOxJJ8W5VCR10ImqmGqVr8UyGsPgN5A
         auhZV9hwpRUyWXIMB+lhjF4vzHxgx/RjXNsMiW+sdjQ7Qe3fhXeIkQFfjeGMKoA68pN+
         suYXeYXYYCjahA2JNg4k4TyRAVgLl4EjaXUNR5pvxcOwvHa+auFkVJije6gKufLopf8p
         bCV6CURbAV1vSB7DZnQs+LlFuDbofQ+6UkYZZOO3DEgVBiY3POIH7YQPFEOW+9tA0cVa
         cLY8Bg7QSSg8crH/EsQGvGeid7Yr4btiPnLbP2nJZRmjWckYXDS3z+Sno86BFdO9u75v
         W4vA==
X-Gm-Message-State: AOAM532iLtd62vEDkOIl7h9WicFbpEfXV7opVgbg/TurDEDmNekQHJor
        Fk2J2euoKtMcMHk1qUDN7Vg=
X-Google-Smtp-Source: ABdhPJw/qQ1CFM15zpGleITT62o8jtVWAf0d3CugqJMzbgDFfTt7Xf33FX+TUfrq/i/jLiahu8ig6g==
X-Received: by 2002:a17:907:2506:: with SMTP id y6mr35175644ejl.265.1600448016964;
        Fri, 18 Sep 2020 09:53:36 -0700 (PDT)
Received: from debian64.daheim (p5b0d776c.dip0.t-ipconnect.de. [91.13.119.108])
        by smtp.gmail.com with ESMTPSA id ce14sm2678057edb.25.2020.09.18.09.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 09:53:36 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1kJJdb-002nB9-9i; Fri, 18 Sep 2020 18:53:35 +0200
Subject: Re: [PATCH 2/2] dt: bindings: ath10k: Document qcom,
 ath10k-pre-calibration-data-mtd
To:     Ansuel Smith <ansuelsmth@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-mtd@lists.infradead.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200918162928.14335-1-ansuelsmth@gmail.com>
 <20200918162928.14335-2-ansuelsmth@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <8f886e3d-e2ee-cbf8-a676-28ebed4977aa@gmail.com>
Date:   Fri, 18 Sep 2020 18:53:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918162928.14335-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-18 18:29, Ansuel Smith wrote:
> Document use of qcom,ath10k-pre-calibration-data-mtd bindings used to
> define from where the driver will load the pre-cal data in the defined
> mtd partition.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Q: Doesn't mtd now come with nvmem support from the get go? So
the MAC-Addresses and pre-caldata could be specified as a
nvmem-node in the devicetree? I remember seeing that this was
worked on or was this mtd->nvmem dropped?

Cheers,
Christian
