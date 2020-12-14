Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319D02D9B6C
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgLNPsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:48:45 -0500
Received: from mail-ej1-f65.google.com ([209.85.218.65]:37433 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438996AbgLNPsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:48:30 -0500
Received: by mail-ej1-f65.google.com with SMTP id ga15so23127601ejb.4;
        Mon, 14 Dec 2020 07:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SgRen1ZhC/pAe8vYBTZ3kKObm5NlQwhtZvoSZbvu9sE=;
        b=agWM0J0IAxWWmxKFQnMJnDnANxRVtIPiu15hh+wW6aATLhPAUn2Qcdtix7ZQNPiHsm
         zYh+1v7/XSjAiCqxg8e08T1Q8GHA0VEjlGjajrawUH2qrMqOyTAM2tGqJZ2w4P2GyKwc
         D1H3nyQcoNjHxsJaxtKOMRLa2yoNvcerQH829G3j1bAFAo2OlR/oL9jy9yRpQml38XWA
         R9DOHcxlquRyTPdFQYsLdnB98kAs2zQOeHgPOr6MlM/iEpPmXKyJEhxEIG9Hwchr8Xov
         O5lGj/f57t5GUEqEsCQuky+O3zaKk6ZICTbU2KwWppnCybCUkHvTDpDnc2lUmnrehbQY
         uFBQ==
X-Gm-Message-State: AOAM531P3UukqtN44JfGXhiWMU9xDXFqXE0gHn1o1HrZn0qfRG2EIa1i
        zug7qMvw2qEHfPBghn37/YVk+In5qyI=
X-Google-Smtp-Source: ABdhPJzQpZw36joO+GpvD5q8984HG7N+a5LaSC3eo13U2hHRfzNJ6pYFTSIHPku1b+VISvHX8g6fhw==
X-Received: by 2002:a17:906:ce21:: with SMTP id sd1mr22545331ejb.396.1607960868963;
        Mon, 14 Dec 2020 07:47:48 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id z24sm15898561edr.9.2020.12.14.07.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 07:47:47 -0800 (PST)
Date:   Mon, 14 Dec 2020 16:47:45 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Release the nfc firmware
Message-ID: <20201214154745.GB2493@kozik-lap>
References: <20201213095850.28169-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201213095850.28169-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 06:58:50PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> add the code to release the nfc firmware when the firmware image size is
> wrong.

s/add/Add/
s/nfc/NFC/

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
