Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BB41FE969
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgFRDYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgFRDYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:24:04 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58306C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:24:04 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l12so4809141ejn.10
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5M/gH2V4+b8PALmvtckyWrGcRGiNDonnV7fIcVwIdEA=;
        b=u5GCsV6TccmVXAm/fbM1Lee4vn+yA/l9MDdtH8DiR4v0Btlzz046v++MkIVTo2u5CK
         qp0R1BKDuEfWxoj3YLc6Fsk6v9ETxKGEcAikplZQatDmNq/OZ1L/viormDPqDuext0MC
         tMBKP5Iz48x3QZnT+0iIgq3MHq4bRlaa6kKA+tbtUd0WPbDgtb4iyAk05j7l3PE4RaW8
         RPGkkhw47KIQeT2o7g4vnWYSab/EIlI8smv4N9Hu6e+RkOFLjfozvuy1aQtoq4qVhoQ6
         YsL194+vg0uLHSfRyldikk61G70rxDSO+AjLNP0MW0J124TXiZVxqOTghHsOlr1WUTJN
         rP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5M/gH2V4+b8PALmvtckyWrGcRGiNDonnV7fIcVwIdEA=;
        b=mM5qqqoUkC4D4IJNgfMV+Pp9JdP7rC/h1a8hn/nx7lw+/YrvnlO/FJIKzgYBHF68qo
         RifpwKd6H/LtUhrKvKtLkOviV83trhAj9R1lQwvWpJE97s8cJ580tc88eO+HNSN+NZbN
         CzHO7nPB9ADoWZ1hzZSKKVCjoDMctOe282vK0OvefaiXRlP2YmlqG53I0+D4ZwnzHYiG
         3fPTXx5neE74UEnEsDx57KDgifTQMEi5f0GegnsUS29P1zNdaRVPnCc+ECaT9wBE8fNT
         8jgjOc6H7FP+rnTZ+6h4URtbsUlkPP7LwsUiiWmOda/pE1PXr1Lahmh9EKfwzVKYplFX
         SiSw==
X-Gm-Message-State: AOAM532HBzTyrrBwqEDSOsP6W6sdMtCO9vY6N72ORiI0e7mHdskKe4pm
        bUwX+aqoQ8vijalkHIcpKdg=
X-Google-Smtp-Source: ABdhPJzo6ADMPTkiL/mTjRmTmn65XJLbyeCEv/NM1Aj7zs9UT+5Dk4Ae9eBmKrdVqgD1SG3BOzwDuQ==
X-Received: by 2002:a17:906:95d6:: with SMTP id n22mr2114953ejy.138.1592450642957;
        Wed, 17 Jun 2020 20:24:02 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u13sm1307861ejf.60.2020.06.17.20.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 20:24:02 -0700 (PDT)
Subject: Re: [net-next PATCH 4/5 v2] net: dsa: rtl8366: VLAN 0 as disable
 tagging
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
 <20200617083132.1847234-4-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a575b511-fb9c-48c3-211b-0da5001b9e0c@gmail.com>
Date:   Wed, 17 Jun 2020 20:23:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617083132.1847234-4-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/2020 1:31 AM, Linus Walleij wrote:
> The code in net/8021q/vlan.c, vlan_device_event() sets
> VLAN 0 for a VLAN-capable ethernet device when it
> comes up.
> 
> Since the RTL8366 DSA switches must have a VLAN and
> PVID set up for any packets to come through we have
> already set up default VLAN for each port as part of
> bringing the switch online.
> 
> Make sure that setting VLAN 0 has the same effect
> and does not try to actually tell the hardware to use
> VLAN 0 on the port because that will not work.

Why, you are not really describing what happens if VID = 0 is programmed?

It also sounds like you should be setting
configure_vlan_while_not_filtering if you need the switch to be
configured with VLAN awareness no matter whether there is a bridge
configured or not.
-- 
Florian
