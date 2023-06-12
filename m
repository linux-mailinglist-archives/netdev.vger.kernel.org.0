Return-Path: <netdev+bounces-10163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42CDE72CA14
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EF1C1C20AEF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5071DDC6;
	Mon, 12 Jun 2023 15:30:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8108AD38
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:30:08 +0000 (UTC)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881001B8;
	Mon, 12 Jun 2023 08:30:07 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1b3cc77ccbfso7285315ad.1;
        Mon, 12 Jun 2023 08:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686583807; x=1689175807;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qt1TPwchcj2VuqrNTLbU1dI0zylo16OsUsxj0udlo1g=;
        b=LACI8dK6zyguXqfSuRhBMgacWIxDFOiIlKuWiEGI9nRXzKUBoYuoY3Qzp5RLzea3vT
         KngVfSTbq6B3LGU9zJxC0KV/iJNzpxuVMQX2mEcCGXWfZGQpUenoypaD1JY5hWcQZUkA
         NbgBBQWs/wL36/X5xP1fMsoBbQZ9rxNiv8MXfSNdmhr/5dlx6TLUZXhLFSF/4mZRdRXs
         leetK5TNVLy2r0Rnfv0qmXSUVzq2C+M0cWxOS7QlDjDsgELMNS0yzsCgF+WW3IREHFAP
         Z/ncCYv4H/PsoMY1Z2QAK03R4cWDQWPs1K16zmrEmaQhvso8GhxZnIlNEpUBoWQWYrMh
         rFMg==
X-Gm-Message-State: AC+VfDwadUGramQnMowR+ym69z8ftHouyy7UT/RVPfv6yW8FJQhsWFUr
	uMhjES1QZRhfCDxAqoTehME=
X-Google-Smtp-Source: ACHHUZ56brA+YWWAEz8TU4PAVsV02R+SWgJ96a3WKlbirAIjvLSNbBO5cimblvEo6LG/ezoxWr2djQ==
X-Received: by 2002:a17:903:2347:b0:1b1:99c9:8ce1 with SMTP id c7-20020a170903234700b001b199c98ce1mr7581876plh.51.1686583806811;
        Mon, 12 Jun 2023 08:30:06 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id jl1-20020a170903134100b001a245b49731sm6989724plb.128.2023.06.12.08.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 08:30:06 -0700 (PDT)
Message-ID: <de920a42-0d72-c5ec-1af9-8bfa4b954cfd@acm.org>
Date: Mon, 12 Jun 2023 08:30:03 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Content-Language: en-US
To: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, kuba@kernel.org,
 jiri@resnulli.us, vadfed@meta.com, jonathan.lemon@gmail.com,
 pabeni@redhat.com
Cc: corbet@lwn.net, davem@davemloft.net, edumazet@google.com, vadfed@fb.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, saeedm@nvidia.com,
 leon@kernel.org, richardcochran@gmail.com, sj@kernel.org,
 javierm@redhat.com, ricardo.canuelo@collabora.com, mst@redhat.com,
 tzimmermann@suse.de, michal.michalik@intel.com, gregkh@linuxfoundation.org,
 jacek.lawrynowicz@linux.intel.com, airlied@redhat.com, ogabbay@kernel.org,
 arnd@arndb.de, nipun.gupta@amd.com, axboe@kernel.dk, linux@zary.sk,
 masahiroy@kernel.org, benjamin.tissoires@redhat.com,
 geert+renesas@glider.be, milena.olech@intel.com, kuniyu@amazon.com,
 liuhangbin@gmail.com, hkallweit1@gmail.com, andy.ren@getcruise.com,
 razor@blackwall.org, idosch@nvidia.com, lucien.xin@gmail.com,
 nicolas.dichtel@6wind.com, phil@nwl.cc, claudiajkang@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-rdma@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 poros@redhat.com, mschmidt@redhat.com, linux-clk@vger.kernel.org,
 vadim.fedorenko@linux.dev
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/9/23 05:18, Arkadiusz Kubalewski wrote:
> diff --git a/Documentation/driver-api/dpll.rst b/Documentation/driver-api/dpll.rst
> new file mode 100644
> index 000000000000..8caa4af022ad
> --- /dev/null
> +++ b/Documentation/driver-api/dpll.rst
> @@ -0,0 +1,458 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===============================
> +The Linux kernel dpll subsystem
> +===============================
> +
> +The main purpose of dpll subsystem is to provide general interface
> +to configure devices that use any kind of Digital PLL and could use
> +different sources of signal to synchronize to as well as different
> +types of outputs.
> +The main interface is NETLINK_GENERIC based protocol with an event
> +monitoring multicast group defined.

A section that explains what "DPLL" stands for is missing. Please add 
such a section.

Thanks,

Bart.


