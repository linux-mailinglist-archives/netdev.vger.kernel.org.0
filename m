Return-Path: <netdev+bounces-6276-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C84767157B0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CA832810AC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA2A125D5;
	Tue, 30 May 2023 07:55:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9A5125CC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71025C433EF;
	Tue, 30 May 2023 07:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685433322;
	bh=8ZdTOa03jdrIEEMTRubaTPNotfGUbHnWuYuQN/xtOPA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pZTF2iPEAyO8W9Utdy4WVirRx29yvcU1kmInYUI3eNQMllXS+VOlwBK05kE4cjMxm
	 iT9hShvfgQRfHdzjKYv0DOEqATP1TAWzLwnevJEwSTONFyqhoUJow0AyIu9DOmiuf/
	 FrofSDhfMRE4axz/VDizJeMojrALTfc8JO5H6NEBKIJww4JAw+HE/ifoy8w7RZ5XTM
	 qav5qHfQL/LZqApbRShIy2S4xYnoc4V2YwhXkLIF31fE41+oJqdf61xZIYtkFz8Hj0
	 sXAXTjeGZy7wLLDsAyg0GKY24Z1D/n5oKbLDtnqMHzs77yXpHvyuFYSMVMWsvwcj8N
	 gusvJxpYikayw==
Message-ID: <43d8b745-ea0e-4359-8291-be750abab41a@kernel.org>
Date: Tue, 30 May 2023 09:55:15 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] dt-bindings: net: Add QCA2066 Bluetooth
Content-Language: en-US
To: "Tim Jiang (QUIC)" <quic_tjiang@quicinc.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Balakrishna Godavarthi (QUIC)" <quic_bgodavar@quicinc.com>,
 "Hemant Gupta (QUIC)" <quic_hemantg@quicinc.com>
References: <20230518092719.11308-1-quic_tjiang@quicinc.com>
 <fb3678d67fd4428eaec98365288384ed@quicinc.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <fb3678d67fd4428eaec98365288384ed@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/05/2023 09:49, Tim Jiang (QUIC) wrote:
> Hi krzk:
>   Could you help review this patch ?

Did you send it to me (as asked by get_maintainers.pl)?

> 
> Regards.
> Tim
> 
> 
> -----Original Message-----
> From: Tim Jiang (QUIC) <quic_tjiang@quicinc.com> 
> Sent: Thursday, May 18, 2023 5:27 PM
> To: krzk@kernel.org
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; Balakrishna Godavarthi (QUIC) <quic_bgodavar@quicinc.com>; Hemant Gupta (QUIC) <quic_hemantg@quicinc.com>; Tim Jiang (QUIC) <quic_tjiang@quicinc.com>

I think not...

Best regards,
Krzysztof


