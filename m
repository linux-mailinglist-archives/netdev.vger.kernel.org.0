Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6137F27096D
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgISAXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISAXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 20:23:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302AFC0613CE;
        Fri, 18 Sep 2020 17:23:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x18so3836559pll.6;
        Fri, 18 Sep 2020 17:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=55UzKqHroMaV97TjRU015c2VDiWopudYBx8CQrtrksg=;
        b=VHygwLJ2B4s5sIppIfHTGofwejRMKJMngUifikVAKh5LzSKuVKZeaE9cMLo5dD67uz
         b++6FW2hcu2Q64FD44QpQIF+So4IijkTlz66JeF3uZCzY7ddYAvUPvf7j3+DAgOIZwRU
         1L63CGt8lpBUxtbzXgBTWmVeqDszt4GPUrhS6wK4OqxeAaaI/J/Uqvu+Yuc1IftIGXVh
         biUanVvw8ODTN0rpTOJ5rz4fUcDdDcqEMvK7GyPmaj7htXk66qEdMBNK+m9Tdi+T7NCw
         Szf8XIr55teQnVH9emf3rLSBh/rts4XpKna1INNZhe49qszKZZbTGhGm/mNxR+dMj1NY
         y3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=55UzKqHroMaV97TjRU015c2VDiWopudYBx8CQrtrksg=;
        b=L7a6/QHBTki6AqcYXG0GecwJ89f/Wnp094ngaBYgEUyypR2uLgZaZRihzEgsk5IVj6
         +JiI5ryeHA6n1NfSuiuVqCsRnHGG0Jw1oRHBRuq/BY4aB5KBoZvA93u2kWnPDIrApIVI
         oKYSCieYqQNrPiBhq51RVaP0W190FlG14JGhgjqo66IZCyBBMF4kkXOiw4vNhB1hvdAP
         w30a69Tt2X891anIOMeNatNNzCnWhOQT4UPgi1pemURGCVHT+QGPRHvabq+3HOmIl5qF
         Lvbefi0PgJwZeLoMDBg5qwn4U8qA5O0qA+GYpiOBiOt7N23C3OGEeKxnS/K25cb3ugb0
         aF6Q==
X-Gm-Message-State: AOAM5325qGyCE3Rt2JFQbYQ4HWmPvsLXwwp8aq3urVd9Gm8/tOMA5PnT
        WIq0C6slPkf3qsyltVyQTQ4=
X-Google-Smtp-Source: ABdhPJwJwWoMW0fME9e6NKiCYk89gJxmDBvATUY/r1IdeECPcex9TvTBsPE0t0DtSy/dXNNjWgrIow==
X-Received: by 2002:a17:902:c202:b029:d1:cbf4:c596 with SMTP id 2-20020a170902c202b02900d1cbf4c596mr24586500pll.27.1600475000669;
        Fri, 18 Sep 2020 17:23:20 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r16sm5113494pfc.217.2020.09.18.17.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 17:23:17 -0700 (PDT)
Subject: Re: [PATCH v6 0/3] Add 802.1AD protocol support for dsa switch and
 ocelot driver
To:     David Miller <davem@davemloft.net>, hongbo.wang@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, mingkai.hu@nxp.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivecera@redhat.com
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
 <20200918.172025.962077344132523092.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <83403bcf-b6d8-f763-9269-682979a5619f@gmail.com>
Date:   Fri, 18 Sep 2020 17:23:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918.172025.962077344132523092.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2020 5:20 PM, David Miller wrote:
> From: hongbo.wang@nxp.com
> Date: Wed, 16 Sep 2020 17:48:42 +0800
> 
>> 1. Overview
>> a) 0001* is for support to set dsa slave into 802.1AD(QinQ) mode.
>> b) 0002* is for vlan_proto support for br_switchdev_port_vlan_add and br_switchdev_port_vlan_del.
>> c) 0003* is for setting QinQ related registers in ocelot switch driver, after applying this patch, the switch(VSC99599)'s port can enable or disable QinQ mode.
> 
> You're going to have to update every single SWITCHDEV_PORT_ADD_OBJ handler
> and subsequent helpers to check the validate the protocol value.
> 
> You also are going to have to make sure that every instantiated
> switchdev_obj_port_vlan object initializes the vlan protocol field
> properly.
> 
> Basically, now that this structure has a new member, everything that
> operates on that object must be updated to handle the new protocol
> value.
> 
> And I do mean everything.
> 
> You can't just add the protocol handling to the locations you care
> about for bridging and DSA.
> 
> You also have to more fully address the feedback given by Vladimir
> in patch #3.  Are the expectations on the user side a Linux based
> expectation, or one specific about how this ASIC is expected to
> behave by default.  It is very unclear what you are talking about
> when you say customer and ISP etc.

Switch vendors like to refer to the outer tag as ISP VLAN tag and inner 
tag as customer VLAN tag, sometimes S-TAG and C-TAG terms are used, too...
-- 
Florian
