Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453115C48B
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfGAUtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:49:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43377 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfGAUtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:49:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so15246366wru.10;
        Mon, 01 Jul 2019 13:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+AnXMpMwZrlIfBk35YQ437S8CsAJvA+QoTTx/MRNDtM=;
        b=Is1ZIfKilGB2By/NPup+F9j+eLAuyKWUMij+iy917jrYePmCQ7fpsYTtVLCikCPX2U
         2oa1wmr6f/gvRWxrnS04AVdSGvw2vGqxHOBckHy73M9U/dBVeZ/m/4sbCQZxVY6/HKwB
         ANwc+eLG8mfnzO2XWdANz5dM6GjI9W9XNGh9ffGzSaLJ/aG2vTNoRX7ZagpL3OXjVsL9
         TP2RFiNFgQI3kCEc9SWlPEXh4jyxI+l8pbbjrFVg5lTGlaSUf5ORsYlLFzSDKLINS2Tc
         eQpN65ZeJG3l5/yQtd+/pDOsCasamR4XAXDbNrTsuz0GxysozXOV4npaJaZ47uR/lhdc
         0GgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+AnXMpMwZrlIfBk35YQ437S8CsAJvA+QoTTx/MRNDtM=;
        b=bMNqhQGhxplilRTMk4p/HA5TXLOdS3wLRzQn4vftezzvtz19eGwCpiq8VM9To1iZ+p
         +mwBQWzRTiPDhER4sXt7RdK1a8/PdI0xAtJW7EzEgaEbWKNiS4J/jUYJfaS3EZ6breqc
         kms48uuGIxfmbgevgPFm974kcSu/uzUhVFW4jwfaxkJ/gdcJunkUXvB3CHtMCRf1LWVi
         +iEl1LONPRLGzhySStuJNpaV+E9n9YJ9xRrladB2zLcmHnHaevCCEh/hXTZppzc4wL/L
         1LgNstqoMBpFA75zL7u3qUZIP5mNilLpeAJRk3TWjyyEOWScXO/tM+4FTxFy0m1WK1Uy
         kh/Q==
X-Gm-Message-State: APjAAAX14IqotMmWefJUaJJA5khr/09UMbs4aAVe5Zx7iY+TDMoMQ2L2
        lQrOcpbdIl+BeZ7wIDgarGY=
X-Google-Smtp-Source: APXvYqxNJZy32u78Fr7DibKhiseycbqp7EYr/ktmRewXHAdVAmTvab5a85swg/uV+DoKcrfo6VaHfQ==
X-Received: by 2002:adf:dd91:: with SMTP id x17mr14486018wrl.291.1562014191268;
        Mon, 01 Jul 2019 13:49:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc? (p200300EA8BD60C008DAC9AD2A34C33BC.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc])
        by smtp.googlemail.com with ESMTPSA id 32sm24509910wra.35.2019.07.01.13.49.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 13:49:50 -0700 (PDT)
Subject: Re: [PATCH 2/3] net: phy: realtek: Enable accessing RTL8211E
 extension pages
To:     Andrew Lunn <andrew@lunn.ch>, Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190701195225.120808-1-mka@chromium.org>
 <20190701195225.120808-2-mka@chromium.org> <20190701200248.GJ30468@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <35db1bff-f48e-5372-06b7-3140cb7cbb71@gmail.com>
Date:   Mon, 1 Jul 2019 22:37:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190701200248.GJ30468@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.2019 22:02, Andrew Lunn wrote:
> On Mon, Jul 01, 2019 at 12:52:24PM -0700, Matthias Kaehlcke wrote:
>> The RTL8211E has extension pages, which can be accessed after
>> selecting a page through a custom method. Add a function to
>> modify bits in a register of an extension page and a few
>> helpers for dealing with ext pages.
>>
>> rtl8211e_modify_ext_paged() and rtl821e_restore_page() are
>> inspired by their counterparts phy_modify_paged() and
>> phy_restore_page().
> 
> Hi Matthias
> 
> While an extended page is selected, what happens to the normal
> registers in the range 0-0x1c? Are they still accessible?
> 
AFAIK: no

> 	  Andrew
> 
Heiner
