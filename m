Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7998C223005
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgGQAhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgGQAhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 20:37:24 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D36EC061755;
        Thu, 16 Jul 2020 17:37:24 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u5so4520189pfn.7;
        Thu, 16 Jul 2020 17:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mTX0PRt/bGA9k/E52i0N4knAb8gmAYEIaPRUuBjEkgs=;
        b=E+mo8W60M5NGm4yNmcqpsdIYPdhPyj2M3KPIrMPzRB//3L3PNv7lbDQECnHuR1b6+x
         AfCUQWwbu4gDF/HXFhwGO615SorEH5RVrnQMArflwX60RBvaZ/NnSmdCWLpPMYUgrfCI
         f0Iz9ItnD3Xxaii53LwPHgTS3EvBKncnqxuZ3lqFYfhzMP16tidDEwf3H0Sb+XKjk7JN
         BRpokTKNjx3BCMneEqBqHNonDFt+N9pdcMtW/tg6an0tCw7eohYMUtJTkUKfynKT8gBi
         Lf787OIjrKeoDv6xLdk5cXbcKU1NimnKuiL15i8zDH1xOF3l9iwkMu+aj+HzdG1F243O
         VEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mTX0PRt/bGA9k/E52i0N4knAb8gmAYEIaPRUuBjEkgs=;
        b=cVYgz+WvkvTYLSeoCcgIn/xTpOClivjJ/DkClHImZuXutD+MLke3i+z9rUOmNUP56w
         zceYEoV5IHifK48mnXdNCB5x1ARrQgFV4zUzVT0gSIuT7vCo3J9hqEWydMRLKnD0EmV0
         x2d5PLI9Dzq7s1bvqAODnK3tu20mkLBSAbCTfy6Y0wZiXvlakaF1V1hdhZjWJk6ks7WU
         brI9h+IKX7XZirWhPX09QeGarE+KxXdfZyCDmGTYn1Mke0mWZogb5mSk1Aa61d9Z8RT+
         qHfN7rNr7lSn9aieViXtrHg2qBKXA5XVCnQSzojEu/UikzUFU/wnrry095nh49TEtAL/
         YwIg==
X-Gm-Message-State: AOAM532riQpW0R3VR02GTTZYv90rbrZR48sKRufM+vty1y3uFbleBy2H
        M5kew7J9RwGJHInbFuB5OkM+GxgA
X-Google-Smtp-Source: ABdhPJytXSyTx4pvQ1HZv4EEoJNG9/7ilgRQhIC6uSsNZXsctfzwJrdW7eyO4cxpdR6dJoNTtXC18A==
X-Received: by 2002:a63:1a0c:: with SMTP id a12mr6446552pga.24.1594946243501;
        Thu, 16 Jul 2020 17:37:23 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id n22sm981338pjq.25.2020.07.16.17.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 17:37:22 -0700 (PDT)
Subject: Re: [PATCH net 2/3] net: bcmgenet: test RBUF_ACPI_EN when resuming
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
 <1594942697-37954-3-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <96c80a48-ab9e-155b-6d6c-913f38f6b3bf@gmail.com>
Date:   Thu, 16 Jul 2020 17:37:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594942697-37954-3-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 4:38 PM, Doug Berger wrote:
> When the GENET driver resumes from deep sleep the UMAC_CMD
> register may not be accessible and therefore should not be
> accessed from bcmgenet_wol_power_up_cfg() if the GENET has
> been reset.
> 
> This commit adds a check of the RBUF_ACPI_EN flag when Wake
> on Filter is enabled. A clear flag indicates that the GENET
> hardware must have been reset so the remainder of the
> hardware programming is bypassed.
> 
> Fixes: f50932cca632 ("net: bcmgenet: add WAKE_FILTER support")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
