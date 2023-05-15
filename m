Return-Path: <netdev+bounces-2457-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A1C7020FD
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 03:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 689A728107A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 01:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A10B10F6;
	Mon, 15 May 2023 01:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B91210EA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 01:13:06 +0000 (UTC)
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6142F10E9;
	Sun, 14 May 2023 18:13:04 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
	by mail.fintek.com.tw with ESMTP id 34F1AcMn020536;
	Mon, 15 May 2023 09:10:38 +0800 (+08)
	(envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.132] (192.168.1.132) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Mon, 15 May 2023
 09:11:34 +0800
Message-ID: <39d076f3-e569-4b3b-84bf-95222cd61084@fintek.com.tw>
Date: Mon, 15 May 2023 09:11:34 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH V7] can: usb: f81604: add Fintek F81604 support
Content-Language: en-US
To: Marc Kleine-Budde <mkl@pengutronix.de>, kernel test robot <lkp@intel.com>
CC: <wg@grandegger.com>, <michal.swiatkowski@linux.intel.com>,
        <Steen.Hegelund@microchip.com>, <mailhol.vincent@wanadoo.fr>,
        <oe-kbuild-all@lists.linux.dev>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <frank.jungclaus@esd.eu>, <linux-kernel@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <hpeter+linux_kernel@gmail.com>
References: <20230509073821.25289-1-peter_hong@fintek.com.tw>
 <202305091802.pRFS6n2j-lkp@intel.com>
 <20230509-exert-remindful-0c0e89bf6649-mkl@pengutronix.de>
From: Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <20230509-exert-remindful-0c0e89bf6649-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.132]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27556.001
X-TM-AS-Result: No-4.907600-8.000000-10
X-TMASE-MatchedRID: u1zqiMeMcrr/9O/B1c/Qy2lHv4vQHqYTlmG/61+LLCeqvcIF1TcLYLsV
	j+wJQ/DT1jypNY0wtaY54EyL9veg949oUcx9VMLggxsfzkNRlfLDFBDwCdpNg0wQJkEy6Z1woHE
	PeeNER2GyO81X3yak84d8CtEuyFUaA2q11tvr8mMjdLV77rKHnlPf+ByMkMZD+e3Avc4jI5OvBz
	U2rdyC9DF/WWtww9VAdk6Voc0bfMvlHW8KsUL5rQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.907600-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27556.001
X-TM-SNTS-SMTP:
 8B2FD82F36336AD536AF1B47D7B2C316C4C70055CAD1C471AF148E44ED80F2F02000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:mail.fintek.com.tw 34F1AcMn020536
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Marc,

Marc Kleine-Budde 於 2023/5/9 下午 08:14 寫道:
> Replaced "%lu% by "%zu" while applying the patch.
>
> Marc
>

Should I fix the warning and resend the patch as v8? or you will modify 
the v7 before apply it?

Thanks

