Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F472B5AD1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgKQIO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKQIO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:14:27 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F2DC0613CF;
        Tue, 17 Nov 2020 00:14:26 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id o144so9281385ybg.7;
        Tue, 17 Nov 2020 00:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=eAGz42ZtxKLiRa/2ANKf/P4Nyy7DGwzBtfcI18AZXIc=;
        b=SOJoNCxoRMBGJMrUdvbzBB8Z2kiVlkQqx6D+2CyBw/i9fvEgrvsn9cywoOtAunjzDL
         FERIYA0oUuxN4sfjh3ZwdT7AtEgW7//J/TpMgxAPM0zf4po8jpjEclHSwTKi/6yrtA6p
         CwumNRsd1FGQX9vsXPYpYNPYMN9P4bb+Yku1VG0dOnxuE1SzRT490EZu1QTNRdRk1un+
         K7ON02ZrVlU128Ze7hya1jWSyLVAi5Ll7OcOISnAbM6BV3+lEwpf17ly5dKFHN35A2E0
         MBWoQ8tv3mhklVEbn9ETamaBkQvvu4SEPOQqZ7bWQEZOOSrQ7HKpAMdCkrSa3MOUlAo3
         28UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=eAGz42ZtxKLiRa/2ANKf/P4Nyy7DGwzBtfcI18AZXIc=;
        b=juv17+vRKE+fT342uck7BhKZemVon6aphrFV6OpOS66SogBDyeLVhyg1jffTQjZVp/
         uwy0JdwjWDurtljh5Fi6vXYYRaxVluQLuqShGT3+K9FDXZgLAD8dvKl3hdkH1qGmMvff
         dDZQMCPQkvY3vG57XV5fp+LDySdIhVbgqkHVk8ibb1SvCM5R31viPsKBkVhyUEPSxWI7
         QdvCIAy75x4wAojp5Nb2xCvv8ZOmgTM8DHRIGJz3UjStrvjy3WTAG+/DFKDvQsdMDjZw
         05Q0t5X6VxgxwQKjWkdF4pUy1V5dBb06J5f7Pk8ReioZi6pKzMZQPhGsVs2FCAulOOFV
         nO1g==
X-Gm-Message-State: AOAM5328ShFxbRTX8uI3WyX/O4L8x96TEYA1tmIj1WL25mSBA/RJrXE2
        sde/yueWlRrlq4JQdgo2sh9U2OPIXsdgvrG2rE8=
X-Google-Smtp-Source: ABdhPJxzgJBycg8nfMT6vuP+7enT3jtQyv3riK+C8f2sAwkzM9YEMUpxcDrUXxcxVJEuW+SdoTBleDd4xqqL0U5k4js=
X-Received: by 2002:a25:2d55:: with SMTP id s21mr21945436ybe.389.1605600865548;
 Tue, 17 Nov 2020 00:14:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a25:9785:0:0:0:0:0 with HTTP; Tue, 17 Nov 2020 00:14:24
 -0800 (PST)
In-Reply-To: <20201117074207.GC3436@kozik-lap>
References: <CGME20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2>
 <20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2> <20201117074207.GC3436@kozik-lap>
From:   Bongsu Jeon <bs.jeon87@gmail.com>
Date:   Tue, 17 Nov 2020 17:14:24 +0900
Message-ID: <CAEx-X7epecwBYV7UYoesQ9+Q8ir+kjYGyysiyDtCa0BzKiCGtA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] nfc: s3fwrn5: Remove the max_payload
To:     "krzk@kernel.org" <krzk@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-11-17 16:42 GMT+09:00, krzk@kernel.org <krzk@kernel.org>:
> On Tue, Nov 17, 2020 at 10:16:11AM +0900, Bongsu Jeon wrote:
>> max_payload is unused.
>
> Why did you resend the patch ignoring my review? I already provided you
> with a tag, so you should include it.
>
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> Best regards,
> Krzysztof
>

Sorry about that. I included the tag.
