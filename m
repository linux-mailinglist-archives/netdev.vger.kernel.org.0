Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E338655F08
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 02:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiLZBXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 20:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiLZBXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 20:23:39 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E87E2DFD;
        Sun, 25 Dec 2022 17:23:38 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gt4so9572820pjb.1;
        Sun, 25 Dec 2022 17:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5adZ3Ex7gDXzlgqV/Dt96q0AjVpKIqck6Igw+0G9yE8=;
        b=pXOMeIFHKPjkCEcjinUKf+C9rYcP+/imSdnkCb0y8z4Ccl3Z+rT8EA0Rk7ZRXnR21Q
         QDpd35ORByrEsQM8uRkkS6qUCDji7sdugej5ukyeF2+bFMdW6MzBnnZY/1qSzyPmA7eJ
         W3BdXSM0ZdEbULdUwlIt39CFi79/Ii8kP/RDwUpMt1JwHUkfVtK2C8dZI8Fs3aF88vU+
         mC2YttE+VC+vaNvwDWWhwrR4FFgxMVmbRKSVfdrYpdJV7UhEs+hB6XS7ya7H9uGZCAWO
         pbme/EDvlsnt9oX6vGNb9oeDI+4VqWL30qBPhUVpDuI5HnYviwJ2f1+wXVJU6TqSX2tP
         1QKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5adZ3Ex7gDXzlgqV/Dt96q0AjVpKIqck6Igw+0G9yE8=;
        b=VhxpUluHz6bYnyj0tGPtsdvP5GYWpnNHoNoR5t+BzYJCHtEoCGSIfD/5aczx1dhD0P
         YvSsrbLMRkk2aRL54V5axzYKzaTfKwchV90alAzBCkG1IEWB2LUg2dBZMH/wOlg5kpv0
         5FssiY4xIjxgaxmn5P7Qo3xNjPlvArK+ehWCGWVa+1u6RYesfKhuKsl43d8WTOb9M1Rz
         AeQeDEDzQqSnj+APVUKccyR63XFiDJdxTa3Mw+T4V0MVW4Fj07Aa/4YFN4Gzt/jANkq6
         CX3/LV2+KtVMhbpNOcXcAEvBqfzNhNc5hyZ5UWJphle9x35vjplrpY7CawHCLzDCyTU2
         k8gw==
X-Gm-Message-State: AFqh2krDH0PNG8TwCpB9mvP6DmkHqdkDvyIRRGy6lcXJfj1H10oD25O4
        M3taWXY/4eTHbDoHj9dJmPrGJbpiWB4=
X-Google-Smtp-Source: AMrXdXvInUWXgdX0/94sHjhlvfNgCC1SiD+SIVTPv8lJDMUO1hVgtm0EJfAoqpvtcPnEJV10GjDpSw==
X-Received: by 2002:a05:6a20:a6a8:b0:9d:efd3:66bf with SMTP id ba40-20020a056a20a6a800b0009defd366bfmr21470292pzb.6.1672017817610;
        Sun, 25 Dec 2022 17:23:37 -0800 (PST)
Received: from [192.168.1.5] ([110.77.216.213])
        by smtp.googlemail.com with ESMTPSA id iz17-20020a170902ef9100b00188fce6e8absm5774651plb.280.2022.12.25.17.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Dec 2022 17:23:37 -0800 (PST)
Message-ID: <10cff30a-719d-f6b0-419c-36c552f4bc4b@gmail.com>
Date:   Mon, 26 Dec 2022 08:23:34 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/3] USB: serial: option: Add generic MDM9207
 configurations
To:     Matthew Garrett <mjg59@srcf.ucam.org>, johan@kernel.org,
        bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Matthew Garrett <mgarrett@aurora.tech>
References: <20221225205224.270787-1-mjg59@srcf.ucam.org>
 <20221225205224.270787-2-mjg59@srcf.ucam.org>
Content-Language: en-US
From:   Lars Melin <larsm17@gmail.com>
In-Reply-To: <20221225205224.270787-2-mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/26/2022 03:52, Matthew Garrett wrote:
> +	/* Qualcomm MDM9207 - 0: DIAG, 2: AT, 3: NMEA */
> +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf601),
> +	  .driver_info = RSVD(1) | RSVD(4) | RSVD(5) },
> +	/* Qualcomm MDM9207 - 2: DIAG, 4: AT, 5: NMEA */
> +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0xf622),
> +	  .driver_info = RSVD(0) | RSVD(1) | RSVD(3) | RSVD(6) },

Please tell what the reserved interfaces are used for and why they 
should be blacklisted.
The generic Qualcomm driver for 05c6:f601 (which is used by at least one 
other brand/reseller) specifies that interface#1 is for USB Modem (ppp 
dial-up).
I assume that you posses this dongle since you add support for it so you 
can easily verify that function which I assume has not been disabled in 
your version.

thanks
Lars

