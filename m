Return-Path: <netdev+bounces-10468-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F4D72EA14
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98C4D2810AF
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186A83B8D5;
	Tue, 13 Jun 2023 17:42:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D01833E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:42:25 +0000 (UTC)
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BECA6;
	Tue, 13 Jun 2023 10:42:24 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 35DHfu9W084100;
	Tue, 13 Jun 2023 12:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1686678116;
	bh=igyZvlOfVcSf4nGPg6BKktZlYY6keooO5jqV4M4Sjf8=;
	h=Date:Subject:From:To:CC:References:In-Reply-To;
	b=GxpXVusBEQWpKJk8EBWTP2BMfzh9WPp8AV+k33AdMWxN4P+v8hMs6zUxuJDgxnwbH
	 0Q+oKfWMpNgZBmev9FwdcO+h35SbYXjFwi/be+J+7xOCvrnwn3msEPUShT7FPrvgAm
	 oYLb8mIxa09TV4psU4JfK4DwyfphqOMFfSi4fG+o=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 35DHfuOi122876
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Jun 2023 12:41:56 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 13
 Jun 2023 12:41:55 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 13 Jun 2023 12:41:55 -0500
Received: from [128.247.81.105] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 35DHftFR010861;
	Tue, 13 Jun 2023 12:41:55 -0500
Message-ID: <9905aefb-0d27-a4d6-b72d-5b852dc04465@ti.com>
Date: Tue, 13 Jun 2023 12:41:55 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v8 0/2] Enable multiple MCAN on AM62x
Content-Language: en-US
From: Judith Mendez <jm@ti.com>
To: <linux-can@vger.kernel.org>, Marc Kleine-Budde <mkl@pengutronix.de>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller"
	<davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Schuyler Patton <spatton@ti.com>,
        Tero Kristo
	<kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        <devicetree@vger.kernel.org>,
        Oliver
 Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>,
        Conor Dooley <conor+dt@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>
References: <20230530224820.303619-1-jm@ti.com>
In-Reply-To: <20230530224820.303619-1-jm@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi all,

On 5/30/23 5:48 PM, Judith Mendez wrote:
> On AM62x there are two MCANs in MCU domain. The MCANs in MCU domain
> were not enabled since there is no hardware interrupt routed to A53
> GIC interrupt controller. Therefore A53 Linux cannot be interrupted
> by MCU MCANs.
> 
> This solution instantiates a hrtimer with 1 ms polling interval
> for MCAN device when there is no hardware interrupt property in
> DTB MCAN node. The hrtimer generates a recurring software interrupt
> which allows to call the isr. The isr will check if there is pending
> transaction by reading a register and proceed normally if there is.
> MCANs with hardware interrupt routed to A53 Linux will continue to
> use the hardware interrupt as expected.
> 
> Timer polling method was tested on both classic CAN and CAN-FD
> at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
> switching.
> 
> Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
> 1 MBPS timer polling interval is the better timer polling interval
> since it has comparable latency to hardware interrupt with the worse
> case being 1ms + CAN frame propagation time and CPU load is not
> substantial. Latency can be improved further with less than 1 ms
> polling intervals, howerver it is at the cost of CPU usage since CPU
> load increases at 0.5 ms.
> 
> Note that in terms of power, enabling MCU MCANs with timer-polling
> implementation might have negative impact since we will have to wake
> up every 1 ms whether there are CAN packets pending in the RX FIFO or
> not. This might prevent the CPU from entering into deeper idle states
> for extended periods of time.

Was wondering if I am still pending some updates for this patch series? 
Or if any other issues please let me know. (: Thanks all

~ Judith

