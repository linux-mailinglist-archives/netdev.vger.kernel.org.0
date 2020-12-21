Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DD42E002C
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgLUSmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgLUSmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 13:42:05 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F0BC0613D6;
        Mon, 21 Dec 2020 10:41:25 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n26so14827788eju.6;
        Mon, 21 Dec 2020 10:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ivcI0E1dfE9znJYym7OouNXXxQL5iEPpA65NR/BqsvU=;
        b=Uf4Zq6nwXH5HFYce5cZXSxE758PBzIjjVAxIen46sx3/xgAEuLjw2yvIHR8LuDW3wL
         Oy/F7P5CflHacUKJbunTFbzTOD7SXNz0Bhdd/zxVG9/9HhBUzsw5VVwLicZ7SxZ06AcM
         pnmfHUcBp75GJl3WG4VZPSxWxTXr1Wjrh6TNthgbWZQhkSvtAehMwyUJ9msvXzAFVzR5
         b75ZVbENujJE2GqrkG9NArm87aZRXSs9mOT+cV3CLdozG0AEtZrYar89hzTCHeq60V8T
         Ewub2ewQz6ZKI+6TNbV5xxrSiqHMlzxPrjphrSRcUgX9I/z37w0xG+//zc68Odkjrzgh
         G9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ivcI0E1dfE9znJYym7OouNXXxQL5iEPpA65NR/BqsvU=;
        b=ai5Hj+rT9bf00K/d3ksE6Jxx6f9McvGHP/DUVEyeoT/jtl9iL1nNzUFPnhfLsxZQhS
         MOwxYds1JgJopWV5yyfDohhyoPoDmDdlYwS1pDr7mIIXw2uHNpvB/B0m3G4mkQ0gkGak
         PjITfUML5E5RBvgIxS7XRf9ugxHi/WsFfrUbDkdzrj1D4UcMdDMYLM8/jGmLk78wXvLs
         Z4SjU3TrbO2JddX98AGf3a7NynuH3D5AD8mZdLYc2A08cvufm4bTGBTpez5s/0xvSHHb
         BcOY78bq6UA08baPF1KhyFiZlMcBNRDzLEE9gtKWAw596ipS2pOyFhGyx7HU7OpP1r4H
         8sAA==
X-Gm-Message-State: AOAM5319IZmZf82ZTiBN0mqIOTwnNkZiyN7C1Lq7l79vs0dU+k+D9e9k
        xnVemdxPEDSMaI6eX2AxkbyyWu3od9g=
X-Google-Smtp-Source: ABdhPJy9So/0c1r35c60UF2Y3VriQiM7zFEN6wB/+tagc03nN4kSaA5SLtFO0Gr7AaZ5FAsACHQgzQ==
X-Received: by 2002:a19:83c9:: with SMTP id f192mr6473888lfd.399.1608561301587;
        Mon, 21 Dec 2020 06:35:01 -0800 (PST)
Received: from [192.168.2.145] (109-252-192-57.dynamic.spd-mgts.ru. [109.252.192.57])
        by smtp.googlemail.com with ESMTPSA id p24sm2076049lfo.53.2020.12.21.06.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 06:35:00 -0800 (PST)
Subject: Re: [PATCH v1] Bluetooth: Set missing suspend task bits
To:     Howard Chung <howardchung@google.com>,
        linux-bluetooth@vger.kernel.org
Cc:     alainm@chromium.org, mmandlik@chromium.org, mcchou@chromium.org,
        marcel@holtmann.org, abhishekpandit@chromium.org,
        apusaka@chromium.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20201204111038.v1.1.I4557a89427f61427e65d85bc51cca9e65607488e@changeid>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <ec27a562-d53b-a947-1a93-bd55a2dfcc91@gmail.com>
Date:   Mon, 21 Dec 2020 17:35:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201204111038.v1.1.I4557a89427f61427e65d85bc51cca9e65607488e@changeid>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

04.12.2020 06:14, Howard Chung пишет:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> When suspending, mark SUSPEND_SCAN_ENABLE and SUSPEND_SCAN_DISABLE tasks
> correctly when either classic or le scanning is modified.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
> 
>  net/bluetooth/hci_request.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 80dc451d6e124..71bffd7454720 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -707,6 +707,9 @@ void hci_req_add_le_scan_disable(struct hci_request *req, bool rpa_le_conn)
>  		return;
>  	}
>  
> +	if (hdev->suspended)
> +		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
> +
>  	if (use_ext_scan(hdev)) {
>  		struct hci_cp_le_set_ext_scan_enable cp;
>  
> @@ -1159,6 +1162,11 @@ static void hci_req_set_event_filter(struct hci_request *req)
>  		scan = SCAN_PAGE;
>  	}
>  
> +	if (scan)
> +		set_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks);
> +	else
> +		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
> +
>  	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
>  }
>  
> 

Hi,

This commit caused a regression on entering into suspend for Broadcom
Bluetooth 4330 on Nexus 7:

 Bluetooth: hci0: Timed out waiting for suspend events
 Bluetooth: hci0: Suspend timeout bit: 4
 Bluetooth: hci0: Suspend notifier action (3) failed: -110

I don't see this problem using BCM4329 chip on another device.

Please fix, thanks in advance.
