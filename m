Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225344BF05F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiBVD0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:26:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiBVD0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:26:01 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769B61D0F4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:25:37 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso1049700pjs.1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Sb2jolN0YxF4JNEtSfN6Y+YuGVBSOLNofuNSVtxbGq8=;
        b=aG3ORn2TpFqzBdeD6B2ktXwrpXyL4oD9SPdN4CaBFcPMjEWk5/QgFkkTDazHbmzF/m
         avpwP1rY8DvDmk0TbL1o7PRsVtsO4h6dSiw8kSzMEbCwd0E56kbehiQ3QZCx6E53plHR
         GHNTIxrgR1QTIjbeVhdkvtLulehgOql8Udv6MQvIFdlF2eVSZXXv7mrb59+Czh5pIgLY
         qCroyNXr3+DIEUNs9QWxGcjPdYLQ3TuRPNzsNS+WCyndyRP5ZPp4dmCKnQtOa6PLgqmv
         z9f9TlQ+skHZXjnODViwYatT2wJrAan7OaIWbAps5alZFIXMTksz00DQzaHF2+qZuf5K
         +Muw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Sb2jolN0YxF4JNEtSfN6Y+YuGVBSOLNofuNSVtxbGq8=;
        b=RUnpW7UYWuBLg+wkxkzzCi6vjT7UVSq0XnhdN8ShJFJN9IyQqFrlIDEzLyraRR9qzr
         yS2w4MzCeaikh7zSl1pVAGl/3u9PKCfyy8LN55NO96PtpkqaJm6SUlinVd+fKOpz4LqL
         aXnES9AH7tjdXn9bou0uhXYJTnux7g7NFko2rsyyna0vLK+9rB818SP3cDtEV68vMz+M
         BVBrNLaEVBUmlzgbZKZ0ySSBj6mngz2HLh0PiAvlZx7jlL3qX0gB9w496L6NdvPKdY7X
         K1vBb18RR2gx50jJJNmqsKwAcObnRS6rFnoEQSvh86YKyq1BPYChsJzPdNcTHNc6X1+K
         YHbA==
X-Gm-Message-State: AOAM5309zOKDdnqFklZ8G2mPtPAkROApZbMm9d6o4yPWS8Cw5u/d7Lrg
        vLEwwMpNc5KvwKI1DmKFxzM=
X-Google-Smtp-Source: ABdhPJwYOg6jssdvrzhZB/b51R8iLfoxH9zlx+I6csEWFLmVP9hg9ZmorrpuWOsOQxYPXsAVx4txuA==
X-Received: by 2002:a17:902:ea08:b0:14e:ea6c:7075 with SMTP id s8-20020a170902ea0800b0014eea6c7075mr21417555plg.103.1645500336959;
        Mon, 21 Feb 2022 19:25:36 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d8sm15131285pfj.179.2022.02.21.19.25.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:25:36 -0800 (PST)
Message-ID: <c36941e0-7609-0f42-2f99-6355c8c9bdab@gmail.com>
Date:   Mon, 21 Feb 2022 19:25:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 02/11] net: dsa: mv88e6xxx: rename references
 to "lag" as "lag_dev"
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
 <20220221212337.2034956-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-3-vladimir.oltean@nxp.com>
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
> In preparation of converting struct net_device *dp->lag_dev into a
> struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
> all occurrences of the "lag" variable in mv88e6xxx to "lag_dev".
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
