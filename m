Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A101CA0FF
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 04:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgEHCjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 22:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgEHCjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 22:39:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6AFC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 19:39:14 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b8so56135plm.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 19:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tSuSatxDEwYouHXZqQgIBTQkNfpDn89GZl4VS66GSY8=;
        b=VJ2fTHiWHYEytCpdaNLsshS607PLSFnHrTGN2r7eCZsEM2mw21q6mooZ5HiOuG2iEg
         d894OqhjxZP31fqPeYzOot0p07SDG8VPWgfyvFO/XDfnzwN8oaVBJ+fpljw6GWzKvY4q
         xXnnygfVqYTm9dLdAbFRBWCBpUVZ/+Yi/TZ1DeuLob2m/CGHD4UYbC6FM9OIhtSnphGE
         6iqVDAQHSS3RnCDMD6O7qwFfDrzCh9kH9izneS+XDobZr0Ye2ftkO9YV9JupCIqnGE7s
         NaypDNYa42ghOTfZ4/po2xC7/Tt1/px9ocCaFSw67ZAa1sLF11mA3t7AJ8boMqipC+xn
         8IoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tSuSatxDEwYouHXZqQgIBTQkNfpDn89GZl4VS66GSY8=;
        b=q3vYJh8XpM0tMa2+gclw1frP2SDvF4lz246Vcz6EZQWuo/JoGhl27the+gJigAE1U0
         77WwU4kzJuMMup2q++3TA12hXzsMCNh1r/rIy1pFLzDQaARluvhM6wHylYrFO9wVnyYl
         8AVqBzY0bEXRmbquG/zFbfEjRTYn2vALl+ZHiuYLANHizJuWGQjB5Do2OTeUCAoZhz4U
         FKaH3H+vJPGonfoVry84h9NRkS1dvqfi+yK/WCBE13oMC1e1RMtFMF7Z85nUfcGThaHP
         V0dhqFU37RdfxP2euif7vWDjuCpi8cnq7wx+dm/Zl7u7PAapMjAlODRAKFnhgSwHtjRF
         e2qA==
X-Gm-Message-State: AGi0Pub3iHHU86jPiA7TTuTfJnoO0Penq/20q3mdu+kao7COg5GHsv+8
        xzehSoAdZ4d1w7N7Xg2OInE=
X-Google-Smtp-Source: APiQypK8HFmLgrODu4q0g+pECYKLSxsHyD1vp/2FTFoPOxL2f34DdWsmP5N6cnEcfwBurOhgFlJsig==
X-Received: by 2002:a17:902:a60a:: with SMTP id u10mr192557plq.249.1588905553986;
        Thu, 07 May 2020 19:39:13 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w11sm204517pgj.4.2020.05.07.19.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 19:39:10 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 3/4] net: dsa: introduce a dsa_switch_find
 function
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
References: <20200503221228.10928-1-olteanv@gmail.com>
 <20200503221228.10928-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1c145804-d3e1-3217-9714-18356cd4b374@gmail.com>
Date:   Thu, 7 May 2020 19:39:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503221228.10928-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 3:12 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Somewhat similar to dsa_tree_find, dsa_switch_find returns a dsa_switch
> structure pointer by searching for its tree index and switch index (the
> parameters from dsa,member). To be used, for example, by drivers who
> implement .crosschip_bridge_join and need a reference to the other
> switch indicated to by the tree_index and sw_index arguments.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
