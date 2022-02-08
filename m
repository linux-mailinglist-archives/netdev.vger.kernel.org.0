Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE6E4ACF3C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346219AbiBHCyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346192AbiBHCyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:54:36 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A87FC0401DF;
        Mon,  7 Feb 2022 18:54:34 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x4so5099254plb.4;
        Mon, 07 Feb 2022 18:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YQrZjm5FVCt3CzXB4OEDvbxS3DAlxh4k11n3126hcOQ=;
        b=f1Hp4a12Brw5KIuwLtuBeTMD4d/k1uEcg0p0jCUxc5ZVue5VGe1VezPKzZCtBgFKjZ
         SrwZcxT89FKzmvckqU7rFoeZZjqEBcSdtaYoirymHzs72auTaF7lCqBTBPMyZd/ZZEhf
         emQk0dQ9Lo0S1XcxerwC4rQH7Qj7YCg7Sr8xTCddl/TtuHqILwEHGZ1NCIsLD8+scZeS
         wd9qcViijEIbWJQGx7/hm6fqQ0ZMkMAjiQDZAgjMb02haawd1nD0eM6im/Jd48XNGIRU
         5fSkbxGpyeis4P5XJkRYpeC6n+IZhIQbkx68quV630GDawktwu3P0Ikd2yudgNs4tGEr
         Joig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YQrZjm5FVCt3CzXB4OEDvbxS3DAlxh4k11n3126hcOQ=;
        b=GmNv79+ZunJtRtobJCAMfzd8b16mVP3s93PIKuQjBGgP4QSt6/iAeJWd9Z+mYmIJ5H
         XJFdhvMhnNQ4RP5PPq/Yl4s27nKR/4I3/X9YxVv1DYbU0HmxGZPxBzYuL4YwkpyYY2LW
         taViwx96mqft7rvriOuVE7BbE8brFrs3L9KBNEHrHSUxYPb8HpgH+fC7MWEdnv4UFD5p
         I4l4WLm/gLtgTZz6A0j56txaqm5zEYV1KlVy4UbriHPt4OhmkknGw2H2DqtdWnIY8ZMd
         TlqfL+sPtseGUY7YtKMFvTxa7T7Pu66U9MTdLztkaQvt6z1mf6zkSvBkUUvFi4aa5K8I
         lxrg==
X-Gm-Message-State: AOAM530auQ8cXSJGsMFiTFTtOW8G850IXd/1gpeWiPLFApGPLOS0uKur
        Ztb39NYHQ8zjvpSLzgGKsSY=
X-Google-Smtp-Source: ABdhPJycgAVHfE38MvByjC6e/WUYVmp1S8kmKd3EG/Q7KMQqqXnFmuwRt8M8/mc7DacFBuzhVAk3lg==
X-Received: by 2002:a17:90b:1c06:: with SMTP id oc6mr2108714pjb.213.1644288873515;
        Mon, 07 Feb 2022 18:54:33 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o7sm12681802pfk.184.2022.02.07.18.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:54:32 -0800 (PST)
Message-ID: <4aaf6437-97f8-948c-f28e-47fb611c5423@gmail.com>
Date:   Mon, 7 Feb 2022 18:54:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v8 net-next 04/10] net: dsa: tag_ksz: add tag handling for
 Microchip LAN937x
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-5-prasanna.vengateshan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207172204.589190-5-prasanna.vengateshan@microchip.com>
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



On 2/7/2022 9:21 AM, Prasanna Vengateshan wrote:
> The Microchip LAN937X switches have a tagging protocol which is
> very similar to KSZ tagging. So that the implementation is added to
> tag_ksz.c and reused common APIs
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
