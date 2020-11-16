Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1652B3F60
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgKPJGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:06:51 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36075 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbgKPJGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:06:51 -0500
Received: by mail-wr1-f65.google.com with SMTP id j7so17798860wrp.3;
        Mon, 16 Nov 2020 01:06:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tfut9vbpdfv8HXF8bwI2zTYoeL/KwnRwgcqOdkpMjQM=;
        b=nqxKsNrvd9qsY+Gx8fS43J0FeiNOVLE89HZGbgYXd0BjirldeuERZC/oaMybkt34TZ
         fVGBLCaryXKOM8odjOLpJ5vhNV/5DwWBXklS7tfZ7tC3n0KctykKBDpCfkWPKfL/Y7kD
         Jjr8CrvqxHrwy9LxAf8B+VSqLaLKaC0f4l1Qzm1hd5rPpvf1vSVL+8pb6zqmVzWRbiGM
         w+rBmo0KhO8bHsdx0wNfCKX5fC/Woj9EIeKfzCJrPZSBSE5hroIBRA4VWk2sz/sOXQhr
         4HGmusY0vfQ4wMY+snHuMntw+nc/cFO3QGEtZTbrYyEd0pdUvSuMgEi/hU7cXOgh+Q/V
         j80A==
X-Gm-Message-State: AOAM531hckKidwTTw1RvOGjPSfaVBbkr95lKlk16yaQWQECM6XnUO8Fl
        nYNfxLiYMUePU3NMtcX2M50=
X-Google-Smtp-Source: ABdhPJymJXtGdK1p6/QBa66dXs3Ikztq26pKrXwaX8dSdc06QcZrx7F9wwgxmGLGLUUkbDSWVt1dGQ==
X-Received: by 2002:adf:f881:: with SMTP id u1mr19170576wrp.103.1605517609770;
        Mon, 16 Nov 2020 01:06:49 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id c17sm22001179wro.19.2020.11.16.01.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:06:48 -0800 (PST)
Date:   Mon, 16 Nov 2020 10:06:47 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] nfc: s3fwrn5: Remove the max_payload
Message-ID: <20201116090647.GA5937@kozik-lap>
References: <CGME20201116011205epcms2p566dbc946d6c7a0198d09b3a872e85f33@epcms2p5>
 <20201116011205epcms2p566dbc946d6c7a0198d09b3a872e85f33@epcms2p5>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201116011205epcms2p566dbc946d6c7a0198d09b3a872e85f33@epcms2p5>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 10:12:05AM +0900, Bongsu Jeon wrote:
> max_payload is unused.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

Please version your patches (this should be a v2) and describe changes
between versions in changelog, either in cover letter or after ---
separator.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
