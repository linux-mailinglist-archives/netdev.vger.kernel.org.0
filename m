Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DA2E0B7F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbfJVSfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:35:31 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]:46876 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:35:29 -0400
Received: by mail-lj1-f181.google.com with SMTP id d1so18237630ljl.13
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=d4Vj26TGvpT8Pp948ejBZToOMkzRLVxh6k+58Wg2xwg=;
        b=LodsJjm6yZ9LOjHCZEgtJxPVD8w+jNkfjFrQS54WsJ6WEloyHeuGDp9UTETDxo91W2
         Y2of27/MtHkxOMFUQNn2NnAJHBfewC+ZziwnsRgEFEBl6FfCkxUpiGSwuF5krICiJz1j
         OgZ7/ClTmcOpHiTytb9h1kvKp9vuaSxqy1C88K05ebjWoH86JlZZpl+EiCs+PNAHrVL6
         wQDyZJhRXkuygo0Bui0hDSKV/UKgirFVjAU8eMYihfCdaBkZK430xDM3GFg/IDA5Acdq
         rhmjprkxZToDzITWkcg9ydTi1JULGf17T+fbWu2TWDGEc+05cFJArKuGGqJtYzgDUsgA
         KGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=d4Vj26TGvpT8Pp948ejBZToOMkzRLVxh6k+58Wg2xwg=;
        b=m7TFMOu2C+K5T018eELTy8p26X4LLxmXefbi7DTRDFgYxx2yMyTGzmARenAmFUcAlC
         EuZu8k1OAsOL00mxkk2cT/pjRbinw54d8LWfbMsEwhto20B1UIffwnt7PqQP4BDNdCyz
         +SweIN/71XFO50w+2lw+U/qfeIvuyQmXJKm6Had9Tcv5W+DUAqfR9Qh13rn8BC4RNEKj
         qTQSfogvsbDah2mugqU+g9KFnvqkbh2bYoVVv+Gu2knvmWbdJ1RX4Ry4+rtlkOcYDzDp
         v9UpwFNafeAF8Cb2wlXOutzUQWPH0FaxRs1k0p9W3D/0BHrm3cnnYojAG6p7nLVg3Ndf
         hNyQ==
X-Gm-Message-State: APjAAAXNsxYgZAOUGpg6v1qEz7doMYz7lgyx6yANSDONsa1T0uznDMlW
        /WxUo6OZx2CfG92n2JPEUulAVg==
X-Google-Smtp-Source: APXvYqw2hpKR+LmLpH9nt6R/Lr+GpVj8pTxyVu9B9jUaIrwacwn5DW2rt/eNMqk8oikwYa1unkr0zA==
X-Received: by 2002:a05:651c:30f:: with SMTP id a15mr3287332ljp.97.1571769325806;
        Tue, 22 Oct 2019 11:35:25 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o5sm6592526lfn.78.2019.10.22.11.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:35:25 -0700 (PDT)
Date:   Tue, 22 Oct 2019 11:35:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>
Subject: Re: [PATCH net-next 0/4] r8152: PHY firmware
Message-ID: <20191022113516.15c2313b@cakuba.netronome.com>
In-Reply-To: <1394712342-15778-330-Taiwan-albertk@realtek.com>
References: <1394712342-15778-330-Taiwan-albertk@realtek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 11:41:09 +0800, Hayes Wang wrote:
> Support loading the firmware of the PHY with the type of RTL_FW_PHY_NC.

Applied, thanks!
