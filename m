Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FBD2EF77D
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbhAHSfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbhAHSfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:35:31 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A4CC0612FD
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:34:51 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id lj6so4102876pjb.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FEWIkCbz+vb2XY9nSE5ZZ7uvn6rsI2nBN+AFR8fyA2Y=;
        b=Z7Xhhdud7qOGaUZAsTLB1jkF2cncMv3++aoh5mBV+klpuTLegOto3IbN7vY1vH9R+5
         j+7zaDwO2Cp9qPEB+wrL5+nYaaVxkvhsWrk6IJeHp+5UJiguUiijEdusIr8xGsxhYIS6
         TckVvrlKnyc6XF0poQmd3uKWGP+PPZmQFDeXJTV7nOMw+1iK73+rO1/cpHlwI8eAfdOt
         /n+I2PKLotY/347QzfDZqodqJhj8txPBi24G16M6VZrWehAXS0Be+U9oVbzj/5FMzZsY
         hsPOsqVkmB5T4bKsoGt5Lu6N3psvCIS32HRPO86YQh3jv7pgXoUYjKSNFMUzVwDjPqNq
         +N9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FEWIkCbz+vb2XY9nSE5ZZ7uvn6rsI2nBN+AFR8fyA2Y=;
        b=MLDFFKcrjYmOXDCsFJJYUUiwb0odWuxUUj7/muT9DYaIFUzpXy5CQ4U0qlDCLFiR1d
         USAhFSRLFaYMt2CR/b72ArJlSocqH5tJsbr/ytLJv1Y4P7Sgk6bYjEwxC6931g7A0Cj4
         +X0U3yxENt/5H5a9ZzgLg1f8/Q4PvzkATdptvJ0pOn2/lTL9pGHnH+D/gbCogUDJYB3/
         OhlChJKG16oHZsjXDOKceXEsbm3H9dQMtHcVXnGRUn/08pTkhC1TT8Pd6Yr2454UWXlI
         yVtLbWYhIZxEGNdULEo4WbvlxKiXE9XpF514zKfhe/2kRqCmdcy8013R3TUS3/dCdLID
         38HA==
X-Gm-Message-State: AOAM5330D4AQBrmvernb/4KebITitbZa/isaIME9DN4uTt6PoOaEM7+v
        hDL0bpraCK83C8UYR3y81t8=
X-Google-Smtp-Source: ABdhPJw7rWaC2kPGKuhxWVC4mdISkQk7+zszCEuWaK2u4P7dkSGldPPKp00iBCoWUUbkWN2jQKxjAQ==
X-Received: by 2002:a17:902:c517:b029:d6:e179:2097 with SMTP id o23-20020a170902c517b02900d6e1792097mr8152272plx.70.1610130890745;
        Fri, 08 Jan 2021 10:34:50 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n28sm9654346pfq.61.2021.01.08.10.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:34:49 -0800 (PST)
Subject: Re: [PATCH v3 net-next 06/10] net: mscc: ocelot: export NUM_TC
 constant from felix to common switch lib
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b647ed96-cd77-0306-3c89-a3e59f022c0c@gmail.com>
Date:   Fri, 8 Jan 2021 10:34:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> We should be moving anything that isn't DSA-specific or SoC-specific out
> of the felix DSA driver, and into the common mscc_ocelot switch library.
> 
> The number of traffic classes is one of the aspects that is common
> between all ocelot switches, so it belongs in the library.
> 
> This patch also makes seville use 8 TX queues, and therefore enables
> prioritization via the QOS_CLASS field in the NPI injection header.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
