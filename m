Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976E44BF08E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbiBVDsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:48:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiBVDsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:48:04 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BE4245BA
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:47:40 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 132so15949121pga.5
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Bv/RFsoG89wttq8rmH3Bv6w8F3sv6GLCmFuQq3nqTFE=;
        b=dKK1NGrmLqT7Y5AcqwA9uOm9Mtb+z/nhpzb9sI1D3LZSbuO3I2gtJP6uQi8ttFq+5P
         O4H0HDkc8uiU2Heb6GX/SYsX4hyN/8w+tXwFhwyan011EfJ/LzRn5NMwzbGFguZ/zMOV
         eHsWqcZ+CppIv2kgA52ivs234JCFfQ/mzpcwEXqxlIDxjbSpfNTSSrkV5ibOA5iSJlFk
         wI6giwAbRzElEKLJ0YjIpD06VlnqWBWqLcs+uljcY443RwYrGjy7/C3uiiws0YgRDRRU
         6aSKsaHqeaB5S9zOYdnmmG8ubdexPqs4QEMpzEBzXF37Vl2bdHa+2iytkZg8ZI+WWX3Z
         rYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bv/RFsoG89wttq8rmH3Bv6w8F3sv6GLCmFuQq3nqTFE=;
        b=KzTiuEtWW6Swxw/gPtCpzQRPKKRNaXMQWUTLfLNdhCC6SWVaGCY9HqCzO7jpiMBXE1
         oO9FdH8vM6G+zVnAyYTKhfuhqo3Z3JhbgbTU8NsLzmvFqCu2ZjJJY6eeeM+SzmvxhTjC
         msvvdhr8tR7KoN3eUBrLFVAVLWaShfBsewZ9/I5TibigBiW+Ldyvs5eOBXCjkukLuAig
         1hcoDEpep5IG/mIQhhy/Bji16s1I49ry9HtYfW6ELjqHx7GxWhY5s9SwHRihe/DQZGyS
         XdxPrXIJPu3lmhTzSwsoKmYjWnJSvo6tegGgjNbz2hbZXHUX75oiC2PF2RFKqCdPjWta
         9MTA==
X-Gm-Message-State: AOAM531lvyShscE0DgGPVcVyHvr2uOf48q3eQwjEpw5tPgSnVxTXtVDS
        a9Rb0ZICQOL7+Saj6ntk5lg=
X-Google-Smtp-Source: ABdhPJy2dDzE3wJ2Db2ZP6JbzVy0V14EtMF2QD6fKjfGY28TS9VQVs1EdQzIvOxNzrcvuXjQwLIwGQ==
X-Received: by 2002:a62:7c41:0:b0:4e1:3185:cb21 with SMTP id x62-20020a627c41000000b004e13185cb21mr22958298pfc.82.1645501660066;
        Mon, 21 Feb 2022 19:47:40 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r14sm5270880pfl.62.2022.02.21.19.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:47:39 -0800 (PST)
Message-ID: <51cb7b6d-e19f-4251-be19-773d9e9405b4@gmail.com>
Date:   Mon, 21 Feb 2022 19:47:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 06/11] net: dsa: create a dsa_lag structure
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
 <20220221212337.2034956-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2022 1:23 PM, Vladimir Oltean wrote:
> The main purpose of this change is to create a data structure for a LAG
> as seen by DSA. This is similar to what we have for bridging - we pass a
> copy of this structure by value to ->port_lag_join and ->port_lag_leave.
> For now we keep the lag_dev, id and a reference count in it. Future
> patches will add a list of FDB entries for the LAG (these also need to
> be refcounted to work properly).
> 
> The LAG structure is created using dsa_port_lag_create() and destroyed
> using dsa_port_lag_destroy(), just like we have for bridging.
> 
> Because now, the dsa_lag itself is refcounted, we can simplify
> dsa_lag_map() and dsa_lag_unmap(). These functions need to keep a LAG in
> the dst->lags array only as long as at least one port uses it. The
> refcounting logic inside those functions can be removed now - they are
> called only when we should perform the operation.
> 
> dsa_lag_dev() is renamed to dsa_lag_by_id() and now returns the dsa_lag
> structure instead of the lag_dev net_device.
> 
> dsa_lag_foreach_port() now takes the dsa_lag structure as argument.
> 
> dst->lags holds an array of dsa_lag structures.
> 
> dsa_lag_map() now also saves the dsa_lag->id value, so that linear
> walking of dst->lags in drivers using dsa_lag_id() is no longer
> necessary. They can just look at lag.id.
> 
> dsa_port_lag_id_get() is a helper, similar to dsa_port_bridge_num_get(),
> which can be used by drivers to get the LAG ID assigned by DSA to a
> given port.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
