Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C42B2C91
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 11:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgKNKDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 05:03:21 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54238 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgKNKDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 05:03:21 -0500
Received: by mail-wm1-f65.google.com with SMTP id p22so17541292wmg.3
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 02:03:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FRKjhZCCzVHQwkqBtiWQVygKKHMgOWcgoYqlQjAgFzs=;
        b=mhW22K66t20o+GgvN/uADuKGCan9koK+1OCYI6kIX1R4H60JxzCSJUIqvsHcNO+qbI
         J3SUZZ1hhUafKExBD5COgZUipSw8YLSpmkBAk7hIXvIQL/HWUVgjEVJAcp4JmKjuuy1W
         zEiIiPMMe9/cFOgWFlPS/L22Bw6AdrD6j6b2dqptx2ksbttP6gFzzNZoSbSGcrhTGSr0
         nkZfY4xpe5lXNeScsSffwPDqIuyF0UOcAbjiSIp2ba6pK1PIsIOmUwUZwCYjy7z3cGuu
         YbLQVHhgT9HJIivTpT3lu8FO1n961ppyRTn2YGoXumzxx5eM1ID/hnLwfGw+2Hhx692k
         hv0g==
X-Gm-Message-State: AOAM530ASBrypf3JxpjenxtqefmjQOW9ZlMZY5ABQD6Ok3iqHlhv96zr
        zSmqLTwIEPbm9H7LsPTSGCQ=
X-Google-Smtp-Source: ABdhPJw8RVgTz/cXoRRy4RuGOs4cLBYpXCYOdyXMEUsJFb8YZs0dhbkP4Pj4pfquDlWcTRpFG8Qd6A==
X-Received: by 2002:a1c:8095:: with SMTP id b143mr6433955wmd.147.1605348199303;
        Sat, 14 Nov 2020 02:03:19 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id z6sm12570448wmi.1.2020.11.14.02.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 02:03:17 -0800 (PST)
Date:   Sat, 14 Nov 2020 11:03:14 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] nfc: s3fwrn5: Fix the misspelling in a
 comment
Message-ID: <20201114100314.GB5253@kozik-lap>
References: <CGME20201114001920epcms2p78585234d9079f03673efdab2dc817548@epcms2p7>
 <20201114001920epcms2p78585234d9079f03673efdab2dc817548@epcms2p7>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201114001920epcms2p78585234d9079f03673efdab2dc817548@epcms2p7>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 09:19:20AM +0900, Bongsu Jeon wrote:
> 

Empty commit messsage cannot be accepted.

Best regards,
Krzysztof
