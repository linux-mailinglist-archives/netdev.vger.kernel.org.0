Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8C72B5A70
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgKQHmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:42:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45656 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgKQHmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 02:42:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id p1so22088988wrf.12;
        Mon, 16 Nov 2020 23:42:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6lmdmyelkoEB9gzAp95iXGDLbWF/DQXwrl5ihHxXqg=;
        b=MD8mW1seUQf7dPaDCKb5gZuT/xa4u1ilp1H5SVNH3Em1ZESkVp1UkDHToGI3EVYcgE
         sR+Uv4etDVJfBKbxBWUTvYGuFiuJthJIKGLnz3sn1DC797BcY1tEsOi4ydZEThrScw2T
         gpKxpbc8cFCoyWbfl+wwoyBKZNXUyUk6gQ9zXLidXyOxI3jGSQgCsJ6hMM4Lg6dGYM8E
         c/9jRfRPzGl4q++3pSOca7BqBumpWR11ub03XhCu+F7+Mit0LMxa/o3W2O2t+RhF1TF6
         N70nRggez5OKKwGl1camt6xjPBGh3eyZOh7m9DHmyk2EJ2QLve2ddUj6kd00naxsY5ZK
         oKQg==
X-Gm-Message-State: AOAM531QmAwySK6A8yS3OQ1noGbE0l/G6UyfQIn0fQL0y71yH5Udsn9T
        8OP2O+BZI1Yc6ODaRuQP4U8=
X-Google-Smtp-Source: ABdhPJwz7v/JwkX1NfdLdtvc4Gd0wHaN4a6K1NJBmsfKsXIKeWm7WCxP5OxJ4lTjZ+Tp39bypmoKAQ==
X-Received: by 2002:a5d:474b:: with SMTP id o11mr22519988wrs.235.1605598930245;
        Mon, 16 Nov 2020 23:42:10 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id z22sm2385254wml.9.2020.11.16.23.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:42:09 -0800 (PST)
Date:   Tue, 17 Nov 2020 08:42:07 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/3] nfc: s3fwrn5: Remove the max_payload
Message-ID: <20201117074207.GC3436@kozik-lap>
References: <CGME20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2>
 <20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 10:16:11AM +0900, Bongsu Jeon wrote:
> max_payload is unused.

Why did you resend the patch ignoring my review? I already provided you
with a tag, so you should include it.

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
