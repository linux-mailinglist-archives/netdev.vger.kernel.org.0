Return-Path: <netdev+bounces-6515-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3F0716BDD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA80A2811F0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4292A9E8;
	Tue, 30 May 2023 18:04:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42451EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:04:03 +0000 (UTC)
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9942C107
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:04:02 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-3f6ac005824so43643171cf.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685469841; x=1688061841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=USkm4TzRyP4ByzUf08vQ6j0hn2VrtE+7q7klbWx014M=;
        b=V1fJFh/WtW0BIh0qZ+KRZbiijVNDQIupl07wCtexVrikj+ab4b8tQUUHKXWuBwk5cX
         oC0GHs5fHHbk1YZrjq4/r11DE4tnWTxXydJe6h3wyjVJxEp2wGrDUMKNBdoP9gHIR2Ng
         TRhYlo1VN+l2giQnbe180QZg6XOyKkbekVmaDMQND1KSmkyHHowQ2odl2u/Am1pRzUZY
         bx1q3ejYZwqszzDpjePz2oQKdnUdUdKjnWT5WP1JJK5Jaye9m7vsWKX+Zw6I+bWamsze
         GMr9SDawipfg+g0xN0kPUYo8ODX7DHvZsC7girK+Bld7SV5XJib7nUy6UyVXIjpRY2X8
         UyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685469841; x=1688061841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=USkm4TzRyP4ByzUf08vQ6j0hn2VrtE+7q7klbWx014M=;
        b=Syp+u9vVu2cWZf39dHP+aSzH91goo3NB6wGAVo9XDJ1s6ZQ1Z42Ww/s7aEEcJVfA7H
         VlHdiIkXJx8WF6Abz2AeNsCbF+/kTuDvcgukvJ+yUKw9sKKRJiKNVB+Kc3TGl3+bO4cL
         ajpaWWEqC/Bn41UGnHDIR1aSI6+IfG/KcTZuqFJddETVks/y5gfd3T/QFu0zLTT4WmWB
         t/wGf93JXMHtQHJdWJpdjBqR4QRlxAjEqZv+URbwv9tmHxuttOSJFjftp8pkbtsCLW6a
         YTQ1fnDXQAlLhF+h1+iKYye4DgidvvWyVo2+7KBfxA8RJf7O0xps7C9wsKu5Occ/ol0O
         hQLw==
X-Gm-Message-State: AC+VfDxa4n2f3nvSE3bRIHk+wvQB62ASMCOHRd0fUCHVGda7hI1ABnhT
	0IvDEjKwma2XFSQfSBUZyLw=
X-Google-Smtp-Source: ACHHUZ5e0SNj0om56F1alM406kqgzXPQzf7eupYdGlN8pgg5t14sBcox2kcgYJ1SA7l7gOu5YHzOPg==
X-Received: by 2002:a05:6214:130c:b0:626:2461:9f09 with SMTP id pn12-20020a056214130c00b0062624619f09mr3932349qvb.40.1685469841032;
        Tue, 30 May 2023 11:04:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w2-20020a0cef82000000b005e750d07153sm2875347qvr.135.2023.05.30.11.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:04:00 -0700 (PDT)
Message-ID: <e03e8ae9-8ae3-4035-8839-b72bde8e65d8@gmail.com>
Date: Tue, 30 May 2023 11:03:54 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 07/24] net: marvell: mvneta: Simplify EEE
 configuration
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-8-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-8-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 3/30/23 17:55, Andrew Lunn wrote:
> phylib already does most of the work. It will track eee_enabled,
> eee_active and tx_lpi_enabled and correctly set them in the
> ethtool_get_eee callback.
> 
> Replace the call to phy_init_eee() by looking at the value of
> eee_active passed to the mac_set_eee callback.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcon.com>
-- 
Florian


