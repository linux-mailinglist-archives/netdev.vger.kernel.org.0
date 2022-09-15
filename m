Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261F45BA1BF
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiIOUP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIOUP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:15:56 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13DC1145A
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:15:54 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id ay9so3799515qtb.0
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=wl1OJcJp9uKN318CPGju3IjZkuheVXA2Bhr0aUwutTc=;
        b=PIhX2PX3lFVDPLjs8Kk50MNroCyLtHKfdg8kNHA+6rhMcqmXb9RY4pwE+REtE2IwB+
         88NUxlNNE8V0xInhxvgbsV+b6Jj0Tzuf+XLEIH5AVmAz9HHTST/kUsDWrlE6s/LfSfp1
         LkADduOElnX9YBIn1vP+GpxaYOEzyDfpad3hriM6XoNSyVdCns9vZiGTtx9nKrWMj4TT
         FDxTWNFXBAkHmjrDXizFHY4h0hUzsoufnJeBr/b8uqi8WGjXYmm3LrYUZHrA2RQNvaUL
         5ngMSAyrv4VwEi1jSNOIt3mWCctniZbmBYvvgPCc/qL9F+Ak/wxQFul72ruasIDc7i+Q
         wKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=wl1OJcJp9uKN318CPGju3IjZkuheVXA2Bhr0aUwutTc=;
        b=OV4/yXHmWHA0HHXJiudlDuFPbHSyqSy7WpiUX8f9GYxRFfn8oSu/l1zh0PIV3N9jzO
         J/ah5dDxx0OASxeAXibNdnT/m3NKbQb5xnxTkubj8nh/TyLC4ROp7w/pE3+N7HPL3JH1
         wy7RK14tiJBFOaZ+gXLoCzvLdyvs1OrznAsY0KXLBeEdVq4Qu0cY+gdeCkEjSv1Y8bEt
         tWVRQnBiA1CdOly/NwX1uXnuGmvAnewDTGqYbljSAi4T0oJjteQ/QO9YZkyvxR6aaVeZ
         4mpul/ESJkyzOVMEP+2jimqIEj1gONJ5LhN0Ra3R7bOp/kws36Z5HMxs18D3ycOXKhBZ
         W23w==
X-Gm-Message-State: ACrzQf3pN3JsC/g6I3zsJrncGCdKggoW+yvGrlRXta5GivAG9L/WeoIX
        CqjOS1yh2+NlnfTOd1PhCPk=
X-Google-Smtp-Source: AMsMyM5TvVibtJLfXYJJI4PO90YASUJYZuzzs9lw2+/qKXU6ypxBAyo08BEg7hL4ZxlCfYaTrFrQWQ==
X-Received: by 2002:a05:622a:48f:b0:35b:bbf5:7a82 with SMTP id p15-20020a05622a048f00b0035bbbf57a82mr1604393qtx.564.1663272953786;
        Thu, 15 Sep 2022 13:15:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g5-20020a37b605000000b006bc192d277csm4586754qkf.10.2022.09.15.13.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 13:15:53 -0700 (PDT)
Message-ID: <fe1a3fd0-3365-44cb-3ac8-d2c3a6cdffc0@gmail.com>
Date:   Thu, 15 Sep 2022 13:15:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v12 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
 <20220915143658.3377139-5-mattias.forsblad@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220915143658.3377139-5-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/22 07:36, Mattias Forsblad wrote:
> The Marvell SOHO switches supports a secondary control
> channel for accessing data in the switch. Special crafted
> ethernet frames can access functions in the switch.
> These frames is handled by the Remote Management Unit (RMU)
> in the switch. Accessing data structures is specially
> efficient and lessens the access contention on the MDIO
> bus.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
