Return-Path: <netdev+bounces-2717-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5707033F7
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2A751C20C63
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010CEDF53;
	Mon, 15 May 2023 16:43:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E917CFBEA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:43:38 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F4049C7;
	Mon, 15 May 2023 09:43:30 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1pybIG-0007b4-AX; Mon, 15 May 2023 18:43:28 +0200
Message-ID: <547c4c61-26af-ee0d-146f-d0db077dc53f@leemhuis.info>
Date: Mon, 15 May 2023 18:43:27 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Fwd: Freeze after resuming from hibernation (culprit is brcmfmac
 change?)
Content-Language: en-US, de-DE
To: Bagas Sanjaya <bagasdotme@gmail.com>, Hans de Goede
 <hdegoede@redhat.com>, Linux Regressions <regressions@lists.linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Wireless <linux-wireless@vger.kernel.org>,
 Broadcom 80211 Devices <brcm80211-dev-list.pdl@broadcom.com>,
 SHA cyfmac Subsystem <SHA-cyfmac-dev-list@infineon.com>,
 Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>,
 Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
 Franky Lin <franky.lin@broadcom.com>,
 Arend van Spriel <arend.vanspriel@broadcom.com>,
 Kalle Valo <kvalo@kernel.org>, julien.falque@gmail.com
References: <018f62d0-ee1d-9198-9c38-e45b10921e2e@gmail.com>
 <f629341e-5920-8061-6120-cb954d22ffe9@redhat.com>
 <b3bb9fc7-c7ec-ad32-5d6f-e6ba55e2dd7d@gmail.com>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <b3bb9fc7-c7ec-ad32-5d6f-e6ba55e2dd7d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1684169010;5867046c;
X-HE-SMSGID: 1pybIG-0007b4-AX
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15.05.23 15:09, Bagas Sanjaya wrote:
> On 5/15/23 15:56, Hans de Goede wrote:
>> On 5/15/23 04:21, Bagas Sanjaya wrote:
>>> I notice a regression report on bugzilla [1]. Quoting from it:
> [...]
>>>> A bisect on linux-git gave commit da6d9c8ecd00 as the cause of the problem.
>>
>> da6d9c8ecd00e2 is known to cause a NULL pointer deref on resume,

Bagas, fwiw, to prevent situations like these I usually search on lore
for a shorted variant of the commit-id[1] before telling regzbot about
it. In quite a lot of cases I find something useful that might mean that
tracking is not worth it.

Ciao, Thorsten

e.g. [1] https://lore.kernel.org/all/?q=da6d9c8*


