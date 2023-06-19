Return-Path: <netdev+bounces-12022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B96FE735B1E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75DDC28104E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CC112B88;
	Mon, 19 Jun 2023 15:27:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75B612B72
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:27:49 +0000 (UTC)
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5350BB8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:27:48 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-76246351f0cso264357285a.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687188467; x=1689780467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pG/0VqAr5SYrcT6wO2Az9GEqI0fnR+i6EJpjLv4oLOo=;
        b=Iq1vuBSKURTTkBmyJMPPdjanQtcTzAHocWkDi0ilqv0IQSyKgP5CX40/0gYIExdtWI
         UTSAuq9KNAV+yka4ugaURCuPnAkw4jg1EK6VtazKS1aYwgQihRmRaxKenE/REH2w4R1q
         VomOgQJOYBGDPkTjyLkFN+8yiG4fh6aJPZh1zhQPAWXC+P+Dc8oxR/C2DxdNHIKva7/W
         hvfp1kW2L5Nv3VdbjUnrQDdYxKl2HQVNRFDjjw5n5hQPk5zf0uj7or9UpU4FuQ7BdsEC
         +Hmo7RQ36jdFxl8Jijt8iI3nj/rU2VFETBPHb7d9mwMN3Xz0zereJcXTkkQRLbnPn2gy
         w2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687188467; x=1689780467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pG/0VqAr5SYrcT6wO2Az9GEqI0fnR+i6EJpjLv4oLOo=;
        b=awa/DUNSJeep+TTS/wUn9Z7QCrqqNq/7lKwJtCHX3ixzJaojCcc3pWVubSfEqyyy7T
         LdbHhEoEczBQfYwYtjBcqPdPkFu+7WQ0uO1xbNbeZFGXN2VLE5vE+YYmlWGs5jWwRFyl
         N5/xkAEDSwLFbO5XQbZ6mYpIfDsFlhqWw4wL/18WiTth3FQgv6oGVk0EafoxT3/82OHa
         MeackMy1Zi3iK0AuMqge3xA8f56KGd4wjuYd+xf8lkoGyGCc6KCrMu+M3jHud5KzuOEM
         MUEeqEDlENbd11dwA2mFFd4Bs+6bc8nZ1M6M/C4K1VJY6QPNg2iA+dMVgSP6ZuYRmcd/
         v5Vg==
X-Gm-Message-State: AC+VfDyh0+ZA3r1ddk+xURzdjAdAPBIA2AbxaBtlRwOgxcIVj9bmsytp
	/eG5wRJs0YSXw7WMqHbTUmnkVZCQLX9Nq1Xb
X-Google-Smtp-Source: ACHHUZ5QxAllLyXDih+2GPMDNwpT13n8deCI/hc2mNLZ3vXsrzPYmvhdBk6rBc51YXT1sx6ew3+oMg==
X-Received: by 2002:a05:620a:4881:b0:75d:5534:865d with SMTP id ea1-20020a05620a488100b0075d5534865dmr1492356qkb.60.1687188467284;
        Mon, 19 Jun 2023 08:27:47 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id m25-20020ae9e719000000b00761ff1e23e1sm28618qka.109.2023.06.19.08.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 08:27:46 -0700 (PDT)
Message-ID: <370c6ec6-0608-44b4-d5ff-44b8ca1b0678@gmail.com>
Date: Mon, 19 Jun 2023 16:27:42 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 net-next 5/9] net: phy: Keep track of EEE configuration
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
 Heiner Kallweit <hkallweit1@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230618184119.4017149-1-andrew@lunn.ch>
 <20230618184119.4017149-6-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230618184119.4017149-6-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/18/2023 7:41 PM, Andrew Lunn wrote:
> Have phylib keep track of the EEE configuration. This simplifies the
> MAC drivers, in that they don't need to store it.
> 
> Future patches to phylib will also make use of this information to
> further simplify the MAC drivers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

With both Simon's and Russell's feedback addressed:

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

