Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA582D9B82
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731409AbgLNPwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:52:33 -0500
Received: from mail-ej1-f65.google.com ([209.85.218.65]:33393 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439518AbgLNPw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:52:28 -0500
Received: by mail-ej1-f65.google.com with SMTP id b9so23192362ejy.0;
        Mon, 14 Dec 2020 07:52:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eUUzZ3vVO1OOxq0lP4QkRTp4abvgiVw9uyvagV8zpRw=;
        b=PHvFPzMHY2qN0pGxtGXfAVuW/2vIhj3dm4ubh7vaQ8TLQ/+g5JcSEcgecSc6lBKQ3b
         8E8ALWZrFThe/f4rDt2TZSYw8aHWupuyZRUHNyUG9VQCajiNwp/+iXwG2R2ctpVxiysX
         627alguko9b7es59wesAIPFBjGGpn0ZZdXVATNBFswU/dM87/A+aeR4aaFwkSeLY+gmk
         mmePDoFFwnksu7Ouy1u6vRFV9sL58Bbcp+0sgBxjG9+A6kD2bYA9yALOFWPFWShOnP9e
         uFnPvbomK2YZERAIucvpta+66zU/7Ur8LWS4iYhuhQ05iXuNTaEM5g8YBB4tNBtMG6CT
         Z86w==
X-Gm-Message-State: AOAM533yyFaeahiwcOIHo7Jg1EVycsuvwrdi5knczrLSJbnBTC8V1upN
        j8zIc4EowwoKe+6UXKANUKaDwacJKSY=
X-Google-Smtp-Source: ABdhPJxxb97fPDcZnskh2hpG0wg+EQcwXlYxQlOL8+qWuGIXGQbXxsAk++b3V32wkLIHGZ3jteoypA==
X-Received: by 2002:a17:907:40f0:: with SMTP id nn24mr22482714ejb.233.1607961106635;
        Mon, 14 Dec 2020 07:51:46 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id lr24sm13926950ejb.41.2020.12.14.07.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 07:51:45 -0800 (PST)
Date:   Mon, 14 Dec 2020 16:51:43 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Remove the delay for nfc sleep
Message-ID: <20201214155143.GC2493@kozik-lap>
References: <20201213101238.28373-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201213101238.28373-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 07:12:38PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> remove the delay for nfc sleep because nfc doesn't need the sleep delay.

Please start sentences with capital letter.
s/nfc/NFC/ (here and in subject)

This explanation is very vague. Please rephrase it.

Best regards,
Krzysztof

